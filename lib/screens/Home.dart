import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("SignOut"),
          color: Colors.amberAccent,
          onPressed: () {
            FirebaseAuth.instance.signOut().then((result) {
              Navigator.pushReplacementNamed(context, "/auth");
            }, onError: (error) {});
          },
        ),
      ),
    );
  }
}
