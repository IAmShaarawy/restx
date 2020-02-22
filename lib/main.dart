import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Authentication.dart';
import 'package:restx/screens/Home.dart';
import 'package:restx/screens/Loading.dart';
import 'package:restx/screens/Splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _home = Splash();

  _MyAppState() {
    FirebaseAuth.instance.currentUser().then((user) {
      new Timer(Duration(seconds: 3), () {
        final Widget targetHome = user == null ? Authentication() : Home();
        setState(() {
          _home = targetHome;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal.shade400,
          primaryColorDark: Colors.teal.shade700,
        ),
        routes: {
          '/home': (ctx) => Home(),
          '/auth': (ctx) => Authentication(),
        },
        home: _home,
      );
}
