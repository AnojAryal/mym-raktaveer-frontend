import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/background.dart';
// import 'progress_bar.dart';

class UserChoicePage extends StatefulWidget {
  const UserChoicePage({Key? key}) : super(key: key);

  @override
  _UserChoicePageState createState() => _UserChoicePageState();
}

class _UserChoicePageState extends State<UserChoicePage> {
  String selectedBloodType = ''; // To keep track of the selected blood type
  String selectedRhFactor = ''; // To keep track of the selected Rh factor

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5.0), // Add margin to the top
          const Center(
            child: Text(
              'Mym Raktaveer', // <-- New title
              style: TextStyle(
                color: Color(0xFFFD1A00), // Red color
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ), // Add some space between the title and the content
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Select your Blood Type',
              style: TextStyle(
                color: Color(0xFF242323),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Blood Group ABO', // <-- Subheading
              style: TextStyle(
                color: Color(0xFF242323),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          const SizedBox(
            height: 16.0,
          ), // Add some space between the heading and text boxes
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClickableBloodTypeBox('A', context),
                const SizedBox(width: 8.0),
                _buildClickableBloodTypeBox('O', context),
                const SizedBox(width: 8.0),
                _buildClickableBloodTypeBox('B', context),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(
                left: 22.0), // Adjust the left padding for the Row
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClickableBloodTypeBox('AB', context),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ), // Add some space between the text boxes and the subheadings
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Blood Group RH',
              style: TextStyle(
                color: Color(0xFF242323),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClickableRhFactorBox('+ve'),
                const SizedBox(
                    width: 9.0), // Adjust the space between +ve and -ve
                _buildClickableRhFactorBox('-ve'),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle the button press
                  // Add your navigation logic or any action needed
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  backgroundColor: const Color(0xFFFD1A00), // Red background
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableBloodTypeBox(String bloodType, BuildContext context) {
    bool isSelected = selectedBloodType == bloodType;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the selected blood type
          selectedBloodType = isSelected ? '' : bloodType;
        });
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(
            left: 8.0), // Adjust the margin for the text boxes
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.red, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: Center(
          child: Text(
            bloodType,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableRhFactorBox(String rhFactor) {
    bool isSelected = selectedRhFactor == rhFactor;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the selected Rh factor
          selectedRhFactor = isSelected ? '' : rhFactor;
        });
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.red, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: Center(
          child: Text(
            rhFactor,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
