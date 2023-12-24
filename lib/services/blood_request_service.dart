// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/blood_request_model.dart';

class BloodRequestService {
  final String baseUrl;
  static const String bloodRequestEndpoint = '/api/blood-donation-request';

  // Inject ApiService into BloodRequestService
  BloodRequestService(ApiService apiService) : baseUrl = apiService.baseUrl ?? '';

  String get bloodRequestUrl => '$baseUrl$bloodRequestEndpoint';

  Future<void> sendDataAndImageToBackend(
      BloodRequestModel requestData, Uint8List imageBytes) async {
    final client = http.Client();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(bloodRequestUrl),
      );

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

  Future<List<BloodRequestModel>?> fetchBloodRequests() async {
    final client = http.Client();

    try {
      final response = await client.get(
        Uri.parse(bloodRequestUrl),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> responseDataList = responseData['data'];

          return responseDataList.map<BloodRequestModel>((responseDataItem) {
            return BloodRequestModel.fromJson(responseDataItem);
          }).toList();
        } else {
          print(
              'Unexpected response format. "data" key is not present or does not contain a List.');
          return null;
        }
      } else {
        print(
            'Failed to fetch blood group data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching blood group data: $error');
      return null;
    } finally {
      client.close();
    }
  }
}
