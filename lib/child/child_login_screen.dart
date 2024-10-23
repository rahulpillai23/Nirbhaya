import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirbhaya/bottom_screen.dart/bottom_navbar.dart';
import 'package:nirbhaya/components/PrimaryButton.dart';
import 'package:nirbhaya/components/SecondaryButton.dart';
import 'package:nirbhaya/components/custom_textfield.dart';
import 'package:nirbhaya/db/sp.dart';
import 'package:nirbhaya/parent/parent_home_screen.dart';
import 'package:nirbhaya/utils/constants.dart';

class ChildLoginScreen extends StatefulWidget {
  @override
  State<ChildLoginScreen> createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends State<ChildLoginScreen> {
  bool isPasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  bool isLoading = false;

  _onSubmit(context) async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
          if (value['type'] == 'parent') {
            print(value['type']);
            SharedPreference.saveUserType('parent');
            goTo(context, ParentHomeScreen());
          } else {
            SharedPreference.saveUserType('child');
            goTo(context, Bottombar());
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        dialogueBox(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialogueBox(context, 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Text(
                            "Hello! Register to get started",
                            style: GoogleFonts.urbanist(
                              textStyle: TextStyle(
                                color: Colors.black,
                                letterSpacing: .5,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Image.asset(
                            'assets/Nirbhaya_logo.png',
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.93,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                    hintText: 'enter email',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return 'enter correct email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    hintText: 'enter password',
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return 'enter correct password';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        // Toggle password visibility
                                        isPasswordShown = !isPasswordShown;
                                      },
                                      icon: isPasswordShown
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  PrimaryButton(
                                    title: 'LOGIN',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _onSubmit(context);
                                      }
                                      ;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(fontSize: 18),
                              ),
                              SecondaryButton(
                                title: 'click here',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
