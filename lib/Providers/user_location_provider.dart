// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class UserLocationData {
  final LatLng? coordinates;
  final String? geoLocation;

  UserLocationData({required this.coordinates, required this.geoLocation});
}

final userLocationDataProvider =
    StateProvider<UserLocationData?>((ref) => null);
