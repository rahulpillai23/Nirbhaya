import 'package:flutter/material.dart';

class PharmacyCard extends StatelessWidget {
  final Function? onMapFunction;
  const PharmacyCard({Key? key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: () {
          onMapFunction!('Pharmacies near me');
        },
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 70,
                width: 70,
                child: Center(
                  child: Image.asset('assets/pharmacy (1).png', height: 50),
                ),
              ),
            ),
            Text('Pharmacies')
          ],
        ),
      ),
    );
  }
}
