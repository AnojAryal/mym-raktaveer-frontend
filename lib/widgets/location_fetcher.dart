import 'package:geolocator/geolocator.dart';

Future<void> fetchLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Handle location service not enabled.
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try requesting permissions again.
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return;
  }

  // When we reach here, permissions are granted and we can fetch the location.
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  // Implement your logic to handle the location data, e.g., sending it to your server.
}
