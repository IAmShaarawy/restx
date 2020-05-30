import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tables extends StatefulWidget {
  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('tables').orderBy("number").snapshots(),
        builder: (context, snapshot) {
          return ListView(
              children: snapshot.data.documents.map((document) {
            return Card(
              child: ListTile(
                onTap: goToTable,
                title: Text("Table # ${document['number']}"),
                enabled: document['current_user'] != null,
                subtitle: formTableSubTitle(document),
              ),
            );
          }).toList());
        });
  }

  Widget formTableSubTitle(DocumentSnapshot doc) {
    if (doc["current_user"] == null) return null;

    int platesCount = (doc["plates"] as List).length;

    return Text("$platesCount plates");
  }

  void goToTable() {}
}
