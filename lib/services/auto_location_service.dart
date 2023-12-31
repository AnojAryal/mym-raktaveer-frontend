import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

Future<void> autoSendLocationData(
    LatLng coordinates, String geoLocation, String accessToken) async {
  final String? baseUrl = dotenv.env['BASE_URL'];

  var url = Uri.parse('$baseUrl/api/locations/create');
  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: json.encode({
      'x_coordinates': coordinates.latitude,
      'y_coordinates': coordinates.longitude,
      'geo_location': geoLocation,
    }),
  );

  if (response.statusCode == 200) {
    // Handle successful response
  } else {
    // Handle error
  }
}
