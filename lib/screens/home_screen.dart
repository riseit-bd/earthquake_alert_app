import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:earthquake_alert_app/services/notification_service.dart';
import '../services/api_service.dart';
import '../models/earthquake.dart';
import '../models/city.dart';
import 'map_screen.dart';
import 'safety_tips_screen.dart';
import 'alert_screen.dart';

class HomeScreen extends StatefulWidget {
  final NotificationService notificationService;

  HomeScreen({required this.notificationService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Earthquake> earthquakes = [];
  bool loading = true;
  String? _errorMessage;
  PWaveAlert? _pWaveAlert;
  Timer? _alertTimer;

  @override
  void initState() {
    super.initState();
    fetchData();

    widget.notificationService.pWaveAlerts.listen((alert) {
      setState(() {
        _pWaveAlert = alert;
      });
      _alertTimer?.cancel();
      _alertTimer = Timer(const Duration(seconds: 10), () {
        setState(() {
          _pWaveAlert = null;
        });
      });
    });

    widget.notificationService.sWaveAlerts.listen((alert) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlertScreen(
            earthquake: alert.earthquake,
            city: alert.city,
            warningTime: alert.warningTime,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _alertTimer?.cancel();
    super.dispose();
  }

  void fetchData() async {
    setState(() {
      loading = true;
      _errorMessage = null;
    });
    try {
      var data = await ApiService().fetchAllEarthquakes();
      setState(() {
        earthquakes = data;
        loading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        loading = false;
      });
    }
  }

  void _simulateSWaveAlert() {
    final simulatedEarthquake = Earthquake(
      id: 'simulated123',
      agency: 'SIM',
      magnitude: 6.5,
      latitude: 26.5,
      longitude: 88.1,
      time: DateTime.now(),
    );
    final dhaka = monitoredCities.firstWhere((c) => c.name == 'Dhaka');
    widget.notificationService.simulateSWaveAlert(simulatedEarthquake, dhaka, 120);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: _simulateSWaveAlert,
              tooltip: 'Simulate S-Wave Alert',
            ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafetyTipsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_pWaveAlert != null)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.pWaveArrival(_pWaveAlert!.timeToArrival.toStringAsFixed(0)),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchData,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: earthquakes.length,
      itemBuilder: (context, index) {
        var eq = earthquakes[index];
        final formattedTime = DateFormat('yyyy-MM-dd – kk:mm').format(eq.time);
        return ListTile(
          title: Text('${eq.agency} - M${eq.magnitude}'),
          subtitle: Text(
              'Lat: ${eq.latitude}, Lon: ${eq.longitude}\nTime: $formattedTime'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(earthquakes: [eq]),
              ),
            );
          },
        );
      },
    );
  }
}
