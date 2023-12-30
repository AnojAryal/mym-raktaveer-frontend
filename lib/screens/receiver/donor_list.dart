// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class DonorList extends StatefulWidget {
  final Map<String, dynamic>? response;

  const DonorList({super.key, this.response});

  @override
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  late Map<String, dynamic> response;

  @override
  void initState() {
    super.initState();
    response = widget.response ?? {};
  }

  void updateResponseData(Map<String, dynamic> newResponseData) {
    setState(() {
      response = newResponseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extracting response from ModalRoute settings
    final Map<String, dynamic> responseData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    updateResponseData(responseData);
  
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
