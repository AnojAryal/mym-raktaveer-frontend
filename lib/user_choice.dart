import 'package:flutter/material.dart';
import 'background.dart';

class UserChoicePage extends StatelessWidget {
  const UserChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle the logic when the user chooses to log in as a receiver
                // You can navigate to the receiver login page or perform other actions
              },
              child: const Text('Login as Receiver'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle the logic when the user chooses to log in as a donor
                // You can navigate to the donor login page or perform other actions
              },
              child: const Text('Login as Donor'),
            ),
          ],
        ),
      ),
    );
  }
}
