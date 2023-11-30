import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/background.dart';

class BloodDonationJourneyPage extends StatefulWidget {
  @override
  _BloodDonationJourneyPageState createState() =>
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5.0),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Mym Raktaveer', // <-- New title
                style: TextStyle(
                  color: Color(0xFFFD1A00), // Red color
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ), // Add margin to the top

          SizedBox(
            height: 16.0,
          ), // Add some space between the title and the content
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Blood Donation Journey',
              style: TextStyle(
                color: Color(0xFF242323),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFF7DA), // Corrected color code
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: RichText(
              text: TextSpan(
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
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (int i = 0; i < conditions.length; i += 2)
                  Row(
                    children: [
                      Expanded(
                        child: Checkbox(
                          value: isCheckedList[i],
                          onChanged: (value) {
                            setState(() {
                              isCheckedList[i] = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          conditions[i],
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      if (i + 1 < conditions.length)
                        SizedBox(width: 16.0), // Adjust the gap between columns
                      if (i + 1 < conditions.length)
                        Expanded(
                          child: Checkbox(
                            value: isCheckedList[i + 1],
                            onChanged: (value) {
                              setState(() {
                                isCheckedList[i + 1] = value!;
                              });
                            },
                          ),
                        ),
                      if (i + 1 < conditions.length)
                        Expanded(
                          child: Text(
                            conditions[i + 1],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
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
          ),
        ],
      ),
    );
  }
}
