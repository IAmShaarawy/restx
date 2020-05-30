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
                    return GestureDetector(
                      onTap: () {
                        goToTable(context, document.documentID);
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
                                  style: Theme.of(context).textTheme.title),
                              formTableSubTitle(document),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList());
        });
  }

  Widget formTableSubTitle(DocumentSnapshot doc) {
    if (doc["current_user"] == null) return SizedBox();

    int platesCount = (doc["plates"] as List).length;

    return Text(
      "$platesCount plates",
      style: TextStyle(color: Theme.of(context).accentColor),
    );
  }

  void goToTable(BuildContext ctx, String id) {
    Navigator.pushNamed(ctx, ROUTE_WAITER_TABLE, arguments: id);
  }
}
