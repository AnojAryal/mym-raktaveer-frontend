// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
            child:const  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // You can add other widgets or text here if needed
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                _buildIconColumn(
                  Icons.person,
                  'Users',
                  screenWidth,
                ),

                // Admin Icon
                _buildIconColumn(
                  Icons.admin_panel_settings,
                  'Admins',
                  screenWidth,
                ),

                // Active Admins Icon
                _buildIconColumn(
                  Icons.supervised_user_circle,
                  'Active Admins',
                  screenWidth,
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Request Details',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600),
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
          SizedBox(
            height: screenHeight * 0.34,
            child: const RequestListPage(),
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
                padding: const EdgeInsets.all(14.0),
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
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn(IconData icon, String label, double screenWidth) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFD1A00),
            size: screenWidth * 0.08,
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.026,
            ),
          ),
        ],
      ),
    );
  }
}
