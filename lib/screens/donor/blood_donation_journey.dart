import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/models/health_condition_model.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/services/blood_donation_service.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';


class BloodDonationJourneyPage extends StatefulWidget {
  const BloodDonationJourneyPage({
    super.key,
    required this.personalDetailModel,
  }) ;

  final PersonalDetailModel personalDetailModel;

  @override
  State<BloodDonationJourneyPage> createState() =>
      _BloodDonationJourneyPageState();
}

class _BloodDonationJourneyPageState extends State<BloodDonationJourneyPage> {
  final BloodDonationService _bloodDonationService = BloodDonationService();
  List<bool> isCheckedList =
      List.generate(HealthConditionsModel.conditions.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressBar(),
                _buildHealthConditionsTitle(),
                const SizedBox(height: 16.0),
                _buildNoteContainer(),
                const SizedBox(height: 16.0),
                _buildHealthConditionsList(),
                const SizedBox(height: 16.0),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return const MyProgressBar(
      currentPage: 3,
      totalPages: 4,
    );
  }

  Widget _buildHealthConditionsTitle() {
    return const Text(
      'Health Conditions',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNoteContainer() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DA),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'Note : ',
              style: TextStyle(
                color: Color(0xFFFD1A00),
              ),
            ),
            TextSpan(
              text:
                  'Please indicate if any of the following apply to you by ticking the relevant options.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: HealthConditionsModel.conditions.length,
        itemBuilder: (context, index) {
          return _buildHealthConditionItem(index);
        },
      ),
    );
  }

  Widget _buildHealthConditionItem(int index) {
    return Row(
      children: [
        Expanded(
          child: Checkbox(
            value: isCheckedList[index],
            onChanged: (value) {
              setState(() {
                isCheckedList[index] = value!;
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            HealthConditionsModel.conditions[index],
            style: const TextStyle(fontSize: 14),
          ),
        ),
        if (index + 1 < HealthConditionsModel.conditions.length) ...[
          const SizedBox(width: 16.0),
          Expanded(
            child: Checkbox(
              value: isCheckedList[index + 1],
              onChanged: (value) {
                setState(() {
                  isCheckedList[index + 1] = value!;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              HealthConditionsModel.conditions[index + 1],
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            _buildNavigationButton(
              text: 'Submit',
              onPressed: () {
                _bloodDonationService.updateModelAndNavigate(
                    widget.personalDetailModel, isCheckedList, context);
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
}
