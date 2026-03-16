# 📑 Project File Index & Quick Navigation

## 📄 Documentation Files (START HERE!)

| File | Purpose | Read Time | Lines |
|------|---------|-----------|-------|
| **README.md** | 🎯 Main project overview, features, and usage | 10 min | 370 |
| **PROJECT_SUMMARY.md** | 📊 Complete project status and deliverables | 5 min | 400 |
| **QUICK_START.md** | ⚡ 5-minute setup guide (BEST FOR NEW USERS) | 3 min | 250 |
| **SETUP_GUIDE.md** | 🔧 Detailed installation and Firebase setup | 20 min | 400 |
| **ARCHITECTURE.md** | 🏗️ System design and architecture details | 15 min | 350 |
| **FEATURES_CHECKLIST.md** | ✅ Complete list of 100+ features | 5 min | 300 |
| **pubspec.yaml** | 📦 Dependencies and project configuration | 2 min | 80 |

---

## 🎬 Suggested Reading Order

### For Users (Want to use the app)
1. **QUICK_START.md** (3 min) - Get running in 5 minutes
2. **README.md** (10 min) - Understand features
3. **In-app help** - Use while exploring

### For Developers (Want to build/modify)
1. **PROJECT_SUMMARY.md** (5 min) - Overview
2. **ARCHITECTURE.md** (15 min) - Understand structure
3. **SETUP_GUIDE.md** (20 min) - Detailed setup
4. **Code comments** - In the actual files

### For Managers (Need to understand the product)
1. **PROJECT_SUMMARY.md** (5 min) - Status & deliverables
2. **FEATURES_CHECKLIST.md** (5 min) - What's included
3. **README.md** (10 min) - Complete overview

---

## 📁 Source Code Structure

### Main Application Entry
```
lib/main.dart (35 lines)
├─ Entry point
├─ Firebase initialization
├─ Theme setup
└─ Navigation to login
```

### 🔐 Authentication (lib/screens/auth/)
```
├─ login_screen.dart (125 lines)
│  ├─ Email/password input
│  ├─ Form validation
│  └─ Firebase authentication
│
└─ signup_screen.dart (145 lines)
   ├─ User registration form
   ├─ Phone number input
   └─ Account creation
```

### 📊 Dashboard (lib/screens/dashboard/)
```
└─ home_screen.dart (400+ lines)
   ├─ Monitoring status display
   ├─ Real-time sensor data
   ├─ Manual SOS button
   ├─ Accident confirmation dialog
   ├─ Quick action cards
   └─ Help dialog
```

### 👥 Emergency Contacts (lib/screens/contacts/)
```
└─ emergency_contacts_screen.dart (180 lines)
   ├─ Add new contact form
   ├─ Edit contact dialog
   ├─ Delete confirmation
   ├─ Priority management
   └─ Contact list display
```

### 📜 Accident History (lib/screens/history/)
```
└─ accident_history_screen.dart (200+ lines)
   ├─ List of accident reports
   ├─ Expandable report details
   ├─ Severity indicators
   ├─ Location information
   └─ Empty state message
```

### ⚙️ Settings (lib/screens/settings/)
```
└─ settings_screen.dart (250+ lines)
   ├─ User profile section
   ├─ Notification preferences
   ├─ Sensor settings (threshold)
   ├─ About section
   └─ Logout button
```

---

## 🔧 Services (lib/services/)

### Authentication Service
```
auth_service.dart (150 lines)
├─ Firebase authentication
├─ User registration
├─ User login
├─ Profile management
├─ Monitoring toggle
└─ Logout
```

### Sensor Monitoring Service
```
sensor_monitoring_service.dart (200+ lines)
├─ Accelerometer data collection
├─ Gyroscope data collection
├─ Impact force calculation
├─ Impact detection with debounce
├─ Sensor data callbacks
├─ Buffer management
└─ Algorithm analysis
```

### Location Service
```
location_service.dart (120 lines)
├─ Permission request
├─ Current location acquisition
├─ Location stream
├─ Distance calculation
├─ Google Maps URL generation
├─ Reverse geocoding
└─ Address resolution
```

### Database Service
```
database_service.dart (280+ lines)
├─ Emergency Contacts:
│  ├─ Add contact
│  ├─ Get contacts
│  ├─ Update contact
│  └─ Delete contact
├─ Accident Reports:
│  ├─ Add report
│  ├─ Get reports
│  ├─ Update report
│  ├─ Delete report
│  └─ Get statistics
└─ Firestore collections management
```

