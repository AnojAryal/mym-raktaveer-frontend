import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';
import '../../widgets/blood_request_detail.dart';

class DonorList extends ConsumerWidget {
  final Map<String, dynamic> response;

  const DonorList({super.key, required this.response});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int bloodRequestId = response['data']?['request_detail']?['id'];

    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 50.0),
                const Text(
                  'Donor List',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildParticipantList(bloodRequestId, ref),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>?> buildParticipantList(
      int bloodRequestId, WidgetRef ref) {
    final bloodRequestService = ref.read(bloodRequestServiceProvider);

    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: bloodRequestService.fetchParticipateList(bloodRequestId, ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Failed to fetch participants'));
        } else {
          return buildListView(snapshot.data!);
        }
      },
    );
  }

  Widget buildListView(List<Map<String, dynamic>> participants) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return buildParticipantCard(participants[index]);
      },
    );
  }

  InkWell buildParticipantCard(Map<String, dynamic> participant) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => BloodRequestDetail(requestId: bloodRequest.id),
        // ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          key: UniqueKey(),
          leading: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 20,
              color: Color(0xFFFD1A00), // Adjust the icon color
            ), // Adjust the background color of the circle
          ),
          title: Row(
            children: [
              Text(
                '${participant['full_name']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${participant['gender']}',
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Color.fromARGB(255, 78, 78, 78),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Age: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${participant['age']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 78, 78, 78),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),

              Row(
                children: [
                  const Text(
                    'Email: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${participant['email']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 78, 78, 78),
                    ),
                  ),
                ],
              ),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }
}

final bloodRequestServiceProvider = Provider<BloodRequestService>((ref) {
  return BloodRequestService(ref.read(apiServiceProvider));
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
