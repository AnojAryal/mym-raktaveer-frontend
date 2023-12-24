import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/blood_donation_provider.dart'; // Update with the correct import path
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class BloodTypeQuestion extends ConsumerWidget {
  const BloodTypeQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalDetail = ref.watch(personalDetailProvider);

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
              const SizedBox(height: 8.0),
              _buildBloodTypeSelection(
                  context, ref, personalDetail.bloodGroupAbo),
              const SizedBox(height: 8.0),
              _buildRhFactorSelection(
                  context, ref, personalDetail.bloodGroupRh),
              const SizedBox(height: 32.0),
              _buildNavigationButtons(context),
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

  Widget _buildBloodTypeSelection(
      BuildContext context, WidgetRef ref, String? selectedBloodType) {
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
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableBloodTypeBox('A', ref, selectedBloodType),
              const SizedBox(width: 8.0),
              _buildClickableBloodTypeBox('O', ref, selectedBloodType),
              const SizedBox(width: 8.0),
              _buildClickableBloodTypeBox('B', ref, selectedBloodType),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableBloodTypeBox('AB', ref, selectedBloodType),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClickableBloodTypeBox(
      String bloodType, WidgetRef ref, String? selectedBloodType) {
    bool isSelected = selectedBloodType == bloodType;
    return GestureDetector(
      onTap: () {
        ref.read(personalDetailProvider.notifier).updateBloodType(bloodType);
      },
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

  Widget _buildRhFactorSelection(
      BuildContext context, WidgetRef ref, String? selectedRhFactor) {
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
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableRhFactorBox('+ve', ref, selectedRhFactor),
              const SizedBox(width: 9.0),
              _buildClickableRhFactorBox('-ve', ref, selectedRhFactor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClickableRhFactorBox(
      String rhFactor, WidgetRef ref, String? selectedRhFactor) {
    bool isSelected = selectedRhFactor == rhFactor;
    return GestureDetector(
      onTap: () {
        ref.read(personalDetailProvider.notifier).updateRhFactor(rhFactor);
      },
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

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Previous'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/donation-details');
          },
          child: const Text('Next'),
        ),
      ],
    );
  }
}
