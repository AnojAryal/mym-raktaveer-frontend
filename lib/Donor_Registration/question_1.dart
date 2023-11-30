import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/progress_bar.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/question_2.dart';
import 'package:mym_raktaveer_frontend/background.dart';

class UserChoicePage extends StatefulWidget {
  const UserChoicePage({super.key});

  @override
  State<UserChoicePage> createState() => _UserChoicePageState();
}

class _UserChoicePageState extends State<UserChoicePage> {
  String selectedBloodType = '';
  String selectedRhFactor = '';

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          const MyProgressBar(
            currentPage: 1,
            totalPages: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 55.0),
              const Center(
                child: Text(
                  'Mym Raktaveer',
                  style: TextStyle(
                    color: Color(0xFFFD1A00),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Select your Blood Type',
                  style: TextStyle(
                    color: Color(0xFF242323),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8.0),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Blood Group ABO',
                  style: TextStyle(
                    color: Color(0xFF242323),
                    fontSize: 14,
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
                padding: const EdgeInsets.only(left: 22.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClickableBloodTypeBox('AB', context),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Blood Group RH',
                  style: TextStyle(
                    color: Color(0xFF242323),
                    fontSize: 14,
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
                      width: 9.0,
                    ),
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
                      // Handle the 'Next' button click
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuestionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
