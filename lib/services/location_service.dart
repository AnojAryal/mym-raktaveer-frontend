// ignore_for_file: file_names

import 'package:latlong2/latlong.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';

class LocationService {
  final ApiService _apiService;

  LocationService(this._apiService);

  Future<String?> sendLocationData(LatLng coordinates, String geoLocation) async {
    try {
      final response = await _apiService.postData('/location/create', {
        'x_coordinate': coordinates.latitude,
        'y_coordinate': coordinates.longitude,
        'geo_location': geoLocation,
      });

      if (response != null && response['id'] != null) {
        print(response);
        return response['id'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
