import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/waiter/Settings.dart';
import 'package:restx/screens/waiter/Tables.dart';

class WaiterHome extends StatefulWidget {
  @override
  _WaiterHomeState createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[Tables(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiter"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings_power,
              color: Colors.white,
            ),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              navigatorKey.currentState.pushReplacementNamed(ROUTE_AUTH);
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('Tables'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
