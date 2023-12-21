import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, bool> healthConditions = {};
  // Placeholder data
  String? userName = '';

  String? userEmail = '';

  String? userPhone = '';
  // Add actual phone number
  int? userAge = 0;
  // Add actual age
  String? userGender = '';
  // Add actual gender
  String? bloodGroup = '';

  int requestQuantity = 0;

  int? donatedQuantity = 0;

  int? donationCount = 0;

  // Container widths
  double containerWidth = 400.0;

  @override
  void initState() {
    super.initState();
    fetchPersonalDetails();
  }

  Future<void> fetchPersonalDetails() async {
    String? baseUrl = dotenv.env['BASE_URL'];
    final userUID = FirebaseAuth.instance.currentUser?.uid;
    String? apiUrl = '$baseUrl/api/personal-details/$userUID';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];

        String? bloodGroupAbo = data['blood_detail']?['blood_group_abo'];
        String? bloodGroupRh = data['blood_detail']?['blood_group_rh'];

        setState(() {
          bloodGroup = (bloodGroupAbo != null && bloodGroupRh != null)
              ? bloodGroupAbo + bloodGroupRh
              : 'N/A';

          donationCount = data['blood_detail']?['donation_count'] ?? 0;
          // status = data['blood_detail']?['status'] ?? false;

          userName = data['full_name'];
          userEmail = data['email'];
          userPhone = data['mobile_number'];
          userAge = data['age'] ?? 0;
          userGender = data['gender'];
          // requestQuantity = data['request_quantity'] ?? 0;
          donatedQuantity = data['blood_detail']?['donated_quantity'] ?? 0;

          // Retrieve health conditions data from API
          final Map<String, bool> healthConditions =
              data['data']?['health_condition'];
          setState(() {
            this.healthConditions = healthConditions;
          });
          print(this.healthConditions);
        });
      } else {
        print('Not Found: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              // Back Button
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Handle back button press
                    // You can use Navigator.pop(context) to go back
                  },
                ),
              ),
            ),
            // Profile Picture, Name, and Email// Back Button
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 16.0, top: 0.0),
              child: Row(
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    radius: 40,
                    // Placeholder for the profile picture
                    // Replace the next line with the actual image URL once it's available
                    // backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  ),
                  const SizedBox(
                    width: 16,
                  ), // Add spacing between the profile picture and text
                  // User Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$userName',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$userEmail',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Phone, Age, and Gender
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 16.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Phone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('$userPhone', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  // Age
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('$userGender', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  // Gender
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Age',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('$userAge', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            // First Container with circular edges and box shadow
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bold text for Blood Details
                    const Text('Blood Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    // Blood Group
                    Text('Blood Group: $bloodGroup',
                        style: const TextStyle(fontSize: 16)),
                    // Request Quantity and Urgency Level side by side
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Request Quantity
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Donation Count: $donationCount',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(
                            width: 30), // Add spacing between the text
                        // Urgency Level
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: $donatedQuantity ml',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Display health conditions based on healthConditionsList
            Column(
              children: [
                const Text(
                  "Health Conditions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ..._buildHealthConditions(healthConditions),
              ],
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildHealthConditions(Map<String, bool> healthConditions) {
  return healthConditions.entries.map((entry) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(entry.key, style: const TextStyle(fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: entry.value ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.value ? 'Yes' : 'No',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }).toList();
}
