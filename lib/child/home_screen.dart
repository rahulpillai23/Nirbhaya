import 'package:flutter/material.dart';
import 'package:nirbhaya/utils/constants.dart';
import 'package:nirbhaya/widgets/CustomCarousel.dart';
import 'package:nirbhaya/widgets/custom_appBar.dart';
import 'package:nirbhaya/widgets/homewidgets/emergency.dart';
import 'package:nirbhaya/widgets/live_safe.dart';
import 'package:nirbhaya/widgets/safehome/safehome.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFFFD8080),
            pinned: true,
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
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(),
                  CustomCarousel(),
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
                  SafeHome(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
