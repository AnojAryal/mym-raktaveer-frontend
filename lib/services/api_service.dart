import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<Map<String, dynamic>?> postData(
      String apiUrl, Map<String, dynamic> data) async {
    final String fullUrl = apiUrl;

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
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

  Future<Map<String, dynamic>?> getData(String apiUrl) async {
    final String fullUrl = "$baseUrl/$apiUrl";

    try {
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
        return null; // Consider a more descriptive error object or throwing an exception
      }
    } catch (error) {
      print('Error getting data: $error');
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }
}
