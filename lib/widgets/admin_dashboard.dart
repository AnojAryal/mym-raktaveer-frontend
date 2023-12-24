// import 'package:flutter/material.dart';
// import 'package:mym_raktaveer_frontend/widgets/background.dart';
// import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Background(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20), // Added padding at the top

//           // Greeting Text Container
//           Container(
//             width: 330,
//             height: 180,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.white, // White background
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: const Text(
//               'Goggle Analytics',
//               style: TextStyle(
//                 color: Colors.black, // Black color
//                 fontSize: 16,
//               ),
//             ),
//           ),

//           Container(
//             width: 330, // Adjusted the width
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white, // White background
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // User Icon
//                 Column(
//                   children: [
//                     Icon(
//                       Icons.person,
//                       color: Color(0xFFFD1A00), // FD1A00 color
//                       size: 40,
//                     ),
//                     SizedBox(height: 12), // Increased the gap
//                     // User Text
//                     Text(
//                       'Users',
//                       style: TextStyle(
//                         color: Colors.black, // Black color
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Admin Icon
//                 Column(
//                   children: [
//                     Icon(
//                       Icons.admin_panel_settings,
//                       color: Color(0xFFFD1A00), // FD1A00 color
//                       size: 40,
//                     ),
//                     SizedBox(height: 12), // Increased the gap
//                     // Admin Text
//                     Text(
//                       'Admins',
//                       style: TextStyle(
//                         color: Colors.black, // Black color
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Active Admins Icon
//                 Column(
//                   children: [
//                     Icon(
//                       Icons.supervised_user_circle,
//                       color: Color(0xFFFD1A00), // FD1A00 color
//                       size: 40,
//                     ),
//                     SizedBox(height: 12), // Increased the gap
//                     // Active Admins Text
//                     Text(
//                       'Active Admins',
//                       style: TextStyle(
//                         color: Colors.black, // Black color
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),

//           const SizedBox(
//             height: 300, // Set a specific height as needed
//             child: RequestListPage(),
//           ),
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: 300.0,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFD1A00), // FD1A00 color
//                 borderRadius: BorderRadius.circular(16.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Profile Icon
//                     CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         color: Color(0xFFFD1A00),
//                       ),
//                     ),
//                     // Middle Text
//                     Text(
//                       'MYM Raktaveer',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                     // Notification Icon
//                     Icon(
//                       Icons.notifications,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           )
//         ],
//       ),
//     );
//   }
// }

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
    // Replace the URL with your actual analytics data endpoint
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
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // Added padding at the top

          // Greeting Text Container
          Container(
            width: 330,
            height: 180,
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
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Access your analytics data here and display it dynamically
                  final analyticsData = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Users: ${analyticsData['totalUsers']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Active Users: ${analyticsData['activeUsers']}',
                        style: TextStyle(
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

          Container(
            width: 330, // Adjusted the width
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // White background
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Icon
                Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFFFD1A00), // FD1A00 color
                      size: 40,
                    ),
                    SizedBox(height: 12), // Increased the gap
                    // User Text
                    Text(
                      'Users',
                      style: TextStyle(
                        color: Colors.black, // Black color
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                // Admin Icon
                Column(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFFFD1A00), // FD1A00 color
                      size: 40,
                    ),
                    SizedBox(height: 12), // Increased the gap
                    // Admin Text
                    Text(
                      'Admins',
                      style: TextStyle(
                        color: Colors.black, // Black color
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                // Active Admins Icon
                Column(
                  children: [
                    Icon(
                      Icons.supervised_user_circle,
                      color: Color(0xFFFD1A00), // FD1A00 color
                      size: 40,
                    ),
                    SizedBox(height: 12), // Increased the gap
                    // Active Admins Text
                    Text(
                      'Active Admins',
                      style: TextStyle(
                        color: Colors.black, // Black color
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const SizedBox(
            height: 300, // Set a specific height as needed
            child: RequestListPage(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300.0,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFD1A00), // FD1A00 color
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
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Icon
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFFD1A00),
                      ),
                    ),
                    // Middle Text
                    Text(
                      'MYM Raktaveer',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    // Notification Icon
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
