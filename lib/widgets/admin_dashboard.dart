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
          const SizedBox(height: 6),
          Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.2,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
            width: screenWidth * 0.9,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Icon
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: const Color(0xFFFD1A00),
                        size: screenWidth * 0.07,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Users',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.02,
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
                        size: screenWidth * 0.07,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Admins',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.02,
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
                        size: screenWidth * 0.07,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Active Admins',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 320,
            child: RequestListPage(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.08,
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
                          fontSize: screenWidth * 0.05, color: Colors.white),
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
