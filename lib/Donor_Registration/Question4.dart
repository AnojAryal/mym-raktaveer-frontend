import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/background.dart';

class Question4Page extends StatefulWidget {
  const Question4Page({super. key});

  @override
  State<Question4Page> createState() => _Question4PageState();
}

class _Question4PageState extends State<Question4Page> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Empty Container for Future Contents
            Container(
              height: 60.0, // Adjust the height as needed
              // Add child components (e.g., image, back button) here
            ),
            const SizedBox(height: 14.0),
            const Text(
              'You\'re all set!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Thank you for saving lives!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Center(
              child:ElevatedButton(
                onPressed: () {
                  // Handle button click, e.g., navigate to home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
