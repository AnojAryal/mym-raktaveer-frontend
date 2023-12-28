// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';

class ApiService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<Map<String, dynamic>?> postAuthData(
      String apiUrl, Map<String, dynamic> data) async {
    final String fullUrl = apiUrl;

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Handle different status codes appropriately
        print('Failed to post data. Status code: ${response.statusCode}');
        print(response.body);
        return null; // Consider returning a more descriptive error object
      }
    } catch (error) {
      print('Error posting data: $error');
      rethrow; // Preserve error details
    }
  }

  Future<Map<String, dynamic>?> postData(
      WidgetRef ref, String apiUrl, Map<String, dynamic> data) async {
    final String fullUrl = apiUrl;

    final userData = ref.watch(userDataProvider);
    final jwtToken = userData?.accessToken;

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Handle different status codes appropriately
        print('Failed to post data. Status code: ${response.statusCode}');
        return null; // Consider returning a more descriptive error object
      }
    } catch (error) {
      print('Error posting data: $error');
      rethrow; // Preserve error details
    }
  }

  Future<Map<String, dynamic>?> getData(String apiUrl, WidgetRef ref) async {
    final String fullUrl = "$baseUrl/$apiUrl";
    final userData = ref.watch(userDataProvider);

    try {
      final jwtToken = userData?.accessToken;
      print(jwtToken);
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
// Include the JWT token in the 'Authorization' header
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
        print(response.body);
        return null; // Consider a more descriptive error object or throwing an exception
      }
    } catch (error) {
      print('Error getting data: $error');
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }
}
