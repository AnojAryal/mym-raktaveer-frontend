import 'package:mym_raktaveer_frontend/Donor_Registration/progress_bar.dart';
import 'package:mym_raktaveer_frontend/background.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/homepage.dart';
import 'package:mym_raktaveer_frontend/main.dart';

class Question4Page extends StatefulWidget {
  const Question4Page({super.key});

  @override
  State<Question4Page> createState() => _Question4PageState();
}

class _Question4PageState extends State<Question4Page> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.black,
                    //   ),
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    // You can add additional widgets here if needed
                  ],
                ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
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
