import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/components/custom_textfield.dart';
import 'package:nirbhaya/utils/constants.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  bool isSaving = false;
  double? ratings;

  showAlert(BuildContext context) {
    // Clear text controllers before showing the dialog
    locationC.clear();
    viewsC.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("GIVE A REVIEW"),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter Name:"),
                  SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Enter Name',
                    controller: locationC,
                  ),
                  SizedBox(height: 16),
                  Text("Enter Review:"),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: viewsC,
                    hintText: 'Enter Review',
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  Text("Rate this:"),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    unratedColor: Colors.grey.shade300,
                    itemSize: 30,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratings = rating;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                // Clear text controllers and dismiss the dialog
                locationC.clear();
                viewsC.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Update button color as needed
              ),
              child: Text("SAVE"),
              onPressed: () {
                saveReview();
                // Clear text controllers and dismiss the dialog
                locationC.clear();
                viewsC.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void saveReview() async {
    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'location': locationC.text.trim(),
        'views': viewsC.text.trim(),
        'ratings': ratings ?? 1.0, // Default rating if not set
      });

      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'Review uploaded successfully');
        locationC.clear();
        viewsC.clear();
        ratings = null;
      });
    } catch (e) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'Failed to upload review');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Reviews",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFD8080),
      ),
      body: isSaving
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Recent Reviews",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('reviews')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No reviews found'));
                        }

                        return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data!.docs[index];
                            final location = data['location'] ?? '';
                            final views = data['views'] ?? '';
                            final double rating =
                                (data['ratings'] ?? 0.0).toDouble();

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "User: $location",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Review: $views",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      RatingBar.builder(
                                        initialRating: rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 30,
                                        ignoreGestures: true,
                                        unratedColor: Colors.grey.shade300,
                                        itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber),
                                        onRatingUpdate: (double value) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 250, 163, 192),
        onPressed: () {
          showAlert(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
