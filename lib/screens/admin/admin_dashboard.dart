import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<Map<String, dynamic>> fetchAnalyticsData() async {
    final response = await http.get(Uri.parse(
        'https://console.firebase.google.com/u/0/project/mym-raktaveer-90ff3/analytics/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load analytics data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Container(
            width: screenWidth * 0.86,
            height: screenHeight * 0.2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchAnalyticsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingWidget();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final analyticsData = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Total Users: ${analyticsData['totalUsers']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Active Users: ${analyticsData['activeUsers']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Add more analytics data as needed...
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20), // Add some space between the containers
          Container(
            width: screenWidth * 0.86,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // User Icon
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: const Color(0xFFFD1A00),
                        size: screenWidth * 0.08,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Users',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.026,
                        ),
                      ),
                    ],
                  ),
                ),

                // Admin Icon
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: const Color(0xFFFD1A00),
                        size: screenWidth * 0.08,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Admins',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.026,
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Admins Icon
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.supervised_user_circle,
                        color: const Color(0xFFFD1A00),
                        size: screenWidth * 0.08,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Active Admins',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.026,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Request Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 20),
                icon: const Icon(Icons.open_in_new),
                color: const Color(0xFFFD1A00),
                onPressed: () {
                  Navigator.pushNamed(context, '/blood-request-list');
                },
              ),
            ],
          ),

          const SizedBox(
            height: 300,
            child: RequestListPage(),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth * 0.82,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: const Color(0xFFFD1A00),
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFFD1A00),
                      ),
                    ),
                    Text(
                      'MYM Raktaveer',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Loading...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
