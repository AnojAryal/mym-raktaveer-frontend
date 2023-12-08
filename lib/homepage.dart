import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mym_raktaveer_frontend/auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? bloodGroup = '';
  int? donationCount = 0;
  bool? status;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
          status = data['blood_detail']?['status'] ?? false;
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );

              // Navigate to the authentication page (e.g., login or signup page)
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Sign Out"),
          ),
          Text(user?.email ?? "No email available"),
          SizedBox(height: 20),
          Text('Blood Group : $bloodGroup'),
          SizedBox(height: 10),
          Text('Life Saved: $donationCount'),
          SizedBox(height: 10),
          Text('Status: $status'),
        ],
      ),
    );
  }
}
