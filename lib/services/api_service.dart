import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> postData(String apiUrl, Map<String, dynamic> data) async {
    final String fullUrl = '$baseUrl/$apiUrl';

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error posting data: $error');
    }
  }

  getData(String apiUrl) {}
}
