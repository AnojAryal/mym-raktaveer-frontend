import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';
import 'api_service.dart';

class AcceptDonorRequestService {
  final ApiService _apiService;
  final WidgetRef _ref;

  AcceptDonorRequestService(this._apiService, this._ref);

  static const String bloodRequestEndpoint =
      '/api/blood-donation-request/accept-participate-request';

   Future<void> acceptRequest(int participantId) async {
    await _sendRequest(participantId, 'approved');
  }

  Future<void> rejectRequest(int participantId) async {
    await _sendRequest(participantId, 'rejected');
  }

  Future<void> _sendRequest(int participantId, String status) async {
    try {
      final String? firebaseUid = _ref.read(userDataProvider)?.uid;
      final String? accessToken = _ref.read(userDataProvider)?.accessToken;

      if (firebaseUid == null || accessToken == null) {
        print('Firebase UID or access token is null');
        return;
      }

      final response = await http.patch(
        Uri.parse(
            '${_apiService.baseUrl}/api/blood-donation-request/accept-participate-request/$participantId?receiver_firebase_uid=$firebaseUid&status=$status'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{}),
      );

      if (response.statusCode == 200) {
        print('$status request successful for participant ID: $participantId');
      } else {
        print('$status request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during $status request: $e');
    }
  }
}
