import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:earthquake_alert_app/services/location_service.dart';
import 'package:earthquake_alert_app/utils/distance_calculator.dart';
import 'package:earthquake_alert_app/utils/p_wave_estimator.dart';
import 'package:earthquake_alert_app/models/earthquake.dart';
import 'package:earthquake_alert_app/models/city.dart';

class PWaveAlert {
  final Earthquake earthquake;
  final double timeToArrival;

  PWaveAlert({required this.earthquake, required this.timeToArrival});
}

class SWaveAlert {
  final Earthquake earthquake;
  final City city;
  final int warningTime;

  SWaveAlert({required this.earthquake, required this.city, required this.warningTime});
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final LocationService _locationService = LocationService();
  final StreamController<PWaveAlert> _pWaveAlertController = StreamController<PWaveAlert>.broadcast();
  final StreamController<SWaveAlert> _sWaveAlertController = StreamController<SWaveAlert>.broadcast();

  Stream<PWaveAlert> get pWaveAlerts => _pWaveAlertController.stream;
  Stream<SWaveAlert> get sWaveAlerts => _sWaveAlertController.stream;

  Future<void> init() async {
    await _messaging.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('New earthquake alert: ${message.notification?.title}');
      _handleIncomingMessage(message);
    });

    await _subscribeToTopics();
  }

  Future<void> _subscribeToTopics() async {
    for (final city in monitoredCities) {
      final topic = 'city_${city.name.toLowerCase()}';
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    }
  }

  Future<void> _handleIncomingMessage(RemoteMessage message) async {
    final messageType = message.data['messageType'];

    if (messageType == 'sWave') {
      final earthquake = Earthquake.fromFCM(message.data);
      final city = monitoredCities.firstWhere((c) => c.name == message.data['city']);
      final warningTime = int.tryParse(message.data['warningTime'] ?? '0') ?? 0;
      _sWaveAlertController.add(SWaveAlert(earthquake: earthquake, city: city, warningTime: warningTime));
    } else {
      final earthquake = Earthquake.fromFCM(message.data);

      final userLocation = await _locationService.getUserLocation();
      if (userLocation == null) {
        return;
      }

      final distance = DistanceCalculator.calculateDistance(
        userLocation.latitude!,
        userLocation.longitude!,
        earthquake.latitude,
        earthquake.longitude,
      );

      final pWaveTravelTime = PWaveEstimator.estimatePWaveTravelTime(distance);
      final timeSinceEarthquake = DateTime.now().difference(earthquake.time).inSeconds;

      if (pWaveTravelTime > timeSinceEarthquake) {
        final timeToArrival = pWaveTravelTime - timeSinceEarthquake;
        _showPWaveAlert(earthquake, timeToArrival);
        _pWaveAlertController.add(PWaveAlert(earthquake: earthquake, timeToArrival: timeToArrival));
      }
    }
  }

  void simulateSWaveAlert(Earthquake earthquake, City city, int warningTime) {
    _sWaveAlertController.add(SWaveAlert(earthquake: earthquake, city: city, warningTime: warningTime));
  }

  Future<void> _showPWaveAlert(Earthquake earthquake, double timeToArrival) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('p_wave_alert', 'P-Wave Alerts',
            channelDescription: 'Alerts for incoming P-waves',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotifications.show(
        0,
        'P-Wave Alert!',
        'An earthquake has occurred. Estimated P-wave arrival in ${timeToArrival.toStringAsFixed(0)} seconds.',
        platformChannelSpecifics,
        payload: 'p_wave_alert');
  }

  void dispose() {
    _pWaveAlertController.close();
    _sWaveAlertController.close();
  }
}
