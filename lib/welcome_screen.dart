import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirbhaya/child/child.dart';
import 'package:nirbhaya/parent/parent.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFD8080),
                  Color(0xFFFB8580),
                  Color(0xFFFBD079),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.13,
            left: 10,
            right: 0,
            child: SizedBox(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Introducing Nirbhaya : Elevating Women's Safety.",
                    textStyle: GoogleFonts.urbanist(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    speed: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              height:
                  MediaQuery.of(context).size.height * 0.6, // Adjusted height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 180),
                  // Register as Child button
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Child()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.35 * MediaQuery.of(context).size.width,
                          vertical: 15.0),
                      child: Text(
                        'Child',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Add some space between buttons
                  // Register as Parent button
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Parent()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.35 * MediaQuery.of(context).size.width,
                          vertical: 15.0),
                      child: Text(
                        'Parent',
                        style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18, // Adjusted position
            left: 0,
            right: 0,
            child: Image.asset('assets/Nirbhaya_logo.png'),
          ),
        ],
      ),
    );
  }
}
