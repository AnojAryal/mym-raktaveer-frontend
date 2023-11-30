import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: const MyProgressBar(
          currentPage: 1, // Set the current page
          totalPages: 4,  // Set the total number of pages
        ),
      ),
    );
  }
}