### Notification Service
```
notification_service.dart (160 lines)
├─ Initialize notifications
├─ Accident alert notification
├─ Emergency alert notification
├─ General notification
├─ Call emergency number
├─ Send SMS
├─ Open map URL
└─ Cancel notifications
```

---

## 📦 Models (lib/models/)

### User Model
```
user_model.dart (70 lines)
├─ uid, name, email, phone
├─ profileImageUrl
├─ createdAt, monitoringEnabled
├─ toMap() / fromMap()
└─ copyWith()
```

### Emergency Contact Model
```
emergency_contact_model.dart (80 lines)
├─ id, userId, name, phone
├─ email, relationship, priority
├─ createdAt
├─ toMap() / fromMap()
└─ copyWith()
```

### Accident Report Model
```
accident_report_model.dart (100 lines)
├─ id, userId, timestamp
├─ latitude, longitude
├─ impactForce, severity
├─ alertSent, contactsAlerted
├─ mapUrl, status, userNote
├─ toMap() / fromMap()
└─ copyWith()
```

---

## 🎨 Utilities (lib/utils/)

### App Configuration
```
app_config.dart (250 lines)
├─ App Info Constants
├─ Sensor Configuration
├─ Accident Detection Constants
├─ GPS Configuration
├─ UI Configuration
├─ Database Collections
├─ Error Messages
├─ Validation Rules
├─ Firebase Topics
├─ Priority & Status Mappings
└─ UI Strings
```

### App Theme
```
app_theme.dart (300 lines)
├─ Color Palette
├─ Light Theme
├─ Dark Theme (optional)
├─ Text Themes
├─ Button Themes
├─ Input Themes
├─ Card Themes
├─ Spacing Constants
├─ Border Radius
├─ Font Sizes
├─ Shadows
└─ Animation Durations
```

### Exports
```
exports.dart (5 lines)
└─ Common package exports
```

---

## ⚙️ Android Configuration (android/)

### AndroidManifest.xml
```
Permissions Added:
✅ ACCESS_FINE_LOCATION
✅ ACCESS_COARSE_LOCATION
✅ ACCESS_BACKGROUND_LOCATION
✅ INTERNET
✅ SEND_SMS
✅ CALL_PHONE
✅ VIBRATE
✅ POST_NOTIFICATIONS
✅ BODY_SENSORS
✅ ACCESS_NETWORK_STATE

Intent Queries:
✅ PROCESS_TEXT
✅ HTTP/HTTPS
✅ CALL
✅ SMS
```

### build.gradle.kts
```
Configuration:
✅ Firebase integration
✅ compileSdkVersion 34
✅ targetSdkVersion 34
✅ minSdkVersion 24
```

### google-services.json
```
📝 TODO: Download from Firebase Console
   ├─ Project ID
   ├─ API keys
   └─ Package name verification
```

---

## 🍎 iOS Configuration (ios/)

### Info.plist
```
Permissions Added:
✅ NSLocationWhenInUseUsageDescription
✅ NSLocationAlwaysAndWhenInUseUsageDescription
✅ NSLocationAlwaysUsageDescription
✅ NSMotionUsageDescription

Background Modes:
✅ location
✅ fetch
```

### Podfile
```
Configuration:
✅ Firebase pods
✅ Flutter pod settings
✅ Platform specifications
```

### GoogleService-Info.plist
```
📝 TODO: Download from Firebase Console
   ├─ App ID
   ├─ API keys
   └─ Bundle ID verification
```

---

## 📊 Data Flow Diagrams

### User Authentication Flow
```
Sign Up/Login Screen
    ↓
Validate Input
    ↓
AuthService.signUp/login()
    ↓
Firebase Authentication
    ↓
Create User Document (Firestore)
    ↓
Dashboard Screen
```

### Accident Detection Flow
```
Sensor Data Stream
    ↓
SensorMonitoringService
    ↓
Calculate Impact Force
    ↓
Compare with Threshold
    ↓
Impact Alert Dialog (10s countdown)
    ↓
Confirm/Cancel
    ↓
Send Emergency Alert / Dismiss
```

