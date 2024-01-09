import 'dart:convert';
import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mym_raktaveer_frontend/services/auto_location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchLocation() async {
  LatLng coordinates;
  DateTime lastUpdateTime = DateTime.now().subtract(const Duration(minutes: 30));

  // Configure Background Geolocation
  bg.BackgroundGeolocation.ready(bg.Config(
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 100.0, // Increased distance filter
          stopOnTerminate: false,
          startOnBoot: true,
          debug: true,
          logLevel: bg.Config.LOG_LEVEL_VERBOSE))
      .then((bg.State state) {
    if (!state.enabled) {
      bg.BackgroundGeolocation.start();
    }
  });

  // Fired whenever a location is recorded
  bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    // Time check
    if (DateTime.now().difference(lastUpdateTime).inMinutes >= 10) {
      double latitude = location.coords.latitude;
      double longitude = location.coords.longitude;

      coordinates = LatLng(latitude, longitude);

      final geoLocation =
          await getPlaceNameFromCoordinates(latitude, longitude);
      sendLocation(coordinates, geoLocation);

      // Update the last update time
      lastUpdateTime = DateTime.now();
    }
  });

  // Fired when the state of location-services changes
  bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
    print('[providerchange] - $event');
  });
}

Future<String> getPlaceNameFromCoordinates(
    double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } else {
      return "No place found";
    }
  } catch (e) {
    return "Error during reverse geocoding";
  }
}

Future<void> sendLocation(LatLng coordinates, String geoLocation) async {
  final prefs = await SharedPreferences.getInstance();
  final userDataJson = prefs.getString('userData');
  prefs.setDouble('latitude', coordinates.latitude);
  prefs.setDouble('longitude', coordinates.longitude);

  if (userDataJson == null) {
    return;
  }

  final userData = json.decode(userDataJson);

  if (userData['uid'] == null || userData['accessToken'] == null) {
    return;
  }

  autoSendLocationData(coordinates, geoLocation, userData);
}
