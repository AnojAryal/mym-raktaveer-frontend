// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';
import 'api_service.dart';
import '../models/blood_request_model.dart';

class BloodRequestService {
  final String baseUrl;
  static const String bloodRequestEndpoint = '/api/blood-donation-request';

  // Inject ApiService into BloodRequestService
  BloodRequestService(ApiService apiService)
      : baseUrl = apiService.baseUrl ?? '';

  String get bloodRequestUrl => '$baseUrl$bloodRequestEndpoint';

  Future<Map<String, dynamic>?> sendDataAndImageToBackend(
    BloodRequestModel requestData,
    Uint8List imageBytes,
    WidgetRef ref,
  ) async {
    final userData = ref.watch(userDataProvider);
    final client = http.Client();
    String? jwtToken = userData?.accessToken;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(bloodRequestUrl),
      );

      request.headers['Authorization'] = 'Bearer $jwtToken';
      request.headers['Accept'] = 'application/json';

      request.files.add(
        http.MultipartFile.fromBytes(
          'document',
          imageBytes,
          filename: 'document.jpg',
        ),
      );

      final requestDataMap = requestData.toJson();
      requestDataMap.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        print('Request sent successfully');
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('request_detail') &&
            responseData['data']['request_detail'].containsKey('id')) {
          return responseData;
        } else {
          print('Invalid response structure, id not available');
        }
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

    return null;
  }

  Future<BloodRequestModel?> fetchBloodRequestDetail(
    WidgetRef ref,
    int? requestId,
  ) async {
    final client = http.Client();
    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;

    try {
      final response = await client.get(
        Uri.parse("$bloodRequestUrl/$requestId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        return BloodRequestModel.fromJson(responseData['data']);
      } else {
        print(
            'Failed to fetch blood request details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching blood request details: $error');
      return null;
    } finally {
      client.close();
    }
  }

  Future<List<BloodRequestModel>?> fetchBloodRequests(
      WidgetRef ref, param) async {
    final client = http.Client();

    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;

    try {
      final response = await client.get(
        Uri.parse("$bloodRequestUrl? $param"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);

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

  Future<Map<String, dynamic>> createDonationPortal(
      int requestId, WidgetRef ref) async {
    final client = http.Client();
    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;
    String? firebaseUid = userData?.uid;

    try {
      final response = await client.post(
        Uri.parse("$bloodRequestUrl/request-to-participate"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'donor_firebase_uid': firebaseUid,
          'blood_request_id': requestId,
        }),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        print('Request failed with status: ${response.statusCode}');

        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating request status: $error');

      throw Exception('Error updating request status: $error');
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> fetchDonationPortal(
      int portalId, WidgetRef ref) async {
    final client = http.Client();
    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;

    try {
      final response = await client.get(
        Uri.parse("$bloodRequestUrl/portal-detail/$portalId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating request status: $error');

      throw Exception('Error updating request status: $error');
    } finally {
      client.close();
    }
  }

  Future<void> updateRequestStatus(
      int requestId, String status, WidgetRef ref) async {
    final client = http.Client();
    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;

    try {
      final response = await client.put(
        Uri.parse("$bloodRequestUrl/$requestId?status=$status"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        print('Request status updated successfully');
      } else {
        print(
            'Failed to update request status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error updating request status: $error');
    } finally {
      client.close();
    }
  }

  Future<List<BloodRequestModel>?> fetchDonorAvailabeBloodRequests(
      WidgetRef ref) async {
    final client = http.Client();

    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;
    String? uid = userData?.uid;

    try {
      final response = await client.get(
        Uri.parse("$bloodRequestUrl/available-request/$uid"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);

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

  Future<List<Map<String, dynamic>>?> fetchParticipateList(
      int requestId, WidgetRef ref) async {
    final client = http.Client();

    final userData = ref.watch(userDataProvider);
    String? jwtToken = userData?.accessToken;

    try {
      final response = await client.get(
        Uri.parse("$bloodRequestUrl/participate-list/$requestId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Raw API Response: ${response.body}");
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        if (responseData.containsKey('data')) {
          final dynamic data = responseData['data'];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else {
            print(
                'Unexpected response format. "data" key does not contain a List.');
            return null;
          }
        } else {
          print('Unexpected response format. "data" key is not present.');
          return null;
        }
      } else {
        print(
            'Failed to fetch participate list. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching participate list: $error');
      return null;
    } finally {
      client.close();
    }
  }
}
