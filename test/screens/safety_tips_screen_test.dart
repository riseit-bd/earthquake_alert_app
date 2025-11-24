import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:earthquake_alert_app/screens/safety_tips_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('SafetyTipsScreen displays safety tips', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SafetyTipsScreen(),
      ),
    );

    expect(find.text('Safety Tips'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(4));
  });
}
