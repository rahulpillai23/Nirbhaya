import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirbhaya/bottom_screen.dart/bottom_navbar.dart';
import 'package:nirbhaya/db/sp.dart';
import 'package:nirbhaya/firebase_options.dart';
import 'package:nirbhaya/parent/parent_home_screen.dart';
import 'package:nirbhaya/welcome_screen.dart';
import 'package:nirbhaya/widgets/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIRBHAYA',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.deepPurple,
      ),
      home: FutureBuilder(
        future: SharedPreference.getUserType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == '') {
            return SplashScreen();
          }
          if (snapshot.data == 'child') {
            return Bottombar();
          }
          if (snapshot.data == 'parent') {
            return ParentHomeScreen();
          }
          return WelcomeScreen();
        },
      ),
    );
  }
}
