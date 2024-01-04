import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> sendUserLocationData(
    int locationId, String userId, String acessToken) async {
  final String? baseUrl = dotenv.env['BASE_URL'];

  var url = Uri.parse('$baseUrl/api/user-locations/create');

  try {
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $acessToken",
      },
      body: json.encode({
        'user_id': userId,
        'location_id': locationId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('success');
    }
  } catch (e) {
    // Handle error, you might want to log it or display a message.
    print('Error: $e');
  }

  return null;
}
