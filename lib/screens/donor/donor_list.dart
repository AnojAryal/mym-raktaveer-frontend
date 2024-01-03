// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/screens/donor/donor_profile.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/blood_request_service.dart';
import '../../widgets/background.dart';

class DonorList extends ConsumerStatefulWidget {
  final Map<String, dynamic> response;

  const DonorList({
    super.key,
    required this.response,
  });

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20.0),
                Text(
                  'Donor List',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: _participants.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : buildListView(_participants),
            ),
          ),
        ],
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DonorProfile(participantData: participant)));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: ListTile(
          key: UniqueKey(),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.person,
              size: 20,
              color: Colors.white,
            ),
          ),
          title: Row(
            children: [
              Text(
                '${participant['full_name']}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${participant['gender']}',
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.grey,
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
                  Text(
                    'Age: ',
                    style: TextStyle(
                      fontSize: screenWidth * 0.036,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${participant['age']}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.036,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
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
