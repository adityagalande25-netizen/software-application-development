# 🏗️ Accident Detection System - Architecture & Design

## System Overview

This Flutter application implements a comprehensive accident detection and emergency response system using modern mobile development best practices.

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter Application                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              User Interface Layer (Screens)               │   │
│  │  ┌────────────┬────────────┬──────────┬──────────────┐   │   │
│  │  │   Auth     │ Dashboard  │ Contacts │ History      │   │   │
│  │  │  Screens   │  Screens   │ Screens  │ & Settings   │   │   │
│  │  └────────────┴────────────┴──────────┴──────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              ↓                                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │           Business Logic Layer (Services)                │   │
│  │  ┌──────────┬──────────┬──────────┬──────────────┐       │   │
│  │  │ Auth     │ Sensor   │ Location │ Notification│       │   │
│  │  │ Service  │ Service  │ Service  │ Service      │       │   │
│  │  └──────────┴──────────┴──────────┴──────────────┘       │   │
│  │  ┌──────────────────────────────────────────────────┐    │   │
│  │  │         Database Service (Firestore)             │    │   │
│  │  └──────────────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              ↓                                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │            Data Layer (Models & Entities)                │   │
│  │  ┌──────────┬──────────────┬──────────────────────┐      │   │
│  │  │ User     │ Emergency    │ Accident Report      │      │   │
│  │  │ Model    │ Contact      │ Model                │      │   │
│  │  └──────────┴──────────────┴──────────────────────┘      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              ↓                                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │             External Services Integration                │   │
│  │  ┌──────────┬──────────┬──────────┬──────────────┐       │   │
│  │  │ Firebase │ Device   │ Location │ SMS/Push     │       │   │
│  │  │ Auth     │ Sensors  │ Services │ Notifications │      │   │
│  │  └──────────┴──────────┴──────────┴──────────────┘       │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## File Structure

```
accident_detection_system/
│
├── 📄 pubspec.yaml                          # Dependencies
├── 📄 analysis_options.yaml                 # Lint rules
├── 📄 README.md                             # Main documentation
├── 📄 SETUP_GUIDE.md                        # Installation guide
├── 📄 QUICK_START.md                        # 5-minute setup
├── 📄 FEATURES_CHECKLIST.md                 # All features
├── 📄 ARCHITECTURE.md                       # This file
│
├── 📁 android/                              # Android native code
│   ├── app/
│   │   ├── build.gradle.kts                 # Android build config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml          # Permissions & config
│   │       └── java/                        # Native Android code
│   ├── build.gradle.kts
│   ├── gradle.properties
│   ├── gradlew
│   ├── local.properties
│   └── settings.gradle.kts
│
├── 📁 ios/                                  # iOS native code
│   ├── Runner/
│   │   ├── Info.plist                       # iOS config & permissions
│   │   ├── AppDelegate.swift                # App delegate
│   │   ├── SceneDelegate.swift
│   │   └── Assets.xcassets/
│   ├── Runner.xcodeproj
│   └── Runner.xcworkspace
│
└── 📁 lib/ ⭐ Main Application Code
    │
    ├── main.dart                            # App entry point
    │
    ├── 📁 models/                           # Data models
    │   ├── user_model.dart
    │   ├── emergency_contact_model.dart
    │   └── accident_report_model.dart
    │
    ├── 📁 services/                         # Business logic
    │   ├── auth_service.dart                # Firebase authentication
    │   ├── sensor_monitoring_service.dart   # Accelerometer & gyroscope
    │   ├── location_service.dart            # GPS & geolocation
    │   ├── database_service.dart            # Firestore CRUD
    │   └── notification_service.dart        # Alerts & SMS
    │
    ├── 📁 screens/                          # UI screens
    │   │
    │   ├── 📁 auth/
    │   │   ├── login_screen.dart            # Login interface
    │   │   └── signup_screen.dart           # Registration interface
    │   │
    │   ├── 📁 dashboard/
    │   │   └── home_screen.dart             # Main dashboard
    │   │                                     # - Monitoring status
    │   │                                     # - Real-time sensor data
    │   │                                     # - Manual SOS button
    │   │                                     # - Quick actions
    │   │
    │   ├── 📁 contacts/
    │   │   └── emergency_contacts_screen.dart # Manage contacts
    │   │                                      # - Add/Edit/Delete
    │   │                                      # - Priority management
    │   │
    │   ├── 📁 history/
    │   │   └── accident_history_screen.dart  # View past reports
    │   │                                      # - Expandable details
    │   │                                      # - Severity indicators
    │   │
    │   └── 📁 settings/
    │       └── settings_screen.dart         # User settings
    │                                         # - Profile management
    │                                         # - Preferences
    │                                         # - Sensitivity tuning
    │
    └── 📁 utils/                            # Utilities & helpers
        ├── app_config.dart                  # Constants & config
        ├── app_theme.dart                   # Theme & styling
        └── exports.dart                     # Default exports
```

