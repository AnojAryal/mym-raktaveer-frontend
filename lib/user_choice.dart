import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/homepage.dart';
import 'package:mym_raktaveer_frontend/question_first.dart';

class UserChoice extends StatefulWidget {
  const UserChoice({super.key});

  @override
  State<UserChoice> createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Choice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to receiver screen
                Navigator.push(context, const HomePage() as Route<Object?>);
              },
              child: const Text('Receiver'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to donor screen
                Navigator.push(
                    context, const QuestionFirst() as Route<Object?>);
              },
              child: const Text('Donor'),
            ),
          ],
        ),
      ),
    );
  }
}
