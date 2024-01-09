// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:mym_raktaveer_frontend/widgets/location_fetcher.dart';
import 'background.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final CarouselController _carouselController = CarouselController();

  String? bloodGroup = '';
  int? donationCount = 0;
  bool? status;
  late final Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final userData = ref.watch(userDataProvider);
    final userUid = userData?.uid;
    String? apiUrl = 'api/personal-details/$userUid';

    try {
      final apiService = ApiService(); // Instantiate the ApiService
      final apiData = await apiService.getData(apiUrl, ref);
      setState(() {
        data = apiData;
      });

      if (data != null) {
        String? bloodGroupAbo =
            apiData?['data']['blood_detail']?['blood_group_abo'];
        String? bloodGroupRh =
            apiData?['data']['blood_detail']?['blood_group_rh'];

        setState(() {
          bloodGroup = (bloodGroupAbo != null && bloodGroupRh != null)
              ? bloodGroupAbo + bloodGroupRh
              : 'N/A';

          donationCount =
              apiData?['data']['blood_detail']?['donation_count'] ?? 0;
          status = apiData?['data']['blood_detail']?['status'] ?? false;
        });
      } else {
        print('Not Found');
        print('Response');
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
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Image1.jpg',
                            height: 150,
                            width: 250, // Set the desired width for your image
                            fit: BoxFit
                                .cover, // Ensure the image covers the available spac
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 155,
                    width:
                        250, // Ensure both height and width are equal for a perfect circle
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          16), // Half of the width/height for a perfect circle
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            5), // Same radius as the container for a perfect circle
                        child: Image.asset(
                          'assets/images/Image2.jpg',
                          height: 155,
                          width: 230,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 150,
                    width:
                        250, // Ensure both height and width are equal for a perfect circle
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          16), // Half of the width/height for a perfect circle
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            5), // Same radius as the container for a perfect circle
                        child: Image.asset(
                          'assets/images/Image2.jpg',
                          height: 150,
                          width: 230,
                          fit: BoxFit.cover,
                        ),
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
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/News1.jpg',
                        height: 145,
                        width: 250, // Set the desired width for your image
                        fit: BoxFit
                            .cover, // Ensure the image covers the available spac
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/News2.jpg',
                        height: 145,
                        width: 250, // Set the desired width for your image
                        fit: BoxFit
                            .cover, // Ensure the image covers the available spac
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/News2.jpg',
                        height: 145,
                        width: 250, // Set the desired width for your image
                        fit: BoxFit
                            .cover, // Ensure the image covers the available spac
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
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.healing, color: Colors.red),
                              SizedBox(height: 8.0),
                              Text('Blood Journey'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.info, color: Colors.red),
                              SizedBox(height: 8.0),
                              Text('About Us'),
                            ],
                          ),
                        ),
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
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/donor_available_request');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFD1A00),
                            foregroundColor: Colors.white,
                            fixedSize: const Size(130.0, 40.0),
                          ),
                          child: const Text('Donate Now'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/blood-request-form');
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Icon
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: const EdgeInsets.only(bottom: 0),
                          icon: const Icon(Icons.person),
                          color: const Color(0xFFFD1A00),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/profile-page',
                              arguments: data?['data'],
                            );
                          },
                        ),
                      ),

                      // Middle Text
                      const Text(
                        'MYM Raktaveer',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      // Notification Icon
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      )
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
