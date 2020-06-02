import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';

class Tables extends StatefulWidget {
  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('tables')
            .orderBy("number")
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Loading()
              : GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.documents.map((document) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection("orders")
                            .document(document.data["order_id"])
                            .snapshots(),
                        builder: (context, orderSS) {
                          return !orderSS.hasData
                              ? Loading()
                              : GestureDetector(
                                  onTap: !orderSS.data.exists
                                      ? null
                                      : () {
                                          goToOrder(context,
                                              document.data["order_id"],document.data["number"]);
                                        },
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        children: <Widget>[
                                          QrImage(
                                            data: document.documentID,
                                            version: QrVersions.auto,
                                            size: 140,
                                          ),
                                          Text("Table # ${document['number']}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title),
                                          formTableSubTitle(orderSS.data),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        });
                  }).toList());
        });
  }

  Widget formTableSubTitle(DocumentSnapshot doc) {
    if (!doc.exists)
      return Text(
        "Free table",
        style: TextStyle(color: Colors.greenAccent),
      );
    if (doc["waiter"] != null)
      return Text(
        "Taking care of it",
        style: TextStyle(color: Colors.blueAccent),
      );

    int platesCount = (doc["plates"] as List).length;

    return Text(
      "Serve $platesCount plates now",
      style: TextStyle(color: Colors.redAccent),
    );
  }

  void goToOrder(BuildContext ctx, String id, int tableNumber) {
    Navigator.pushNamed(ctx, ROUTE_TABLE_ORDER,
        arguments: {"id": id, "table_number": tableNumber});
  }
}
