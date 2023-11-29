import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  const MyProgressBar({super. key});

  @override
  Widget build(BuildContext context) {
    double progress = 0.5;

    return Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          value: progress,
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
