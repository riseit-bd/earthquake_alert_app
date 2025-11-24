import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SafetyTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
      AppLocalizations.of(context)!.safetyTip1,
      AppLocalizations.of(context)!.safetyTip2,
      AppLocalizations.of(context)!.safetyTip3,
      AppLocalizations.of(context)!.safetyTip4,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.safetyTips)),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text(tips[index]),
          );
        },
      ),
    );
  }
}
