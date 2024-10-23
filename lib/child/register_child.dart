import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirbhaya/child/child_login_screen.dart';
import 'package:nirbhaya/model/user_model.dart';
import 'package:nirbhaya/utils/constants.dart';

import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';

class RegisterChildScreen extends StatefulWidget {
  @override
  _RegisterChildScreenState createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit(BuildContext context) async {
    _formKey.currentState!.save();

    if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, 'Password and retype password should be equal');
    } else {
      progressIndicator(context);

      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _formData['cemail'].toString(),
          password: _formData['password'].toString(),
        );

        if (userCredential.user != null) {
          setState(() {
            isLoading = true;
          });
          final userId = userCredential.user!.uid;

          // Create a document for the user in Firestore
          DocumentReference<Map<String, dynamic>> userDoc =
              FirebaseFirestore.instance.collection('users').doc(userId);

          // Create a UserModel instance
          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['cemail'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            id: userId,
            type: 'child',
          );

          // Convert UserModel to JSON and save it to Firestore
          await userDoc.set(user.toJson());

          // Navigate to ChildLoginScreen upon successful registration
          goTo(context, ChildLoginScreen());
          setState(() {
            isLoading = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          dialogueBox(context, 'The account already exists for that email.');
        } else {
          dialogueBox(context, 'Error: ${e.message}');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
        dialogueBox(context, 'Error: $e');
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  hintText: 'enter name',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.name,
                                  prefix: Icon(Icons.person),
                                  onsave: (name) {
                                    _formData['name'] = name ?? "";
                                  },
                                  validate: (email) {
                                    if (email!.isEmpty || email.length < 3) {
                                      return 'enter correct name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  hintText: 'enter phone',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.phone,
                                  prefix: Icon(Icons.phone),
                                  onsave: (phone) {
                                    _formData['phone'] = phone ?? "";
                                  },
                                  validate: (email) {
                                    if (email!.isEmpty || email.length < 10) {
                                      return 'enter correct phone';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  hintText: 'enter email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  prefix: Icon(Icons.person),
                                  onsave: (email) {
                                    _formData['cemail'] = email ?? "";
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
                                SizedBox(height: 20),
                                CustomTextField(
                                  hintText: 'enter guardian email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  prefix: Icon(Icons.person),
                                  onsave: (gemail) {
                                    _formData['gemail'] = gemail ?? "";
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
                                SizedBox(height: 20),
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
                                      setState(() {
                                        isPasswordShown = !isPasswordShown;
                                      });
                                    },
                                    icon: isPasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  hintText: 'retype password',
                                  isPassword: isRetypePasswordShown,
                                  prefix: Icon(Icons.vpn_key_rounded),
                                  validate: (password) {
                                    if (password!.isEmpty ||
                                        password.length < 7) {
                                      return 'enter correct password';
                                    }
                                    return null;
                                  },
                                  onsave: (password) {
                                    _formData['rpassword'] = password ?? "";
                                  },
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isRetypePasswordShown =
                                            !isRetypePasswordShown;
                                      });
                                    },
                                    icon: isRetypePasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                                SizedBox(height: 20),
                                PrimaryButton(
                                  title: 'REGISTER',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _onSubmit(context);
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                SecondaryButton(
                                  title: 'Login with your account',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChildLoginScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
