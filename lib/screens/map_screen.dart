import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:earthquake_alert_app/l10n/app_localizations.dart';
import '../models/earthquake.dart';

class MapScreen extends StatelessWidget {
  final List<Earthquake> earthquakes;
  MapScreen({required this.earthquakes});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = earthquakes
        .map((eq) => Marker(
              markerId: MarkerId(eq.id),
              position: LatLng(eq.latitude, eq.longitude),
              infoWindow: InfoWindow(
                  title: '${eq.agency} - M${eq.magnitude}',
                  snippet: 'Time: ${eq.time}'),
            ))
        .toSet();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.earthquakeMap)),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 6),
        markers: markers,
      ),
    );
  }
}
