# Accident Detection System - Setup Guide

## Project Overview

This is a complete Flutter application for detecting accidents automatically and sending emergency alerts. The app uses device sensors (accelerometer, gyroscope) to detect impacts and Firebase for backend services.

## Quick Start (5 minutes)

### 1. Environment Setup
```bash
# Verify Flutter installation
flutter doctor

# Upgrade Flutter
flutter upgrade

# Install dependencies
flutter pub get
```

### 2. Firebase Configuration

#### Android Setup:
1. Visit [Firebase Console](https://console.firebase.google.com)
2. Create new project (name: `accident-detection`)
3. Click "Add app" → Select Android
4. Package name: `com.example.accident_detection_system`
5. Download `google-services.json`
6. Copy to `android/app/`

#### iOS Setup:
1. In Firebase Console, Click "Add app" → Select iOS
2. Bundle ID: `com.example.accidentDetectionSystem`
3. Download `GoogleService-Info.plist`
4. In Xcode: Target → Runner → Build Phases
5. Add `GoogleService-Info.plist` to "Copy Bundle Resources"

### 3. Build and Run

```bash
# Android
flutter run -d emulator

# iOS
flutter run -d simulator
```

## Detailed Installation

### Prerequisites
```
- Flutter 3.11.0+
- Dart 3.11.0+
- Android Studio / Xcode
- Java Development Kit (JDK) 11+
- A Firebase project
```

### Step-by-Step Setup

#### 1. Project Creation
```bash
cd ~/projects
git clone https://github.com/yourusername/accident_detection_system.git
cd accident_detection_system
```

#### 2. Dependencies Installation
```bash
flutter pub get
flutter pub upgrade
```

#### 3. Firebase Project Setup

**Create Firebase Project:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Project name: `accident-detection-app`
4. Enable Google Analytics (optional)
5. Click "Create"

**Enable Services:**
1. Go to Build → Authentication
2. Select "Email/Password" provider
3. Go to Build → Firestore Database
4. Start in production mode
5. Choose your region

**Firestore Security Rules:**
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to access their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read, write: if request.auth.uid == userId;
      
      match /emergency_contacts/{contactId} {
        allow read, write: if request.auth.uid == userId;
      }
      
      match /accident_reports/{reportId} {
        allow read, write: if request.auth.uid == userId;
        allow create: if request.auth.uid == userId;
      }
    }
    
    // Global accident reports for analytics
    match /all_accident_reports/{reportId} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

**Android Configuration:**
1. In Firebase Console → Project Settings
2. Copy "Project ID"
3. Download `google-services.json`
4. Place in `android/app/`

**iOS Configuration:**
1. In Firebase Console → Project Settings
2. Download `GoogleService-Info.plist`
3. In Xcode:
   - Open Runner.xcworkspace (NOT xcodeproj)
   - Select Runner → Runner target
   - Build Phases → Copy Bundle Resources
   - Add `GoogleService-Info.plist`

#### 4. Android Configuration

**Update android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.accident_detection_system"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.1')
}

apply plugin: 'com.google.gms.google-services'
```

**Update android/build.gradle:**
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

#### 5. iOS Configuration

**Update ios/Podfile:**
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
        'PERMISSION_MOTION=1',
      ]
    end
  end
end
```

**Run Pod Install:**
```bash
cd ios
pod install --repo-update
cd ..
```

#### 6. Permissions

**Android (Already configured in AndroidManifest.xml)**

**iOS Permissions (Already configured in Info.plist)**

#### 7. Verify Setup

```bash
# Check Flutter setup
flutter doctor

# Check app structure
flutter analyze

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)  
flutter build ios --release
```

## Running the App

### Development

```bash
# Hot reload
flutter run

# Specific device
flutter run -d <device-id>

# Release build
flutter run --release
```

### List Available Devices

```bash
flutter devices
```

## Testing

### Run Tests
```bash
flutter test
```

### Security Testing
1. Test Firebase rules in console
2. Verify SMS permissions
3. Test location accuracy

## Build & Publish

### Android Release Build
```bash
# Create app bundle
flutter build appbundle --release

# Or APK
flutter build apk --release
```

### iOS Release Build
```bash
flutter build ios --release
```

## Troubleshooting

### Common Issues

**Issue: Firebase not initializing**
- Solution: Ensure google-services.json (Android) or GoogleService-Info.plist (iOS) is in correct location
- Verify Firebase project ID matches

**Issue: Permissions not working**
- Solution: Run on real device (not emulator)
- Grant permissions when prompted
- For iOS, check Info.plist entries

**Issue: GPS not working**
- Solution: Enable location services on device
- Use real device (emulator limited)
- Check location permission granted

**Issue: Sensors not detected**
- Solution: Emulator has limited sensor support
- Use real device for testing
- Use Android Emulator extended controls for sensor simulation

**Issue: SMS not sending**
- Solution: Use real device (not emulator)
- Ensure SMS capability available
- Check Twilio/Firebase integration

## Environment Variables

Create `.env` file (optional):
```
FIREBASE_PROJECT_ID=accident-detection-app
ENVIRONMENT=production
API_BASE_URL=https://api.example.com
```

Load in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const AccidentDetectionApp());
}
```

##  Project Structure

```
accident_detection_system/
├── android/                      # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── java/
│   │   └── build.gradle.kts
│   └── build.gradle.kts
├── ios/                          # iOS native code
│   ├── Runner/
│   │   ├── Info.plist
│   │   └── Runner.xcodeproj
│   └── Podfile
├── lib/                          # Flutter code
│   ├── main.dart
│   ├── models/                   # Data models
│   ├── services/                 # Business logic
│   ├── screens/                  # UI screens
│   ├── utils/                    # Utilities
│   └── widgets/                  # Reusable widgets
├── test/                         # Tests
├── pubspec.yaml                  # Dependencies
├── analysis_options.yaml         # Lint rules
└── README.md                     # Documentation
```

## Next Steps

1. **Configure Firebase Rules**: Update security rules for production
2. **Add Analytics**: Enable Firebase Analytics
3. **Set Up CI/CD**: Use GitHub Actions or Firebase CI
4. **Customize UI**: Modify colors and theme
5. **Add Testing**: Write unit and widget tests
6. **Deploy**: Publish to Google Play and Apple App Store

## Support & Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Documentation](https://dart.dev/guides)
- [GitHub Issues](https://github.com/yourrepo/issues)

## Version History

- **v1.0.0** (March 2026): Initial release

## License

MIT License - See LICENSE file

---

**Last Updated**: March 2026
