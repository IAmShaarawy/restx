import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';

class PreviousOrders extends StatefulWidget {
  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.currentUser().asStream(),
        builder: (ctx, uss) => !uss.hasData
            ? Loading()
            : StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("orders")
                    .where("user", isEqualTo: uss.data.uid)
                    .snapshots(),
                builder: (ctx, ss) => !ss.hasData
                    ? Loading()
                    : ListView(
                        children: ss.data.documents
                            .where((doc) => doc.data["state"] == ARCHIVED)
                            .where((doc) =>
                                (doc.data["plates"] as List).length > 0)
                            .map((doc) => SizedBox(
                                height: 150,
                                child: Card(
                                  child: formOrderItem(
                                      (doc.data["plates"] as List)
                                          .cast<String>()),
                                )))
                            .toList(),
                      ),
              ),
      ),
    );
  }

  Widget formOrderItem(List<String> items) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: groupPlates(items)
          .entries
          .map(
            (e) => StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection("menu")
                  .document(e.key)
                  .snapshots(),
              builder: (ctx, ss) => !ss.hasData
                  ? Loading()
                  : SizedBox(
                      height: 125,
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            ss.data.data["img"],
                            height: 110,
                          ),
                          Text("#${e.value}#${ss.data.data["name"]}")
                        ],
                      ),
                    ),
            ),
          )
          .toList(),
    );
  }

  Map<String, int> groupPlates(List plates) {
    Map<String, int> groupedPlates = {};
    plates.sort((e1, e2) {
      return e1.compareTo(e2);
    });
    plates.forEach((e) {
      groupedPlates.update(e, (v) {
        return v + 1;
      }, ifAbsent: () {
        return 1;
      });
    });
    return groupedPlates;
  }
}
