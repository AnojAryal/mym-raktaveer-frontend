import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/blood_request_model.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/services/blood_request_service.dart';

class BloodRequestDetail extends ConsumerStatefulWidget {
  final int? requestId;

  const BloodRequestDetail({
    super.key,
    required this.requestId,
  });

  @override
  ConsumerState<BloodRequestDetail> createState() => _BloodRequestDetailState();
}

class _BloodRequestDetailState extends ConsumerState<BloodRequestDetail> {
  final double containerWidth = 400.0;

  // This method fetches data for the given requestId
  Future<BloodRequestModel?> _fetchRequestDetails() async {
    // This should be a call to your BloodRequestService
    final bloodRequestService = BloodRequestService(ApiService());

    return await bloodRequestService.fetchBloodRequestDetail(
        ref, widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: FutureBuilder<BloodRequestModel?>(
        future: _fetchRequestDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found for this request.');
          } else {
            final bloodRequest = snapshot.data!;
            return _buildContent(context, bloodRequest);
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BloodRequestModel bloodRequest) {
    String bloodGroup = bloodRequest.bloodGroupAbo + bloodRequest.bloodGroupRh;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          Padding(
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
          // Profile Picture, Name, and Email
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 16.0, top: 0.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          bloodRequest.user!.fullName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          bloodRequest.user!.email,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone Number',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(bloodRequest.user!.mobileNumber,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(bloodRequest.user!.gender,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Age',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("${bloodRequest.user!.age}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),

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
                  const Text(
                    'Blood Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Blood Group: $bloodGroup',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Request: ${bloodRequest.quantity} ml',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Urgency: ${bloodRequest.urgencyLevel}',
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
          // First Container with drop shadow and circular edges
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blood Request Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text(
                        'Patient Name:',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFD1A00)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bloodRequest.patientName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Age: ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFD1A00)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bloodRequest.age,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(width: 85),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sex: ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFD1A00)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bloodRequest.sex,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Hospital Name:',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFD1A00)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bloodRequest.hospitalName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Room No: ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFD1A00)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bloodRequest.roomNo,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OPD No: ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFD1A00)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bloodRequest.opdNo,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Location:',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFD1A00)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bloodRequest.location,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Date and Time:',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFD1A00)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bloodRequest.dateAndTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Download Document
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download,
                        size: 30,
                        color:
                            Colors.black, // Black color for the download icon
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Download Document',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFFFD1A00)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Additional Container with Note
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7DA),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Note:',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFFD1A00)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bloodRequest.description,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button: Send Donation Request
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
                // Add logic to send donation request
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFD1A00),
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Send Donation Request',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
