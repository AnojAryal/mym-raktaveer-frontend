import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';

class DonorList extends ConsumerWidget {
  final Map<String, dynamic> response;

  const DonorList({super.key, required this.response});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int bloodRequestId = response['data']?['request_detail']?['id'];

    final apiService = ApiService();
    final bloodRequestService = BloodRequestService(apiService);

    return Background(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>?>(
            future: bloodRequestService.fetchParticipateList(bloodRequestId, ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Failed to fetch participants'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> participant = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        title: Text('Participant: ${participant['full_name']}'),
                        subtitle: Text('Email: ${participant['email']}'),
                        // Add more details as needed
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
