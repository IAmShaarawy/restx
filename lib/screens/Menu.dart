import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
      ),
      body: Center(
        child: Text("Menu"),
      ),
    );
  }
}
