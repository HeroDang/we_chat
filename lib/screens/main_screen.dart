import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:we_chat/screens/add_friends_screen.dart';

import '../api/apis.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AddFriendsScreen(),
    ProfileScreen(user: APIs.me),
  ];

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
            icon: Icon(Icons.home_outlined, size: 38),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_outlined, size: 38),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 38),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF5E88DA),
        selectedLabelStyle:
            TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
        onTap: _onItemTapped,
      ),
    );
  }
}
