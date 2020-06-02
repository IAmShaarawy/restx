import 'package:flutter/material.dart';
import 'package:restx/screens/guest/CurrentOrder.dart';
import 'package:restx/screens/guest/Menu.dart';
import 'package:restx/screens/guest/Settings.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[Menu(), CurrentOrder(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('Menu'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.blur_circular),
            title: Text('Table'),
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
