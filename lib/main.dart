import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Authentication.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Menu.dart';
import 'package:restx/screens/QrScanner.dart';
import 'package:restx/screens/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => StreamBuilder<Widget>(
      initialData: Splash(),
      stream: findInitialState().asStream(),
      builder: (ctx, home) {
        print(home.data.toString());
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primaryColor: Colors.teal.shade400,
            primaryColorDark: Colors.teal.shade700,
          ),
          routes: {
            ROUTE_QR: (ctx) => QrScanner(),
            ROUTE_MENU: (ctx) => Menu(),
            ROUTE_AUTH: (ctx) => Authentication(),
          },
          home: home.data,
        );
      });

  Future<Widget> findInitialState() async {
    var user = await FirebaseAuth.instance.currentUser();
    await Future.delayed(Duration(seconds: 3));
    if (user == null) return Authentication();

    String tableNumber =
        (await SharedPreferences.getInstance()).getString(TABLE_NUMBER);

    if (tableNumber == null) return QrScanner();

    return Menu();
  }
}
