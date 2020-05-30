import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Loading.dart';

class Table extends StatefulWidget {
  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    String tableId = ModalRoute.of(context).settings.arguments;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('tables')
            .document(tableId)
            .snapshots(),
        builder: (context, ss) {
          return !ss.hasData
              ? Loading()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Table # ${ss.data.data['number']}"),
                  ),
                  body: GridView.count(
                    crossAxisCount: 2,
                    children: (ss.data.data["plates"] as List).map((p) {
                      return Card(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection("menu")
                                .document(p.toString())
                                .snapshots(),
                            builder: (context, ss1) {
                              return !ss1.hasData
                                  ? Loading()
                                  : Container(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.network(
                                            ss1.data.data["img"],
                                            width: 150,
                                          ),
                                          Text(ss1.data.data["name"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title),
                                        ],
                                      ),
                                    );
                            }),
                      );
                    }).toList(),
                  ),
                );
        });
  }
}
