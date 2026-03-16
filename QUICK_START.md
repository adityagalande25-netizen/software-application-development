# ⚡ Accident Detection App - Quick Start Guide (5 Minutes)

## One-Time Setup (2 minutes)

### 1. Install Flutter
```bash
# Check if Flutter is installed
flutter --version

# If not installed, follow: https://flutter.dev/docs/get-started/install
```

### 2. Clone and Setup Project
```bash
cd ~/projects
git clone https://github.com/yourusername/accident_detection_system.git
cd accident_detection_system
flutter pub get
```

### 3. Firebase Configuration (Most Important!)
This is **required** to run the app.

**Android:**
1. Create project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app, package: `com.example.accident_detection_system`
3. Download `google-services.json`
4. Save to: `android/app/google-services.json`

**iOS:**
1. Add iOS app, bundle ID: `com.example.accidentDetectionSystem`
2. Download `GoogleService-Info.plist`
3. In Xcode: Drag to Runner target

---

## Run the App (3 minutes)

### Android Device/Emulator
```bash
# List devices
flutter devices

# Run on device
flutter run

# Or with specific device ID
flutter run -d emulator-5554
```

### iOS Simulator
```bash
# Run on iOS simulator
open -a Simulator
flutter run -d sim

# Or with specific simulator
flutter run -d "iPhone 15"
```

---

## First Use Walkthrough

### Step 1: Sign Up
```
1. Tap "Sign Up"
2. Enter:
   - Name: "John Doe"
   - Email: "john@example.com"
   - Phone: "+1234567890"
   - Password: "Test@1234"
3. Tap "Sign Up" button
```

### Step 2: Add Emergency Contacts
```
1. Go to "Emergency Contacts"
2. Tap "+" button
3. Enter:
   - Name: "Mom"
   - Phone: "+9876543210"
   - Relationship: "Mother"
   - Priority: 1
4. Tap "Add"
5. Add 2-3 more contacts
```

### Step 3: Enable Monitoring
```
1. Dashboard shows "Monitoring Inactive"
2. Toggle the switch to ON
3. Should show "Monitoring Active" in green
4. Grant all permissions when prompted
```

### Step 4: Test Manual SOS
```
1. Tap red "MANUAL SOS" button
2. Confirm you want to send alert
3. Check contacts for SMS (if real device with SMS)
4. View in "Accident History"
```

---

## Testing Impact Detection

### Android Emulator (Simulate Sensor)
```bash
# In Android Studio, with emulator running:
1. Open Emulator Control Panel (on right side)
2. Go to "Extended Controls"
3. Select "Sensors" → "Accelerometer"
4. Input high values:
   - X: 50, Y: 50, Z: 50
5. App should detect accident
6. Follow confirmation dialog
```

### Real Device
```
The best way to test is:
1. Enable monitoring
2. Give it a slight impact/bump
3. Or use manual SOS button
```

---

## Common Commands

```bash
# Clean build
flutter clean

# Get updates
flutter pub upgrade

# Run tests
flutter test

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release

# Check for issues
flutter analyze

# Check device status
flutter devices

# View logs
flutter logs
```

---

## File Structure Reference

```
lib/
├── main.dart                          # Entry point
├── screens/
│   ├── auth/login_screen.dart         # Login
│   ├── auth/signup_screen.dart        # Sign up
│   ├── dashboard/home_screen.dart     # Main dashboard
│   ├── contacts/emergency_*.dart      # Emergency contacts
│   ├── history/accident_*.dart        # History
│   └── settings/settings_*.dart       # Settings
├── services/
│   ├── auth_service.dart              # Firebase auth
│   ├── sensor_monitoring_service.dart # Sensors
│   ├── location_service.dart          # GPS
│   ├── database_service.dart          # Firestore
│   └── notification_service.dart      # Alerts
├── models/
│   ├── user_model.dart
│   ├── emergency_contact_model.dart
│   └── accident_report_model.dart
└── utils/
    ├── app_config.dart                # Constants
    ├── app_theme.dart                 # Theme
    └── app_exports.dart               # Exports
```

---

## Required Permissions on Device

### Android
```
✓ Location (Fine & Coarse)
✓ SMS
✓ Call Phone
✓ Body Sensors
✓ Notifications
✓ Camera (optional)
```

### iOS
```
✓ Location Services
✓ Motion & Fitness
✓ Notifications
```

When app starts, it will request these permissions.

---

## Troubleshooting

### "Cannot connect to Firebase"
```
✓ Check internet connection
✓ Verify google-services.json (Android) or GoogleService-Info.plist (iOS)
✓ Ensure Firebase project ID is correct
```

### "Permissions not working"
```
✓ Use real device (emulator has limited permissions)
✓ Go to Settings → Apps → accident_detection → Permissions
✓ Grant each permission manually
```

### "Sensors not detected"
```
✓ Emulator: Use Extended Controls → Sensors
✓ Real device: Ensure sensors work in phone settings
✓ Restart app if permissions just granted
```

### "Text shows garbled"
```
✓ Ensure google_fonts is properly installed
✓ Run: flutter pub get
✓ Rebuild app
```

### "App crashes on startup"
```
✓ Check Firebase setup
✓ Run: flutter clean
✓ Run: flutter pub get
✓ Rebuild app
```

---

## Environment Details

### Minimum Requirements
```
Android: API 24 (Android 7.0+)
iOS: 11.0+
Flutter: 3.11.0+
Dart: 3.11.0+
```

### Recommended
```
Android: API 34 (Android 14+)
iOS: 15.0+
Flutter: 3.16.0+
Dart: 3.16.0+
```

---

## Next Steps After First Run

1. **Customize Theme**
   - Edit `lib/utils/app_theme.dart`
   - Change colors and fonts

2. **Configure Sensitivity**
   - Settings → Impact Threshold
   - Adjust to detect impacts better

3. **Add More Contacts**
   - Emergency Contacts → +
   - Add family, friends, employer

4. **Enable Notifications**
   - Settings → Notifications
   - Enable SMS Alerts

5. **Test Emergency Flow**
   - Manual SOS → Verify SMS/notifications
   - Check accident history

---

## Resources

- **Flutter Docs**: https://docs.flutter.dev
- **Firebase Docs**: https://firebase.google.com/docs
- **GitHub Issues**: https://github.com/yourrepo/issues
- **Project Docs**: See README.md and SETUP_GUIDE.md

---

## Support

Need help?
1. Check SETUP_GUIDE.md for detailed setup
2. Review FEATURES_CHECKLIST.md for features
3. Check README.md for concepts
4. Add issue to GitHub

---

**Happy Coding! 🚀**

Last Updated: March 2026
