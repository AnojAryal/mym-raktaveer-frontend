// ignore_for_file: avoid_print
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';
import 'api_service.dart';
import '../models/blood_request_model.dart';

class BloodRequestService {
  final String baseUrl;

  // Inject ApiService into BloodRequestService
  BloodRequestService(ApiService apiService)
      : baseUrl = apiService.baseUrl ?? '';

  Future<void> sendDataAndImageToBackend(BloodRequestModel requestData,
      Uint8List imageBytes, WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);

    print(userData);
    final client = http.Client();
    String? jwtToken = userData?.acessToken;
    print(jwtToken);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/blood-donation-request'),
      );

      request.headers['Authorization'] = 'Bearer $jwtToken';

      request.files.add(
        http.MultipartFile.fromBytes(
          'document',
          imageBytes,
          filename: 'document.jpg',
        ),
      );

      // Convert requestData to Map and add each field separately

      final requestDataMap = requestData.toJson();
      requestDataMap.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      print(requestData.toJson());

      if (response.statusCode == 201) {
        print('Request sent successfully');
      } else if (response.statusCode == 302) {
        print(response.reasonPhrase);
        final redirectUrl = response.headers['location'];
        print('Redirecting to: $redirectUrl');
      } else {
        print('Failed to send request. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending request: $error');
    } finally {
      client.close();
    }
  }
}
