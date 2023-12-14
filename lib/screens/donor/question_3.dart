import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mym_raktaveer_frontend/widgets/progress_bar.dart';
import 'package:mym_raktaveer_frontend/screens/donor/question_4.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class BloodDonationJourneyPage extends StatefulWidget {
  const BloodDonationJourneyPage(
      {super.key, required this.personalDetailModel});

  final PersonalDetailModel personalDetailModel;

  @override
  State<BloodDonationJourneyPage> createState() =>
      _BloodDonationJourneyPageState();
}

class _BloodDonationJourneyPageState extends State<BloodDonationJourneyPage> {
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
                            updateModel();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Question4Page(),
                              ),
                            );
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

  void updateModel() {
    // Update the PersonalDetailModel with selected health conditions

    widget.personalDetailModel.healthConditions = Map.fromEntries(
      conditions
          .asMap()
          .entries
          .where((entry) => isCheckedList[entry.key])
          .map((entry) => MapEntry(camelCaseToSnakeCase(entry.value), true)),
    );

    final userUid = FirebaseAuth.instance.currentUser?.uid;

    sendPersonalDataToApi(userUid);

    // Print all collected data
  }

  String camelCaseToSnakeCase(String input) {
    return input
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
          return '${match.group(1)}_${match.group(2)!.toLowerCase()}';
        })
        .replaceAll(' ', '_')
        .toLowerCase();
  }

  Future<void> sendPersonalDataToApi(String? userUid) async {
    String? baseUrl = dotenv.env['BASE_URL'];

    String? apiUrl = '$baseUrl/api/personal-details';

    final personalData = {
      'blood_group_abo': widget.personalDetailModel.bloodGroupAbo,
      'blood_group_rh': widget.personalDetailModel.bloodGroupRh,
      'user_id': userUid,
      if (widget.personalDetailModel.lastDonationDate != null)
        'last_donation_date': widget.personalDetailModel.lastDonationDate,
      if (widget.personalDetailModel.lastDonationReceived != null)
        'last_donation_received':
            widget.personalDetailModel.lastDonationReceived,
      ...?widget.personalDetailModel.healthConditions,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(personalData),
      );

      if (response.statusCode == 201) {
        print('User created successfully');
        print('Response: ${response.body}');
      } else {
        print(
            'Failed to create user. Status code: ${response.statusCode} data : $personalData');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error creating user: $error');
      print(personalData);
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) sync* {
    var index = 0;
    for (var element in this) {
      yield f(index, element);
      index++;
    }
  }
}
