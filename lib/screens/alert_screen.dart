import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/earthquake.dart';
import '../models/city.dart';

class AlertScreen extends StatefulWidget {
  final Earthquake earthquake;
  final City city;
  final int warningTime;

  const AlertScreen({
    Key? key,
    required this.earthquake,
    required this.city,
    required this.warningTime,
  }) : super(key: key);

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.warningTime;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId('epicenter'),
        position: LatLng(widget.earthquake.latitude, widget.earthquake.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Epicenter'),
      ),
      Marker(
        markerId: MarkerId('city'),
        position: LatLng(widget.city.latitude, widget.city.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: widget.city.name),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('S-Wave Alert'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Countdown Timer
            Center(
              child: Text(
                _formatTime(_remainingTime),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // Earthquake Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Magnitude: ${widget.earthquake.magnitude}'),
                    Text('Agency: ${widget.earthquake.agency}'),
                    Text('City: ${widget.city.name}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Map
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.city.latitude, widget.city.longitude),
                  zoom: 6,
                ),
                markers: markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
