import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';

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
          FlatButton(
            child: Icon(Icons.settings_power),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((result) {
                navigatorKey.currentState.pushReplacementNamed(ROUTE_AUTH);
              });
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('menu').snapshots(),
          builder: (context, snapshot) {
            return ListView(
                children: snapshot.data.documents.map((document) {
              print(document['name']);
              print(document['price']);
              return Card(
                child: StreamBuilder<QuerySnapshot>(
                    stream: document.reference.collection('items').snapshots(),
                    builder: (context, snapshot) {
                      return ListTile(
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
}
