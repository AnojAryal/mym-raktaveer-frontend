import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/background.dart';

class BloodDonationJourneyPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          const Center(
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

          const SizedBox(
            height: 16.0,
          ), // Add some space between the title and the content
          const Padding(
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
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
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
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (int i = 0; i < conditions.length; i += 2)
                  Row(
                    children: [
                      Expanded(
                        child: Checkbox(
                          value: false,
                          onChanged: (_) {},
                        ),
                      ),
                      Expanded(
                        child: Text(
                          conditions[i],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      if (i + 1 < conditions.length)
                        const SizedBox(
                            width: 16.0), // Adjust the gap between columns
                      if (i + 1 < conditions.length)
                        Expanded(
                          child: Checkbox(
                            value: false,
                            onChanged: (_) {},
                          ),
                        ),
                      if (i + 1 < conditions.length)
                        Expanded(
                          child: Text(
                            conditions[i + 1],
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
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
