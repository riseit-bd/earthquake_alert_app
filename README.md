# Earthquake Alert App (Flutter)

## Overview
This is a Flutter-based Earthquake Alert App designed for Bangladesh.
The app aggregates earthquake data from multiple sources (USGS, EMSC, IRIS/BMD if available) and provides P-wave alerts to users in near real-time.

**Features:**
- Multi-agency earthquake feed integration
- P-wave detection alerts
- Map visualization of epicenters
- Safety tips section
- Push notifications via Firebase Cloud Messaging (FCM)
- User-friendly interface (Bangla + English)

## Firebase Setup

To connect the Flutter app to your Firebase project and enable push notifications, you must add the platform-specific Firebase configuration files.

### Android

1.  Go to your **Firebase project settings**.
2.  In the **Your apps** card, select the Android app.
3.  Download the `google-services.json` file.
4.  Place this file in the `earthquake_alert_app/android/app/` directory.

### iOS

1.  In the **Your apps** card of your Firebase project settings, select the iOS app.
2.  Download the `GoogleService-Info.plist` file.
3.  Open the `ios` directory in Xcode, then drag and drop the downloaded file into the `Runner` sub-directory.
