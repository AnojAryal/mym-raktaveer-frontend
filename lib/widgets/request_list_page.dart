// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/blood_request_model.dart';
import '../services/api_service.dart';
import '../services/blood_request_service.dart';

class RequestListPage extends ConsumerStatefulWidget {
  const RequestListPage({super.key});

  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends ConsumerState<RequestListPage> {
  List<BloodRequestModel> bloodRequestList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBloodRequestData();
      // Your function
    });
  }

  Future<void> fetchBloodRequestData() async {
    final bloodRequestService = BloodRequestService(ApiService());

    String param = "sort_by=preferred_datetime&sort_order=desc";

    // Fetch a list of blood request data from the backend
    final resultList = await bloodRequestService.fetchBloodRequests(ref, param);

    setState(() {
      bloodRequestList = resultList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Request Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bloodRequestList.length,
                itemBuilder: (context, index) {
                  final bloodRequest = bloodRequestList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Text(
                                'Quantity: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                bloodRequest.quantity,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Text(
                                'Blood Group: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                '${bloodRequest.bloodGroupAbo} ${bloodRequest.bloodGroupRh}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Text(
                                'Urgency Level: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                bloodRequest.urgencyLevel,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
