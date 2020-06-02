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
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('menu').snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Loading()
                : ListView(
                    children: snapshot.data.documents.map((document) {
                    print(document['name']);
                    print(document['price']);
                    return Card(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: document.reference
                              .collection('items')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return ListTile(
                              onTap: () async {
                                await updateOrderWithPlates(
                                    document.documentID);
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
          }),
    );
  }

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
        .setData({"current_user": null, "plates": []}, merge: true);
  }
}
