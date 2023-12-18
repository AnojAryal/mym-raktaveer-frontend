import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';

class BloodDonationService {
  final http.Client httpClient;

  BloodDonationService({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<ApiResponse> sendPersonalDataToApi(
      PersonalDetailModel personalDetailModel) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'default_base_url';
    String apiUrl = '$baseUrl/api/personal-details';

    final userUid = FirebaseAuth.instance.currentUser?.uid;

    final personalData = _createPersonalDataMap(userUid, personalDetailModel);

    try {
      final response = await httpClient.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(personalData),
      );

      return _handleResponse(response);
    } catch (error) {
      // Consider using a logger for better error handling
      debugPrint('Error sending data to API: $error');
      return ApiResponse.error('Error sending data to API');
    }
  }

  Map<String, dynamic> _createPersonalDataMap(
      String? userUid, PersonalDetailModel personalDetailModel) {
    return {
      'blood_group_abo': personalDetailModel.bloodGroupAbo,
      'blood_group_rh': personalDetailModel.bloodGroupRh,
      'user_id': userUid,
      if (personalDetailModel.lastDonationDate != null)
        'last_donation_date':
            personalDetailModel.lastDonationDate!.toIso8601String(),
      if (personalDetailModel.lastDonationReceived != null)
        'last_donation_received':
            personalDetailModel.lastDonationReceived!.toIso8601String(),
      ...?personalDetailModel.healthConditions,
    };
  }

  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 201) {
      return ApiResponse.success(json.decode(response.body));
    } else {
      return ApiResponse.error(
          'Failed with status code: ${response.statusCode}');
    }
  }
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  ApiResponse.success(this.data)
      : success = true,
        errorMessage = null;

  ApiResponse.error(this.errorMessage)
      : success = false,
        data = null;
}
