// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';
import '../donor/donor_list.dart';


class ApprovalRequest extends ConsumerStatefulWidget {
  const ApprovalRequest({super.key, this.response});

  final Map<String, dynamic>? response;

  @override
  _ApprovalRequestState createState() => _ApprovalRequestState();
}

class _ApprovalRequestState extends ConsumerState<ApprovalRequest> {
  late Map<String, dynamic> response;
  late Timer statusCheckTimer;
  bool acceptedStatus = false;

  final bloodRequestProvider = Provider<BloodRequestService>(
    (ref) {
      return BloodRequestService(ApiService());
    },
  );

  @override
  void initState() {
    super.initState();
    response = widget.response ?? {};

    // Start a periodic timer to check the status every 15 seconds
    statusCheckTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      checkStatusAndHandleUpdates(ref);
    });

    // Schedule the fetchBloodRequestDetails method to be called after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBloodRequestDetails(ref);
    });
  }

 void checkStatusAndHandleUpdates(WidgetRef ref) async {
    try {
      final String? status = response['data']?['request_detail']?['status'];

      print('Checking status: $status');

      if (status != null && status == 'approved') {
        print('Status is approved');
        statusCheckTimer.cancel();
        setState(() {
          acceptedStatus = true;
        });

        // Navigate to the donor list page here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DonorList(response: response),
          ),
        );
      } else {
        fetchBloodRequestDetails(ref);
      }
    } catch (e) {
      print('Error in checkStatusAndHandleUpdates: $e');
    }
  }

  void updateResponseData(Map<String, dynamic> newResponseData) {
    setState(() {
      response = newResponseData;
    });
  }

  Future<void> fetchBloodRequestDetails(WidgetRef ref) async {
    // Extracting response from ModalRoute settings
    final Map<String, dynamic> responseData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int? requestId = responseData['data']?['request_detail']?['id'];

    if (requestId != null) {
      final bloodRequestService = ref.watch(bloodRequestProvider);

      final bloodRequest =
          await bloodRequestService.fetchBloodRequestDetail(ref, requestId);

      if (bloodRequest != null) {
        print('The response fetched from backend: ${bloodRequest.toJson()}');
        // Update the response data with the fetched details
        updateResponseData({
          'data': {
            'request_detail': {
              'id': bloodRequest.id,
              'status': bloodRequest.status,
            },
          },
        });
      } else {
        print('Failed to fetch blood request details.');
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the periodic timer when the widget is disposed
    statusCheckTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!acceptedStatus)
                const Text(
                  'Attention: Blood request has been sent. Please wait until our administration verifies your request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              else
                const Text(
                  'Your request has been approved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Blood Request ID: ${response['data']?['request_detail']?['id'] ?? 'N/A'}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