### Emergency Response Flow
```
Manual SOS / Impact Confirmed
    ↓
Get Current Location
    ↓
Retrieve Emergency Contacts
    ↓
Send SMS to Each Contact
    ↓
Create Accident Report
    ↓
Store in Firestore
    ↓
Notification to User
```

---

## 🔍 How to Find Things

### By Feature
- **Authentication**: `auth_service.dart`, `login_screen.dart`, `signup_screen.dart`
- **Accident Detection**: `sensor_monitoring_service.dart`, `home_screen.dart`
- **Emergency Alerts**: `notification_service.dart`, `database_service.dart`
- **Location**: `location_service.dart`, `home_screen.dart`
- **Contacts**: `emergency_contacts_screen.dart`, `database_service.dart`
- **History**: `accident_history_screen.dart`, `database_service.dart`

### By Concept
- **Models**: `lib/models/` - All data structures
- **Services**: `lib/services/` - Business logic
- **Screens**: `lib/screens/` - UI/UX
- **Config**: `lib/utils/app_config.dart` - Constants
- **Theme**: `lib/utils/app_theme.dart` - UI styling

### By Technology
- **Firebase**: `auth_service.dart`, `database_service.dart`
- **Sensors**: `sensor_monitoring_service.dart`
- **Location**: `location_service.dart`
- **Notifications**: `notification_service.dart`
- **UI**: All `*_screen.dart` files

---

## 📱 Screen Navigation Map

```
LoginScreen
    ↓
    ├─→ SignupScreen
    └─→ HomeScreen (Dashboard)
            ├─→ EmergencyContactsScreen
            ├─→ AccidentHistoryScreen
            ├─→ SettingsScreen
            │   └─→ Edit Profile Dialog
            ├─→ Help Dialog
            └─→ Accident Confirmation Dialog
                    ├─→ Confirm Alert
                    └─→ Cancel Alert
```

---

## 🎯 Quick Links to Key Functions

### Authentication
- `AuthService.signUp()` - Register new user
- `AuthService.login()` - Login user
- `AuthService.logout()` - Logout and cleanup

### Accident Detection
- `SensorMonitoringService.startMonitoring()` - Begin monitoring
- `SensorMonitoringService._checkImpact()` - Detect impact
- `HomeScreen._handleAccidentDetected()` - Handle detection
- `HomeScreen._sendEmergencyAlert()` - Send alert

### Location
- `LocationService.getCurrentLocation()` - Get position
- `LocationService.getGoogleMapsUrl()` - Generate map link
- `LocationService.getAddressFromCoordinates()` - Reverse geocode

### Communication
- `NotificationService.sendAccidentDetectedNotification()` - Alert notification
- `NotificationService.sendSMS()` - Send SMS alert
- `NotificationService.openMapsUrl()` - Open map

### Data Management
- `DatabaseService.addEmergencyContact()` - Add contact
- `DatabaseService.getEmergencyContacts()` - Get contacts
- `DatabaseService.addAccidentReport()` - Store report
- `DatabaseService.getAccidentReports()` - Retrieve history

---

## 💡 Tips for Navigation

1. **Finding a feature?** → Check `FEATURES_CHECKLIST.md`
2. **Understanding architecture?** → Read `ARCHITECTURE.md`
3. **Need to set up Firebase?** → Follow `SETUP_GUIDE.md`
4. **Quick start?** → Use `QUICK_START.md`
5. **Need to modify something?** → Check source code with comments
6. **Looking for a specific function?** → Use this index

---

## 📞 File Size Reference

```
Largest Files (by lines):
1. home_screen.dart .............. 400+ lines
2. database_service.dart ......... 280+ lines
3. app_theme.dart ............... 300 lines
4. app_config.dart .............. 250 lines
5. settings_screen.dart ......... 250+ lines
6. accident_history_screen.dart .. 200+ lines
7. sensor_monitoring_service.dart  200+ lines
```

---

## ✅ File Organization Checklist

```
✅ All Dart files properly formatted
✅ All documentation complete
✅ All configuration files ready
✅ Models properly designed
✅ Services well-structured
✅ Screens thoroughly implemented
✅ Theme properly configured
✅ Constants properly defined
✅ Comments throughout code
✅ Permissions properly set
```

---

**Start Reading:** [README.md](README.md) or [QUICK_START.md](QUICK_START.md)

**Last Updated:** March 2026  
**Version:** 1.0.0
