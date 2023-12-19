import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';

class FinalQuestion extends StatefulWidget {
  const FinalQuestion({super.key});

  @override
  State<FinalQuestion> createState() => _FinalQuestionState();
}

class _FinalQuestionState extends State<FinalQuestion> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const MyProgressBar(
                  currentPage: 4,
                  totalPages: 4,
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home-page');
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
        ],
      ),
    );
  }
}
