import 'package:chat_me/Part2/All.dart';
import 'package:chat_me/Part2/Uinfo.dart';
import 'package:chat_me/Part2/someu.dart';
import 'package:chat_me/ads.dart';
import 'package:chat_me/search.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  var _currenIndex = 0;
  final tabs = [
    SomePerson(),
    All(),
    // AdsF(),
    // SearchN(),
    UserInfomation(),
  ];

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currenIndex,
        onTap: (index) {
          setState(() {
            _currenIndex = index;
          });
        },
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "New Friend"),
          // BottomNavigationBarItem(icon: Icon(Icons.search), label: "Serch"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
      body: tabs[_currenIndex],
    );
  }
}
