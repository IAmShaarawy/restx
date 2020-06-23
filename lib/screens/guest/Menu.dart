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
      body: formCat(),
    );
  }

  Widget formCat() => StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("category").snapshots(),
        builder: (ctx, ss) => !ss.hasData
            ? Loading()
            : ListView(
                padding: EdgeInsets.all(16),
                children: ss.data.documents
                    .map((doc) => GestureDetector(
                          onTap: () =>
                              onTapCat(ctx, doc.documentID, doc.data["name"]),
                          child: SizedBox(
                            height: 300,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              margin: EdgeInsets.all(8),
                              child: Stack(
                                  overflow: Overflow.visible,
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.network(
                                      doc.data["img"],
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      color: Color.fromRGBO(0, 0, 0, 0.60),
                                    ),
                                    Center(
                                        child: Text(
                                      doc.data["name"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )),
                                  ]),
                            ),
                          ),
                        ))
                    .toList(),
              ),
      );

  onTapCat(BuildContext ctx, String docID, String catName) {
    Navigator.pushNamed(ctx, ROUTE_CAT_ITEMS,
        arguments: {"cat_id": docID, "cat_name": catName});
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
