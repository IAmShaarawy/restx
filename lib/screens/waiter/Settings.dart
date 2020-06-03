import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Loading.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.currentUser().asStream(),
          builder: (context, fUserSS) {
            return !fUserSS.hasData
                ? Loading()
                : StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .document(fUserSS.data.uid)
                    .snapshots(),
                builder: (context, userSS) {
                  return !userSS.hasData
                      ? Loading()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage.assetNetwork(
                              height: 200,
                              width: 200,
                              placeholder: 'images/logo.png',
                              image: userSS.data.data["img"],
                            ),
                          ),
                        ],
                      ),
                      Text("Welcome\n${userSS.data.data["name"]}",style: TextStyle(color: Colors.blueGrey,fontSize: 20,fontFamily: 'Lobster'),)
                    ],
                  );
                });
          }),
    );
  }
}
