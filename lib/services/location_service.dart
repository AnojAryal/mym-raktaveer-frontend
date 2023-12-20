// ignore_for_file: avoid_print, file_names

import 'package:http/http.dart' as http;
import 'api_service.dart';

class LocationService {
  final String baseUrl;

  LocationService(ApiService apiService) : baseUrl = apiService.baseUrl ?? '';

  Future<void> sendHeadRequestToLocationCreate() async {
    final client = http.Client();

    try {
      final response = await client.head(
        Uri.parse('$baseUrl/location/create'),
      );

      if (response.statusCode == 200) {
        print('Head request to /location/create successful');
      } else {
        print(
            'Failed to send HEAD request. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending HEAD request: $error');
    } finally {
      client.close();
    }
  }
}
