// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/blood_request_model.dart';
import 'package:mym_raktaveer_frontend/widgets/blood_request_detail_for_donor.dart';
import '../services/api_service.dart';
import '../services/blood_request_service.dart';
import 'blood_request_detail.dart';

class DonorAvailableRequestList extends ConsumerStatefulWidget {
  const DonorAvailableRequestList({
    super.key,
  });

  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends ConsumerState<DonorAvailableRequestList> {
  List<BloodRequestModel> bloodRequestList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBloodRequestData();
    });
  }

  Future<void> fetchBloodRequestData() async {
    final bloodRequestService = BloodRequestService(ApiService());

    // Fetch a list of blood request data from the backend
    final resultList =
        await bloodRequestService.fetchDonorAvailabeBloodRequests(ref);

    setState(() {
      bloodRequestList = resultList ?? [];
    });
  }

  Widget buildBloodRequestCard(BloodRequestModel bloodRequest) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              BloodRequestDetailForDonor(requestId: bloodRequest.id),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    const Text(
                      'Quantity: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      bloodRequest.quantity,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      'Blood Group: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${bloodRequest.bloodGroupAbo} ${bloodRequest.bloodGroupRh}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      'Urgency Level: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      bloodRequest.urgencyLevel,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: bloodRequestList.length,
                itemBuilder: (context, index) {
                  final bloodRequest = bloodRequestList[index];
                  return buildBloodRequestCard(bloodRequest);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