## Design Patterns

### 1. Service-Oriented Architecture (SOA)
```dart
// Separation of concerns
- AuthService: User authentication
- SensorMonitoringService: Sensor data processing
- LocationService: GPS operations
- DatabaseService: Firestore operations
- NotificationService: Alerts & notifications
```

### 2. Model-View-Screen Pattern (MVS)
```dart
// Data Models: User, EmergencyContact, AccidentReport
// Services: Business logic layer
// Screens: UI presentation layer
```

### 3. Repository Pattern (in DatabaseService)
```dart
// CRUD operations encapsulated
- Create: addEmergencyContact(), addAccidentReport()
- Read: getEmergencyContacts(), getAccidentReports()
- Update: updateAccidentReport()
- Delete: deleteEmergencyContact()
```

### 4. Singleton Pattern (Services)
```dart
// Each service acts as singleton
final AuthService authService = AuthService();
final SensorMonitoringService sensorService = SensorMonitoringService();
```

### 5. Observer Pattern
```dart
// Sensor callbacks
_sensorService.onImpactDetected = (force) { /* handle */ }
_sensorService.onSensorDataChanged = (data) { /* handle */ }
```

## Data Flow

### User Registration Flow
```
User Input
    ↓
LoginScreen/SignupScreen
    ↓
AuthService.signUp()
    ↓
Firebase Authentication
    ↓
Create Firestore User Document
    ↓
Navigate to Dashboard
```

### Accident Detection Flow
```
Sensor Data Stream
    ↓
SensorMonitoringService.startMonitoring()
    ↓
Calculate Impact Force: √(x² + y² + z²)
    ↓
Compare with Threshold (25 m/s²)
    ↓
If > Threshold:
  - NotificationService.sendAccidentDetected()
  - HomeScreen._handleAccidentDetected()
  - Show Confirmation Dialog (10 seconds)
    ↓
User Action:
  - Confirm: Send Emergency Alert
  - Cancel: Dismiss
    ↓
If Confirmed:
  - LocationService.getCurrentLocation()
  - Get Emergency Contacts
  - NotificationService.sendSMS()
  - DatabaseService.addAccidentReport()
  - Update Contact List
```

### Emergency Alert Flow
```
User presses Manual SOS / Impact Detected
    ↓
Get Current Location (GPS)
    ↓
Retrieve Emergency Contacts (Firestore)
    ↓
For each contact (sorted by priority):
  - Send SMS: Location + Emergency info
  - Log to DatabaseService
    ↓
Create AccidentReport
    ↓
Store in Firestore (users/{userId}/accident_reports)
    ↓
Update all_accident_reports (global collection)
    ↓
Notify user: "Alert sent to X contacts"
```

## State Management

### Local State (StatefulWidget)
```dart
class _HomeScreenState extends State<HomeScreen> {
  bool _isMonitoring = false;
  bool _accidentDetected = false;
  int _countdownSeconds = 10;
  Map<String, dynamic> _currentSensorData = {};
}
```

### Alternative: Provider Pattern (Future Enhancement)
```dart
// Could implement for complex state:
class AccidentProvider extends ChangeNotifier {
  bool _isMonitoring = false;
  
  void toggleMonitoring() {
    _isMonitoring = !_isMonitoring;
    notifyListeners();
  }
}
```

## API Integration

### Firebase Services Used

**1. Firebase Authentication**
```dart
- Email/Password signup
- Email/Password login
- Session management
- User profile management
```

**2. Cloud Firestore**
```
Collections Structure:
├── users/{userId}
│   ├── emergency_contacts/{contactId}
│   └── accident_reports/{reportId}
├── all_accident_reports/{reportId}
```

**3. Security Rules**
```firestore
- Users access only own data
- Contacts subcollection under user
- Accident reports both user-scoped and global
```

