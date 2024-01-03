// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';
import '../../widgets/blood_request_detail.dart';

class DonorList extends ConsumerStatefulWidget {
  final Map<String, dynamic> response;

  const DonorList({super.key, required this.response});

  @override
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends ConsumerState<DonorList> {
  late Timer _timer;
  late List<Map<String, dynamic>> _participants;

  @override
  void initState() {
    super.initState();
    _participants = [];
    _timer =
        Timer.periodic(const Duration(seconds: 15), (Timer t) => _fetchData());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  void _fetchData() {
    int bloodRequestId = widget.response['data']?['request_detail']?['id'];
    final bloodRequestService = ref.read(bloodRequestServiceProvider);
    bloodRequestService.fetchParticipateList(bloodRequestId, ref).then((data) {
      if (mounted) {
        setState(() {
          _participants = data ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _participants.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : buildListView(_participants),
        ),
      ),
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
