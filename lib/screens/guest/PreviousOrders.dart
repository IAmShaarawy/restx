import 'package:flutter/material.dart';

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
    );
  }
}
