import 'package:flutter/material.dart';
import 'package:earthquake_alert_app/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final notificationService = NotificationService();
  await notificationService.init(); // initialize notifications
  runApp(EarthquakeAlertApp(notificationService: notificationService));
}

class EarthquakeAlertApp extends StatelessWidget {
  final NotificationService notificationService;

  const EarthquakeAlertApp({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake Alert Bangladesh',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(notificationService: notificationService),
    );
  }
}
