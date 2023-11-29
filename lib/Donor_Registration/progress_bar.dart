import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  const MyProgressBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Loading...'),
          const SizedBox(height: 16.0),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor:const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ],
      ),
    );
  }
}
