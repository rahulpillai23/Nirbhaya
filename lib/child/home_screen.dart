import 'package:flutter/material.dart';
import 'package:nirbhaya/utils/constants.dart';
import 'package:nirbhaya/widgets/CustomCarousel.dart';
import 'package:nirbhaya/widgets/custom_appBar.dart';
import 'package:nirbhaya/widgets/homewidgets/emergency.dart';
import 'package:nirbhaya/widgets/live_safe.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD8080),
        centerTitle: true,
        title: Text(
          'NIRBHAYA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Call the logout function
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(),
            CustomCarousel(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Emergency",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Emergency(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Explore Livesafe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    LiveSafe(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
