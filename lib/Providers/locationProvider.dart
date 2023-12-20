import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class LocationData {
  final LatLng? coordinates;
  final String? geoLocation;

  LocationData({required this.coordinates, required this.geoLocation});
}

final locationDataProvider = StateProvider<LocationData?>((ref) => null);
