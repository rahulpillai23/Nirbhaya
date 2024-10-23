import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nirbhaya/bottom_screen.dart/add_contacts.dart';
import 'package:nirbhaya/bottom_screen.dart/chat_screen.dart';
// import 'package:nirbhaya/bottom_screen.dart/contacts.dart';
import 'package:nirbhaya/bottom_screen.dart/profile.dart';
import 'package:nirbhaya/bottom_screen.dart/review.dart';
import 'package:nirbhaya/child/home_screen.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _currentIndex = 0;

  List<Widget> pages = [
    Homescreen(),
    AddContactsPage(),
    ChatPage(),
    ProfilePage(),
    ReviewPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.contact_phone_outlined, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble_outline_rounded,
              size: 30, color: Colors.white),
          Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
          Icon(Icons.reviews_outlined, size: 30, color: Colors.white),
        ],
        color: Color(0xFFFD8080),
        buttonBackgroundColor: Color.fromARGB(255, 255, 140, 140),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
