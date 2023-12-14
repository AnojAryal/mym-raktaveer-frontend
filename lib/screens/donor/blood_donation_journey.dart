import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/services/blood_donation_service.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';

class BloodDonationJourneyPage extends StatefulWidget {
const BloodDonationJourneyPage({
  super. key,
  required this.personalDetailModel,
}) ;

  final PersonalDetailModel personalDetailModel;

  @override
  State<BloodDonationJourneyPage> createState() =>
      _BloodDonationJourneyPageState();
}

class _BloodDonationJourneyPageState extends State<BloodDonationJourneyPage> {
  final BloodDonationService _bloodDonationService = BloodDonationService();
  final List<String> conditions = [
    'High Blood Pressure',
    'Kidney Related Diseases',
    'Jaundice',
    'Typhoid',
    'Tuberculosis',
    'Heart Diseases',
    'Breast Feeding',
    'Tatto',
    'Diabetes',
    'Surgery',
    'Intoxicant Consumption',
    'Venereal Disease',
    'HIV',
    'Pregnancy',
    'Lungs Diseases',
    'Recently Vaccinated',
  ];
  List<bool> isCheckedList = List.generate(16, (index) => false);

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
                const MyProgressBar(
                  currentPage: 3,
                  totalPages: 4,
                ),
                const Text(
                  'Health Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7DA), // Corrected color code
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
                        color: Colors.black, // Default text color
                        fontSize: 14, // Changed font size to 10
                      ),
                      children: [
                        TextSpan(
                          text: 'Note : ',
                          style: TextStyle(
                            color: Color(0xFFFD1A00), // Red color for 'Note'
                          ),
                        ),
                        TextSpan(
                          text:
                              'Please indicate if any of the following apply to you by ticking the relevant options.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView(
                    children: [
                      for (int index = 0; index < conditions.length; index += 2)
                        Row(
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
                                conditions[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Checkbox(
                                value: (index + 1 < conditions.length)
                                    ? isCheckedList[index + 1]
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedList[index + 1] = value!;
                                  });
                                },
                              ),
                            ),
                            if (index + 1 < conditions.length)
                              Expanded(
                                flex: 3,
                                child: Text(
                                  conditions[index + 1],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: const Size(100, 40),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updateModelAndNavigate();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: const Size(100, 40),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
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

  void _updateModelAndNavigate() {
    _bloodDonationService.updateModelAndNavigate(
        widget.personalDetailModel, isCheckedList, context);
  }
}

