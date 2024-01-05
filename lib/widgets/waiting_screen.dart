import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:mym_raktaveer_frontend/services/blood_request_service.dart';
import 'package:mym_raktaveer_frontend/widgets/chat_page.dart';

class WaitingScreen extends ConsumerStatefulWidget {
  final int id;
  const WaitingScreen({super.key, required this.id});

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  String status = 'Loading...';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => fetchData());
  }

  Future<void> fetchData() async {
    final bloodRequestService = BloodRequestService(ApiService());
    final Map<String, dynamic> response =
        await bloodRequestService.fetchDonationPortal(widget.id, ref);

    print(response['data']);

    if (response['data']['status'] == 'approved') {
      print(response['data']);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  receiverUserEmail: response['data']['receiver_firebase_uid'],
                  receiverUserID: response['data']['receiver_firebase_uid'],
                )),
      );
    } else if (response['data']['status'] == 'pending') {
      print(response['data']);

      setState(() {
        status = 'Pending';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Checker'),
      ),
      body: Center(
        child: Text(status),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
