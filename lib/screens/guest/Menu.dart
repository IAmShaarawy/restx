import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _catId = "AzpoKyo5AnCYsyE2PuaT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings_power,
              color: Colors.white,
            ),
            tooltip: "Logout",
            onPressed: () async {
              await clearTable();
              await FirebaseAuth.instance.signOut();
              navigatorKey.currentState.pushReplacementNamed(ROUTE_AUTH);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          formCat(),
          Expanded(
            child: formMenu(_catId),
          )
        ],
      ),
    );
  }

  Widget formCat() => StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("category").snapshots(),
        builder: (ctx, ss) => !ss.hasData
            ? Container()
            : SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ss.data.documents
                      .map((doc) => GestureDetector(
                            onTap: () => onChangeCat(doc.documentID),
                            child: Card(
                              elevation: _catId == doc.documentID ? 8 : 0,
                              shadowColor: Colors.lightBlue,
                              margin: EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text(doc.data["name"])),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
      );

  onChangeCat(String docID) {
    setState(() {
      this._catId = docID;
    });
  }

  Widget formMenu(String catId) => StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('menu')
          .where("cat", isEqualTo: catId)
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData || snapshot.data.documents.length == 0
            ? Center(
                child: Text("Doesn't have plates"),
              )
            : ListView(
                children: snapshot.data.documents.map((document) {
                print(document['name']);
                print(document['price']);
                return Card(
                  child: StreamBuilder<QuerySnapshot>(
                      stream:
                          document.reference.collection('items').snapshots(),
                      builder: (context, snapshot) {
                        return ListTile(
                          onTap: () async {
                            await updateOrderWithPlates(document.documentID);
                          },
                          title: Text(document['name']),
                          subtitle: Text("${document['price']} L.E"),
                          leading: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(document['img'])),
                        );
                      }),
                );
              }).toList());
      });

  updateOrderWithPlates(String plateId) async {
    var orderId = await currentTableOrderId();
    var orderRef = Firestore.instance.collection("orders").document(orderId);
    var plates = (await orderRef.get()).data["plates"];
    plates.add(plateId);
    print(plates);
    await orderRef.setData({"plates": plates}, merge: true);
  }

  Future<String> currentTableOrderId() async {
    var userId = (await FirebaseAuth.instance.currentUser()).uid;
    var tablesRef = Firestore.instance.collection("tables");
    var table = (await tablesRef
            .where("current_user", isEqualTo: userId)
            .limit(1)
            .getDocuments())
        .documents[0];

    return table.data["order_id"];
  }

  clearTable() async {
    var userId = (await FirebaseAuth.instance.currentUser()).uid;
    var tablesRef = Firestore.instance.collection("tables");
    var tableId = (await tablesRef
            .where("current_user", isEqualTo: userId)
            .limit(1)
            .getDocuments())
        .documents[0]
        .documentID;
    await tablesRef
        .document(tableId)
        .setData({"current_user": null, "order_id": null}, merge: true);
  }
}
