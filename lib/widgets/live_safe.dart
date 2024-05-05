import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/widgets/homewidgets/live_safe/BusStationCard.dart';
import 'package:nirbhaya/widgets/homewidgets/live_safe/HospitalCard.dart';
import 'package:nirbhaya/widgets/homewidgets/live_safe/PharmacyCard.dart';
import 'package:nirbhaya/widgets/homewidgets/live_safe/PoliceStationCard.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key});

  static Future<void> openMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';
    final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'something went wrong!! Call an Emergency Number Immediately');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 20),
          PoliceStationCard(onMapFunction: openMap),
          HospitalCard(onMapFunction: openMap),
          PharmacyCard(onMapFunction: openMap),
          BusStationCard(onMapFunction: openMap),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
