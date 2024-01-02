import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:mym_raktaveer_frontend/services/user_location_service.dart';

Future<Map<String, dynamic>?> autoSendLocationData(
    LatLng coordinates, String geoLocation, userData) async {
  final String? baseUrl = dotenv.env['BASE_URL'];

  var url = Uri.parse('$baseUrl/api/locations/create');
  String acessToken = userData['accessToken'];

  try {
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $acessToken",
      },
      body: json.encode({
        'x_coordinates': coordinates.latitude,
        'y_coordinates': coordinates.longitude,
        'geo_location': geoLocation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      int locationId = (responseData['location']['id']);
      String userId = userData['uid'];

      await sendUserLocationData(locationId, userId, acessToken);
    }
  } catch (e) {
    // Handle error, you might want to log it or display a message.
    print('Error: $e');
  }

  return null;
}
