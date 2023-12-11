import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'background.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _carouselController = CarouselController();

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
    return Background(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarouselSlider(
                items: [
                  // Customize each item in the carousel
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article, color: Colors.white, size: 40),
                          SizedBox(height: 8.0),
                          Text(
                            'Article 1',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, color: Colors.white, size: 40),
                          SizedBox(height: 8.0),
                          Text(
                            'Photo Gallery',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_library,
                              color: Colors.white, size: 40),
                          SizedBox(height: 8.0),
                          Text(
                            'Videos',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 175.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 26),
                  pauseAutoPlayOnTouch: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
                carouselController: _carouselController,
              ),
            ),
            // Container with drop shadow
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Red-bordered heart icon with details
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(height: 8.0),
                          Text('$donationCount'),
                          const SizedBox(height: 8.0),
                          const Text('Lives Saved'),
                        ],
                      ),
                    ),
                    // Red-bordered blood type icon with details
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.opacity, color: Colors.red),
                          const SizedBox(height: 8.0),
                          Text('$bloodGroup'),
                          const SizedBox(height: 8.0),
                          const Text('Blood Type'),
                        ],
                      ),
                    ),
                    // Red-bordered active status icon with details
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.red),
                          const SizedBox(height: 8.0),
                          Text('$status'),
                          const SizedBox(height: 8.0),
                          const Text('Status'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Carousel after the Container
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarouselSlider(
                items: [
                  // Customize each item in the carousel
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Text(
                        'News 1',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Text(
                        'News 2',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Text(
                        'News 3',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 130.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 26),
                  pauseAutoPlayOnTouch: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
                carouselController: _carouselController,
              ),
            ),
            // Second Container after the second Carousel
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Blood Journey icon with details
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.healing, color: Colors.red),
                              SizedBox(height: 8.0),
                              Text('Blood Journey'),
                            ],
                          ),
                        ),
                        // About Us icon with details
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.info, color: Colors.red),
                              SizedBox(height: 8.0),
                              Text('About Us'),
                            ],
                          ),
                        ),
                        // Feedback icon with details
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.feedback, color: Colors.red),
                              SizedBox(height: 8.0),
                              Text('Feedback'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            16.0), // Add some space between icons and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFD1A00), // Background color
                            foregroundColor: Colors.white, // Text color
                            fixedSize: const Size(130.0, 40.0),
                          ),
                          child: const Text('Donate Now'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFD1A00), // Background color
                            foregroundColor: Colors.white, // Text color
                            fixedSize: const Size(130.0, 40.0),
                          ),
                          child: const Text('Find Donor'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Last Container after the second Container
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
      ),
    );
  }
}
