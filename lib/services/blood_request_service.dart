// ignore_for_file: avoid_print
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/blood_request_model.dart';

class BloodRequestService {
  final String baseUrl;

  // Inject ApiService into BloodRequestService
  BloodRequestService(ApiService apiService)
      : baseUrl = apiService.baseUrl ?? '';

  Future<void> sendDataAndImageToBackend(
      BloodRequestModel requestData, Uint8List imageBytes) async {
    final client = http.Client();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/blood-donation-request'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'document',
          imageBytes,
          filename: 'document.jpg',
        ),
      );

      // Convert requestData to Map and add each field separately

      print(requestData);
      final requestDataMap = requestData.toJson();
      requestDataMap.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Request sent successfully');
      } else if (response.statusCode == 302) {
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
