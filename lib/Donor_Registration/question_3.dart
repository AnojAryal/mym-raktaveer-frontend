import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/progress_bar.dart';
import 'package:mym_raktaveer_frontend/Donor_Registration/question_4.dart';
import 'package:mym_raktaveer_frontend/background.dart';
import 'package:mym_raktaveer_frontend/personal_detail_model.dart';

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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the function to update the model
                      updateModel();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Question4Page(),
                        ),
                      );
                      // Handle the 'Submit' button click
                      // You can navigate to the next screen or perform any other action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Submit',
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

  void updateModel() {
    // Update the PersonalDetailModel with selected health conditions

    widget.personalDetailModel.healthConditions = Map.fromEntries(
      conditions
          .asMap()
          .entries
          .where((entry) => isCheckedList[entry.key])
          .map((entry) => MapEntry(entry.value, true)),
    );

    // Print all collected data
    print("Collected Data:");
    print("Blood Group ABO: ${widget.personalDetailModel.bloodGroupAbo}");
    print("Blood Group Rh: ${widget.personalDetailModel.bloodGroupRh}");
    print("Last Donation Date: ${widget.personalDetailModel.lastDonationDate}");
    print(
        "Last Donation Received: ${widget.personalDetailModel.lastDonationReceived}");
    print(
        "Health Conditions Map: ${widget.personalDetailModel.healthConditions}");
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
