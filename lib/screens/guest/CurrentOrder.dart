import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';

class CurrentOrder extends StatefulWidget {
  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.swap_calls,
              color: Colors.white,
            ),
            tooltip: "Table",
            onPressed: _onChangeTable,
          ),
        ],
      ),
      body: Center(
        child: Text("Current Order"),
      ),
    );
  }

  void _onChangeTable() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: _buildChangeTableBottomSheet(),
            ),
          );
        },
        useRootNavigator: true);
  }

  Widget _buildChangeTableBottomSheet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashColor: Colors.teal,
              iconSize: 100,
              icon: Icon(
                Icons.swap_calls,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, ROUTE_QR);
              },
            ),
            Text(
              "Change Table",
              style: TextStyle(color: Colors.teal),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashColor: Colors.redAccent,
              iconSize: 100,
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                await clearTable();
                await Navigator.pushNamedAndRemoveUntil(
                    context, ROUTE_QR, ModalRoute.withName("/"));
              },
            ),
            Text(
              "Leave Table",
              style: TextStyle(color: Colors.redAccent),
            )
          ],
        ),
      ],
    );
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
