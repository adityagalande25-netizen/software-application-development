# 🚑 Accident Detection and Emergency Response System

A Flutter mobile application that automatically detects accidents using smartphone sensors and sends emergency alerts to pre-configured contacts.

## Features

- **Automatic Accident Detection**: Continuous monitoring of accelerometer and gyroscope sensors
- **Real-time GPS Tracking**: Automatic location capture during accidents
- **Emergency Alerts**: Instant SMS/push notifications to emergency contacts
- **10-Second Confirmation**: Users can cancel false alerts within 10 seconds
- **Manual SOS Button**: Quick manual alert trigger
- **Accident History**: View all accident reports with details
- **Emergency Contacts Management**: Add, edit, and prioritize emergency contacts
- **User Authentication**: Secure login/signup with Firebase
- **Cloud Storage**: Firebase backend for data persistence
- **Customizable Settings**: Adjust sensitivity and notification preferences

## System Architecture

```
Mobile Sensors (Accelerometer, Gyroscope, GPS)
        ↓
Mobile App (Impact Detection & Analysis)
        ↓
Cloud Database (Firebase Firestore)
        ↓
Emergency Contacts (SMS, Push Notifications)
```

## Accident Detection Algorithm

The app calculates the impact force using:

```
Impact Force = √(x² + y² + z²)
```

Where x, y, z are acceleration values from the accelerometer.

- **Threshold**: 25 m/s² (default, customizable)
- **Additional Checks**: 
  - Sudden drop in speed
  - Abnormal device orientation
  - No movement after impact

## Prerequisites

### Android
- Android 7.0 (API level 24) or higher
- Minimum 50MB free space
- Location services enabled

### iOS
- iOS 11.0 or higher
- Location services enabled
- Motion & Fitness permission

### Development
- Flutter SDK 3.11.0 or higher
- Dart 3.11.0 or higher
- Android Studio / Xcode

## Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd accident_detection_system
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Add Android app to Firebase project
4. Download `google-services.json`
5. Place it in `android/app/`

#### For iOS:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Add iOS app to Firebase project
3. Download `GoogleService-Info.plist`
4. Add to iOS project in Xcode

### 4. Build and Run

#### Android:
```bash
flutter run
```

#### iOS:
```bash
flutter run
```

## Permissions Required

### Android
- Access Fine Location
- Access Coarse Location
- Access Background Location
- Internet
- Send SMS
- Call Phone
- Vibrate
- Post Notifications
- Body Sensors

### iOS
- Location Services
- Motion & Fitness
- Notifications

## Folder Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # All UI screens
│   ├── auth/                 # Login/Signup screens
│   ├── dashboard/            # Home screen
│   ├── contacts/             # Emergency contacts management
│   ├── history/              # Accident history
│   └── settings/             # Settings & user profile
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── sensor_monitoring_service.dart
│   ├── location_service.dart
│   ├── database_service.dart
│   └── notification_service.dart
├── models/                   # Data models
│   ├── user_model.dart
│   ├── emergency_contact_model.dart
│   └── accident_report_model.dart
└── utils/                    # Utility functions
```

## Key Technologies

- **Flutter**: Cross-platform mobile framework
- **Firebase**: Authentication, Firestore, Storage
- **sensors_plus**: Device sensor access
- **geolocator**: GPS location services
- **awesome_notifications**: Push notifications
- **url_launcher**: Phone & SMS integration

## Usage

### First Time Setup
1. Sign up with email, phone, and password
2. Add emergency contacts with priority levels
3. Grant required permissions
4. Enable monitoring on dashboard

### During Operation
- **Green indicator**: Monitoring is active
- **Red indicator**: Monitoring is inactive
- **Manual SOS**: Press the red button anytime
- **Accident Detection**: 10-second confirmation window

## Testing

### Simulate Accident (Development)
1. Use Android Emulator's sensor simulation
2. Or manually trigger via manual SOS button

### Test Emergency Alert
1. Add test contacts with your phone number
2. Trigger manual SOS
3. Verify SMS received

## Troubleshooting

### Location Not Working
- Enable location services on device
- Grant "Always Allow" permission
- Check GPS signal

### SMS Not Sending
- Check phone has SMS capability
- Verify contact phone numbers
- Ensure SMS permission granted

### Firebase Connection Issues
- Verify internet connectivity
- Check Firebase credentials
- Ensure Firestore rules allow read/write

## Future Enhancements

- AI-based accident prediction
- Insurance company integration
- Smartwatch integration
- Vehicle OBD integration
- Multi-language support
- Offline functionality

## License

MIT License - See LICENSE file for details

## Support

For issues and questions:
- Open an issue on GitHub
- Contact: support@accidentdetection.app

## Disclaimer

This app is a supplementary safety tool. Always call emergency services directly if possible.

---

**Version**: 1.0.0  
**Platform**: Flutter (Android & iOS)
