// ignore_for_file: file_names

import 'package:latlong2/latlong.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';

class LocationService {
  final ApiService _apiService;

  LocationService(this._apiService);

  String baseUrl = ApiService().baseUrl ?? 'default_base_url';

  Future<String?> sendLocationData(
      LatLng coordinates, String geoLocation) async {
    try {
      final response =
          await _apiService.postData('$baseUrl/api/locations/create', {
        'x_coordinates': coordinates.latitude,
        'y_coordinates': coordinates.longitude,
        'geo_location': geoLocation,
      });

      if (response != null && response['location']['id'] != null) {
        String locationId = response['location']['id'].toString();
        return locationId;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
