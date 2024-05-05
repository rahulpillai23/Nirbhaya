import 'package:flutter/material.dart';
import 'package:nirbhaya/widgets/homewidgets/Emergencies/AmbulanceEmergency.dart';
import 'package:nirbhaya/widgets/homewidgets/Emergencies/FireBrigadeEmergency.dart';
import 'package:nirbhaya/widgets/homewidgets/Emergencies/PoliceEmegeny.dart';
import 'package:nirbhaya/widgets/homewidgets/Emergencies/WomenHelpline.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            PoliceEmergency(),
            AmbulanceEmergency(),
            FireBrigadeEmergency(),
            WomenHelpline(),
          ],
        ));
  }
}