## Sensor Integration

### Accelerometer
```dart
// Real-time acceleration data
- Range: -10 to +10 m/s²
- Used for: Impact detection
- Formula: Force = √(x² + y² + z²)
```

### Gyroscope
```dart
// Real-time rotation data
- Used for: Abnormal orientation detection
- Helps verify accident vs. false positive
```

### GPS (Location)
```dart
// Location tracking
- Accuracy: 5-10 meters
- Used for: Emergency response
- Privacy: Only captured during accident
```

## Communication Protocols

### SMS Integration
```dart
// For emergency alerts
- PhoneNumber → SMS with location URL
- URL Format: Google Maps link
- Provider: Native SMS (Android/iOS)
```

### Push Notifications
```dart
// Local notifications for alerts
- Title: Accident detected
- Body: Impact force + severity
- Sound & Vibration: Enabled
- Channel Priority: Max (critical)
```

## Security Considerations

### Authentication
```
✓ Firebase email verification
✓ Secure password hashing
✓ Session token management
✓ Automatic logout on error
```

### Data Privacy
```
✓ User data encrypted in transit
✓ Firestore security rules
✓ No sensitive data in logs
✓ Location only during emergency
```

### Permissions
```
✓ Least privilege principle
✓ Runtime permissions (Android 6+)
✓ User control over features
✓ Clear permission explanations
```

## Performance Optimization

### Sensor Monitoring
```
- Frequency: 10-100 Hz (configurable)
- Buffer size: 100 samples
- Debounce: 500ms between impacts
- Power: Optimized for battery life
```

### Firebase Operations
```
- Batch updates where possible
- Lazy loading of data
- Real-time listeners only when active
- Indexed queries for speed
```

### UI Rendering
```
- Material Design 3 efficient rendering
- Hardware acceleration enabled
- Image optimization
- Minimal rebuilds (StatefulWidget)
```

## Scalability

### Horizontal Scaling
```
- Stateless services can be replicated
- Firebase handles multi-user scaling
- Cloud Firestore auto-scales
```

### Data Storage
```
- User collection: Unlimited
- Accident reports: Archive old data
- Contacts: 20 per user limit (configurable)
```

## Testing Strategy

### Unit Tests
```dart
- Model serialization/deserialization
- Service business logic
- Accident detection algorithm
```

### Widget Tests
```dart
- Screen rendering
- User interactions
- Navigation flows
```

### Integration Tests
```dart
- End-to-end user flows
- Firebase integration
- Sensor data processing
```

## Deployment Pipeline

### Development
```
1. Local testing (emulator/simulator)
2. Real device testing
3. Firebase staging project
```

### Production
```
1. Build APK/IPA
2. Firebase production project
3. Google Play Store / App Store
4. Version management
```

## Future Architecture Enhancements

1. **Provider Pattern**: Complex state management
2. **Repository Pattern**: Enhanced data abstraction
3. **BLoC Pattern**: Large-scale app architecture
4. **Clean Architecture**: Layered approach
5. **MVVM**: ViewModel pattern for testability

## Dependencies Management

### Core Dependencies
```yaml
firebase_core: ^2.24.0
firebase_auth: ^4.15.0
cloud_firestore: ^4.13.0
```

### Sensor & Location
```yaml
sensors_plus: ^3.0.0
geolocator: ^10.1.0
```

### UI
```yaml
google_fonts: ^6.1.0
awesome_notifications: ^0.8.0
```

### Utilities
```yaml
shared_preferences: ^2.2.0
intl: ^0.19.0
uuid: ^4.0.0
```

## Documentation

### Code Documentation
```dart
/// Triple-slash comments
/// Used for public APIs
/// Auto-generates IntelliSense
```

### Architecture Docs
```
- README.md: Overview
- SETUP_GUIDE.md: Installation
- QUICK_START.md: Quick reference
- FEATURES_CHECKLIST.md: Feature list
- ARCHITECTURE.md: Design details
```

---

## Key Metrics

- **Code Quality**: SOLID principles
- **Maintainability**: Service-oriented design
- **Scalability**: Cloud-based backend
- **Security**: Firebase auth + rules
- **Performance**: Optimized sensors
- **UX**: Material Design 3

---

**Version**: 1.0.0  
**Last Updated**: March 2026  
**Architecture Pattern**: Service-Oriented + MVVM Ready
