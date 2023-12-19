import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class MapChoice extends StatefulWidget {
  const MapChoice({super. key}) ;

  @override
  State<MapChoice> createState() => _MapChoiceState();
}

class _MapChoiceState extends State<MapChoice> {
  List<Marker> markers = [];
  LatLng? selectedLocation;

  void _handleTap(LatLng latlng) {
    setState(() {
      selectedLocation = latlng;
      markers = [
        Marker(
          width: 40.0,
          height: 40.0,
          point: latlng,
          builder: (context) => const Icon(
            Icons.location_pin,
            color: Colors.red,
          ),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Select Location'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: selectedLocation ?? LatLng(28.3949, 84.1240),
                zoom: 7.0,
                onTap: (_, latlng) => _handleTap(latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
            if (selectedLocation != null)
              Positioned(
                top: kToolbarHeight + 16.0,
                left: 16.0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}',
                      style: const TextStyle(fontSize: 10.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
