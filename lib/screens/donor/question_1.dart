import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/screens/donor/question_2.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';

class UserChoicePage extends StatefulWidget {
  const UserChoicePage({super.key});

  @override
  State<UserChoicePage> createState() => _UserChoicePageState();
}

class _UserChoicePageState extends State<UserChoicePage> {
  String selectedBloodType = '';
  String selectedRhFactor = '';

  PersonalDetailModel personalDetailModel = PersonalDetailModel();

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
              _buildAppTitle(),
              _buildBloodTypeSelection(),
              const SizedBox(height: 8.0),
              _buildRhFactorSelection(),
              const SizedBox(height: 32.0),
              _buildNavigationButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return const Column(
      children: [
        SizedBox(height: 55.0),
        Center(
          child: Text(
            'Mym Raktaveer',
            style: TextStyle(
              color: Color(0xFFFD1A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
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
      ],
    );
  }

  Widget _buildBloodTypeSelection() {
    return Column(
      children: [
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
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableBloodTypeBox('A'),
              const SizedBox(width: 8.0),
              _buildClickableBloodTypeBox('O'),
              const SizedBox(width: 8.0),
              _buildClickableBloodTypeBox('B'),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableBloodTypeBox('AB'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRhFactorSelection() {
    return Column(
      children: [
        const SizedBox(height: 16.0),
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
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableRhFactorBox('+ve'),
              const SizedBox(width: 9.0),
              _buildClickableRhFactorBox('-ve'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClickableBloodTypeBox(String bloodType) {
    return _buildClickableBox(
      isSelected: selectedBloodType == bloodType,
      onTap: () {
        setState(() {
          selectedBloodType = selectedBloodType == bloodType ? '' : bloodType;
        });
      },
      child: Text(
        bloodType,
        style: TextStyle(
          color: selectedBloodType == bloodType ? Colors.white : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClickableRhFactorBox(String rhFactor) {
    return _buildClickableBox(
      isSelected: selectedRhFactor == rhFactor,
      onTap: () {
        setState(() {
          selectedRhFactor = selectedRhFactor == rhFactor ? '' : rhFactor;
        });
      },
      child: Text(
        rhFactor,
        style: TextStyle(
          color: selectedRhFactor == rhFactor ? Colors.white : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClickableBox({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavigationButton(
              text: 'Previous',
              onPressed: () => Navigator.pop(context),
            ),
            _buildNavigationButton(
              text: 'Next',
              onPressed: () {
                updateModel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(
                      personalDetailModel: personalDetailModel,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        fixedSize: const Size(100, 40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  void updateModel() {
    personalDetailModel.bloodGroupAbo = selectedBloodType;
    personalDetailModel.bloodGroupRh = selectedRhFactor;
  }
}
