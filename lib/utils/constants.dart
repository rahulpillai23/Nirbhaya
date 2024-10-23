import 'package:flutter/material.dart';
import 'package:nirbhaya/db/sp.dart';
import 'package:nirbhaya/welcome_screen.dart';

Color primaryColor = Color.fromARGB(255, 250, 163, 192);

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

Future<void> dialogueBox(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
    backgroundColor: primaryColor,
    color: Colors.red,
    strokeWidth: 7,
  ));
}

Future<void> logout(BuildContext context) async {
  // Clear the shared preferences
  await SharedPreference.clearUserData();

  // Navigate back to the WelcomeScreen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => WelcomeScreen()),
    (route) => false,
  );
}
