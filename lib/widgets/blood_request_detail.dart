// ignore_for_file: use_build_context_synchronously, avoid_print

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
  Future<BloodRequestModel?> _fetchRequestDetails() async {
    final bloodRequestService = BloodRequestService(ApiService());
    return await bloodRequestService.fetchBloodRequestDetail(
      ref,
      widget.requestId,
    );
  }

  void _handleRequestStatus(String status) async {
    final bloodRequestService = BloodRequestService(ApiService());

    try {
      if (widget.requestId != null) {
        await bloodRequestService.updateRequestStatus(
          widget.requestId!,
          status,
          ref, // pass the WidgetRef to the method
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request $status successfully!'),
          ),
        );
        print('Error: requestId is null');
      }
    } catch (error) {
      print('Error updating request status: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating request status. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: FutureBuilder<BloodRequestModel?>(
        future: _fetchRequestDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data found for this request.');
          } else {
            final bloodRequest = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth = constraints.maxWidth > 600
                    ? 400.0
                    : constraints.maxWidth * 0.9;
                return _buildContent(context, bloodRequest, containerWidth);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BloodRequestModel bloodRequest,
      double containerWidth) {
    String bloodGroup = bloodRequest.bloodGroupAbo + bloodRequest.bloodGroupRh;
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bloodRequest.user!.gender,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${bloodRequest.user!.age}",
                      style: const TextStyle(fontSize: 16),
                    ),
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
                  Text(
                    'Blood Group: $bloodGroup',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request: ${bloodRequest.quantity} ml',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Urgency: ${bloodRequest.urgencyLevel}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                              fontSize: 16,
                              color: Color(0xFFFD1A00),
                            ),
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
                              fontSize: 16,
                              color: Color(0xFFFD1A00),
                            ),
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
                              fontSize: 16,
                              color: Color(
                                0xFFFD1A00,
                              ),
                            ),
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
                            TextStyle(fontSize: 10, color: Color(0xFFFD1A00)),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          bloodRequest.dateAndTime,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download,
                        size: 30,
                        color: Colors.black,
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
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _handleRequestStatus('rejected');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFFD1A00),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(145.0, 40.0),
                    ),
                  ),
                  child: const Text(
                    'Reject request',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _handleRequestStatus('approved');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF99FDD2),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(145.0, 40.0),
                    ),
                  ),
                  child: const Text(
                    'Accept request',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
