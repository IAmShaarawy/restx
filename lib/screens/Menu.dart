import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            child: Icon(
              Icons.time_to_leave,
              color: Colors.white,
            ),
            onPressed: () async {
              await (await SharedPreferences.getInstance())
                  .setString(TABLE_NUMBER, null);
              await FirebaseAuth.instance.signOut();
              navigatorKey.currentState.pushReplacementNamed(ROUTE_AUTH);
            },
          ),
          FlatButton(
            child: Icon(
              Icons.swap_calls,
              color: Colors.white,
            ),
            onPressed: _onChangeTable,
          ),
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

  void _onChangeTable() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 50,
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
        });
  }

  Widget _buildChangeTableBottomSheet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          child: Icon(
            Icons.swap_calls,
            color: Colors.teal,
            size: 5,
          ),
          onPressed: () {
            Navigator.pushNamed(context, ROUTE_QR);
          },
        ),
        FlatButton(
          child: Icon(
            Icons.power_settings_new,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            await (await SharedPreferences.getInstance())
                .setString(TABLE_NUMBER, null);
            Navigator.pushReplacementNamed(context, ROUTE_QR);
          },
        ),
      ],
    );
  }
}
