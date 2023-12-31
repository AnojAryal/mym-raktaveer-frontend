// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';

final bloodRequestProvider = Provider<BloodRequestService>(
  (ref) {
    return BloodRequestService(ApiService());
  },
);

class DonorList extends ConsumerStatefulWidget {
  const DonorList({super.key, this.response});

  final Map<String, dynamic>? response;

  @override
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends ConsumerState<DonorList> {
  late Map<String, dynamic> response;

 @override
void initState() {
  super.initState();
  response = widget.response ?? {};

  // Schedule the fetchBloodRequestDetails method to be called after the first frame is built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchBloodRequestDetails(ref);
  });
}

  void updateResponseData(Map<String, dynamic> newResponseData) {
    setState(() {
      response = newResponseData;
    });
  }

  Future<void> fetchBloodRequestDetails(WidgetRef ref) async {
    // Extracting response from ModalRoute settings
    final Map<String, dynamic> responseData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final int? requestId = responseData['data']?['request_detail']?['id'];

    if (requestId != null) {
      final bloodRequestService = ref.read(bloodRequestProvider);

      final bloodRequest =
          await bloodRequestService.fetchBloodRequestDetail(ref, requestId);

      if (bloodRequest != null) {
        // Update the response data with the fetched details
        updateResponseData({
          'data': {
            'request_detail': {
              'id': bloodRequest.id,
            },
          },
        });
      } else {
        print('Failed to fetch blood request details.');
      }
    }
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
              const Text(
                'Attention: Blood request has been sent. Please wait until our administration verifies your request.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
