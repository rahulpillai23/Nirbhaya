import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirbhaya/db/db_services.dart';
import 'package:nirbhaya/model/contactsm.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? _permission;

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<void> _sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: 2,
    );
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "Message sent successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to send message");
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: 'Location services are disabled. Please enable them.',
      );
      return false;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied.');
        return false;
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: 'Location permissions are permanently denied.',
      );
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLon();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error getting current location: $e');
    }
  }

  Future<void> _getAddressFromLatLon() async {
    if (_currentPosition == null) {
      Fluttertoast.showToast(msg: 'Current position is not available');
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching address: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _showModalSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                if (_currentPosition != null) Text(_currentAddress ?? ''),
                PrimaryButton(
                  title: "GET LOCATION",
                  onPressed: _getCurrentLocation,
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  title: "SEND ALERT",
                  onPressed: () async {
                    List<TContact> contactList =
                        await DatabaseHelper().getContactList();
                    if (contactList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Emergency contact list is empty");
                    } else {
                      String messageBody =
                          "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";

                      if (await _isPermissionGranted()) {
                        contactList.forEach((element) {
                          _sendSms("${element.number}",
                              "I am in trouble. $messageBody");
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Failed to send alert");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showModalSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Send Location"),
                      subtitle: Text("Share Location"),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/route.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
