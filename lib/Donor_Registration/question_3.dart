import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/question_4.dart';
import 'package:mym_raktaveer_frontend/background.dart';

class BloodDonationJourneyPage extends StatefulWidget {
  const BloodDonationJourneyPage({super.key});

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mym Raktaveer',
            style: TextStyle(
              color: Color(0xFFFD1A00),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Health Conditions',
                style: TextStyle(
                  fontSize: 28,
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
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Question4Page()),
                    );
                    // Handle the 'Next' button click
                    // You can navigate to the next screen or perform any other action
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
            ],
          ),
        ),
      ),
    );
  }
}
