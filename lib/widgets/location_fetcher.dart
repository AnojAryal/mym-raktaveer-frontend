import 'dart:convert';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';
import 'package:mym_raktaveer_frontend/services/auto_location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchLocation() async {
  LatLng cordinates;
  // Configure Background Geolocation
  bg.BackgroundGeolocation.ready(bg.Config(
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 10.0,
          stopOnTerminate: false,
          startOnBoot: true,
          debug: true,
          logLevel: bg.Config.LOG_LEVEL_VERBOSE))
      .then((bg.State state) {
    if (!state.enabled) {
      // Start the plugin if not enabled
      bg.BackgroundGeolocation.start();
    }
  });

  // Fired whenever a location is recorded
  bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    double latitude = location.coords.latitude;
    double longitude = location.coords.longitude;

    cordinates = LatLng(latitude, longitude);

    final geoLocation = await getPlaceNameFromCoordinates(latitude, longitude);
    sendLocation(cordinates, geoLocation);

    print(cordinates);
    print(geoLocation);
  });

  // Fired whenever the plugin changes motion-state
  bg.BackgroundGeolocation.onMotionChange((bg.Location location) async {
    double latitude = location.coords.latitude;
    double longitude = location.coords.longitude;

    cordinates = LatLng(latitude, longitude);

    final geoLocation = await getPlaceNameFromCoordinates(latitude, longitude);

    sendLocation(cordinates, geoLocation);

    print(cordinates);
    print(geoLocation);
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
    print('Error during reverse geocoding: $e');
    return "Error during reverse geocoding";
  }
}

Future<void> sendLocation(LatLng cordinates, String geoLocation) async {
  final prefs = await SharedPreferences.getInstance();
  final userDataJson = prefs.getString('userData');

  print("reached to send location");

  if (userDataJson == null) {
    return;
  }

  final userData = json.decode(userDataJson);

  if (userData['uid'] == null || userData['accessToken'] == null) {
    return;
  }

  String accessToken = userData['accessToken'];

  print(accessToken);

  autoSendLocationData(cordinates, geoLocation, accessToken);
}
