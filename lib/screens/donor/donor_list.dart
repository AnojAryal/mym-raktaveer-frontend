// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';

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
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => _fetchData());
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

  Card buildParticipantCard(Map<String, dynamic> participant) {
    return Card(
      child: ListTile(
        key: UniqueKey(),
        title: Text('Name: ${participant['full_name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${participant['age']}'),
            Text('Gender: ${participant['gender']}'),
            Text('Email: ${participant['email']}'),
            // Add more details as needed
          ],
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
