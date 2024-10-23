import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirbhaya/child/child_login_screen.dart';
import 'package:nirbhaya/components/PrimaryButton.dart';
import 'package:nirbhaya/components/custom_textfield.dart';
import 'package:uuid/uuid.dart';

class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
  const CheckUserStatusBeforeChatOnProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return ProfilePage();
          } else {
            Fluttertoast.showToast(msg: 'please login first');
            return ChildLoginScreen();
          }
        }
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController guardianEmailC = TextEditingController();
  TextEditingController childEmailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameC.text = value.docs.first['name'];
        childEmailC.text = value.docs.first['childEmail'];
        guardianEmailC.text = value.docs.first['guardiantEmail'];
        phoneC.text = value.docs.first['phone'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          " User Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFD8080),
      ),
      body: isSaving == true
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ))
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: Form(
                        key: key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "UPDATE YOUR PROFILE",
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () async {
                                final XFile? pickImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                if (pickImage != null) {
                                  setState(() {
                                    profilePic = pickImage.path;
                                  });
                                }
                              },
                              child: Container(
                                child: profilePic == null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.deepPurple,
                                        radius: 80,
                                        child: Center(
                                            child: Image.asset(
                                          'assets/add_pic.png',
                                          height: 80,
                                          width: 80,
                                        )),
                                      )
                                    : profilePic!.contains('http')
                                        ? CircleAvatar(
                                            backgroundColor: Colors.deepPurple,
                                            radius: 80,
                                            backgroundImage:
                                                NetworkImage(profilePic!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.deepPurple,
                                            radius: 80,
                                            backgroundImage:
                                                FileImage(File(profilePic!))),
                              ),
                            ),
                            CustomTextField(
                              controller: nameC,
                              hintText: "Username",
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter your updated name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              controller: childEmailC,
                              hintText: "child email",
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter your updated name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              controller: guardianEmailC,
                              hintText: "parent email",
                              readOnly: true,
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter your updated name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              controller: phoneC,
                              hintText: "Phone number",
                              readOnly: true,
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter your updated name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25),
                            PrimaryButton(
                                title: "UPDATE",
                                onPressed: () async {
                                  if (key.currentState!.validate()) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    if (profilePic != null) {
                                      update(); // Call the update function
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select a profile picture.');
                                    }
                                  }
                                })
                          ],
                        )),
                  ),
                ),
              ),
            ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = Uuid().v4(); // Generate a unique filename

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile')
          .child(fileName); // Reference to storage location

      final UploadTask uploadTask = storageRef.putFile(file); // Upload file
      final TaskSnapshot snapshot =
          await uploadTask; // Wait for upload to complete

      final downloadUrl =
          await snapshot.ref.getDownloadURL(); // Get download URL

      return downloadUrl; // Return the download URL
    } catch (e) {
      // Handle any errors that occur during upload
      print('Error uploading image: $e');
      Fluttertoast.showToast(msg: 'Error uploading image.');
      return null;
    }
  }

  void update() async {
    setState(() {
      isSaving = true;
    });

    try {
      if (profilePic != null) {
        final downloadUrl = await uploadImage(profilePic!);

        if (downloadUrl != null) {
          Map<String, dynamic> data = {
            'name': nameC.text,
            'profilePic': downloadUrl,
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(data);

          setState(() {
            isSaving = false;
            // Navigate to another screen after updating profile
            // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        } else {
          setState(() {
            isSaving = false;
            Fluttertoast.showToast(msg: 'Failed to upload image.');
          });
        }
      } else {
        setState(() {
          isSaving = false;
          Fluttertoast.showToast(msg: 'Please select a profile picture.');
        });
      }
    } catch (e) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'Failed to update profile: $e');
      });
    }
  }
}
