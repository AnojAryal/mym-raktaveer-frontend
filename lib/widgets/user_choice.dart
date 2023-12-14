import 'package:mym_raktaveer_frontend/screens/donor/question_1.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';

class UserChoice extends StatefulWidget {
  const UserChoice({super.key});

  @override
  State<UserChoice> createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          // Add an empty container for images in the future
          Container(
            // Customize the container's properties as needed
            width: double.infinity,
            height: 100, // Adjust the height as needed
            color: Colors
                .transparent, // Set the background color or make it transparent
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(
                      horizontal:
                          15), // Adjust the margin for smaller container
                  child: const Column(
                    children: [
                      Text(
                        'How You Like To Register As?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Receiver can skip the details process for an emergency situation.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14, // Adjust the font size for smaller text
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(160, 50),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    // Add functionality for the Receiver button
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Receiver'),
                        Icon(Icons.arrow_right, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(160, 50),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserChoicePage()),
                    );
                    // Add functionality for the Donor button
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Donor'),
                        Icon(Icons.arrow_right, color: Colors.white),
                      ],
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
