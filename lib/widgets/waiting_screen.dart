import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:mym_raktaveer_frontend/services/blood_request_service.dart';

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
    if (response['data']['status'] == 'approved') {
      setState(() {
        status = 'Accepted';
      });
    } else if (response['data']['status'] == 'pending') {
      setState(() {
        status = 'Pending';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Checker'),
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
