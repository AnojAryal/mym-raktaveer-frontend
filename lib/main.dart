import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/Question1.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/question3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BloodDonationJourneyPage(),
    );
  }
}
