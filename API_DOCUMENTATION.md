# API & Data Schema Documentation

## Firestore Database Schema

### Collection: `users`

**Description**: Stores user account information and profile settings

**Document ID**: `{uid}` - Firebase Authentication UID

**Fields**:
```dart
{
  uid: String,                    // User's unique Firebase ID
  name: String,                   // User's full name
  email: String,                  // User's email address
  phone: String,                  // User's phone number
  profileImageUrl: String?,       // URL to profile picture (optional)
  createdAt: Timestamp,           // Account creation timestamp
  monitoringEnabled: Boolean,     // Whether accident monitoring is active
}
```

**Subcollections**:
- `emergency_contacts` - User's emergency contact list
- `accident_reports` - User's accident history

**Security Rules**:
```
match /users/{userId} {
  allow read: if request.auth.uid == userId;
  allow write: if request.auth.uid == userId;
  allow delete: if request.auth.uid == userId;
}
```

**Example Document**:
```json
{
  "uid": "Ai2lJeW1Mn3K4pQ5rT6u",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "phone": "+1-234-567-8900",
  "profileImageUrl": "https://storage.googleapis.com/accident-detection/profiles/john.jpg",
  "createdAt": "2024-01-15T10:30:00Z",
  "monitoringEnabled": true
}
```

---

### Subcollection: `users/{userId}/emergency_contacts`

**Description**: Emergency contacts for a specific user

**Document ID**: Auto-generated UUID

**Fields**:
```dart
{
  id: String,                     // Document ID (same as key)
  userId: String,                 // Parent user's ID
  name: String,                   // Contact's name
  phone: String,                  // Contact's phone number
  email: String?,                 // Contact's email (optional)
  relationship: String,           // Relation to user (friend, family, etc.)
  priority: Integer,              // Priority level (1-5, 1 = highest)
  createdAt: Timestamp,           // When contact was added
}
```

**Security Rules**:
```
match /users/{userId}/emergency_contacts/{contactId} {
  allow read, write: if request.auth.uid == userId;
  allow delete: if request.auth.uid == userId;
}
```

**Example Document**:
```json
{
  "id": "e47a2f5c-1b3d-4e8f-a9b2-c1d4e5f6g7h8",
  "userId": "Ai2lJeW1Mn3K4pQ5rT6u",
  "name": "Jane Doe",
  "phone": "+1-555-123-4567",
  "email": "jane.doe@example.com",
  "relationship": "Sister",
  "priority": 1,
  "createdAt": "2024-01-20T14:22:00Z"
}
```

---

### Subcollection: `users/{userId}/accident_reports`

**Description**: Accident incidents detected for a specific user

**Document ID**: Auto-generated UUID

**Fields**:
```dart
{
  id: String,                     // Document ID (same as key)
  userId: String,                 // User who experienced accident
  timestamp: Timestamp,           // When accident occurred
  latitude: Double,               // GPS latitude
  longitude: Double,              // GPS longitude
  impactForce: Double,            // Impact force in m/s²
  severity: String,               // Level: low, medium, high, critical
  status: String,                 // pending, confirmed, resolved, false_alarm
  alertSent: Boolean,             // Whether emergency alert was sent
  contactsAlerted: Array,         // IDs of contacts notified
  mapUrl: String?,                // Google Maps URL to location
  userNote: String?,              // User's additional notes
}
```

**Security Rules**:
```
match /users/{userId}/accident_reports/{reportId} {
  allow read, write: if request.auth.uid == userId;
  allow delete: if request.auth.uid == userId;
}
```

**Example Document**:
```json
{
  "id": "r12b4c5d-6e7f-8g9h-0i1j-2k3l4m5n6o7p",
  "userId": "Ai2lJeW1Mn3K4pQ5rT6u",
  "timestamp": "2024-01-25T16:45:30Z",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "impactForce": 45.8,
  "severity": "high",
  "status": "confirmed",
  "alertSent": true,
  "contactsAlerted": ["e47a2f5c-1b3d-4e8f-a9b2-c1d4e5f6g7h8"],
  "mapUrl": "https://maps.google.com/?q=40.7128,-74.0060",
  "userNote": "Rear-end collision at traffic light"
}
```

---

### Collection: `all_accident_reports`

**Description**: Global collection of all accidents (for analytics)

**Document ID**: Auto-generated UUID

**Fields**: Same as accident_reports, plus:
```dart
{
  region: String?,                // Geographic region
  road_type: String?,             // Highway, city, etc.
  weather: String?,               // Weather conditions
  visibility: String?,            // Visibility at time
}
```

**Purpose**: Analytics, research, heatmaps

---

## Service APIs

### AuthService

```dart
// Sign up new user
Future<User?> signUp({
  required String name,
  required String email,
  required String password,
  required String phone,
}) → Creates Firebase user + Firestore document

// Sign in existing user
Future<User?> login({
  required String email,
  required String password,
}) → Returns Firebase user or throws exception

// Get user profile
Future<User?> getUserProfile(String uid) → Returns user model

// Update user profile
Future<void> updateUserProfile({
  required String uid,
  required String name,
  required String phone,
}) → Updates Firestore document

// Toggle monitoring
Future<void> toggleMonitoring(String uid, bool enabled)
  → Updates monitoringEnabled field

// Sign out
Future<void> logout() → Signs out current user

// Password reset
Future<void> resetPassword(String email) → Sends reset email

// Get auth state stream
Stream<User?> get authStateChanges → Listens to auth changes
```

---

### SensorMonitoringService

```dart
// Start monitoring sensors
Future<void> startMonitoring() → Begins accelerometer polling

// Stop monitoring
Future<void> stopMonitoring() → Ends sensor polling

// Get current sensor readings
Map<String, double> getCurrentReadings() → Latest sensor values

// Get average impact force
double getAverageImpactForce() → Average over buffer

// Get peak impact force
double getPeakImpactForce() → Maximum force recorded

// Check if likely accident
bool isLikelyAccident(double force) → Comparison against threshold

// Callbacks
void Function(double)? onImpactDetected
void Function(Map)? onSensorDataChanged
void Function(String)? onError
```

---

### LocationService

```dart
// Request location permission
Future<bool> requestLocationPermission() → Prompts user

// Check if location enabled
Future<bool> isLocationServiceEnabled() → Checks GPS status

// Get current location
Future<{latitude, longitude, accuracy}?> getCurrentLocation()
  → Gets current position (10s timeout)

// Get location stream
Stream<{latitude, longitude, accuracy}> getLocationStream()
  → Continuous location updates

// Calculate distance
double calculateDistance(lat1, lng1, lat2, lng2) → Distance in meters

// Get Google Maps URL
String getGoogleMapsUrl(double latitude, double longitude)
  → URL for embedded maps

// Get address from coordinates
Future<String> getAddressFromCoordinates(lat, lng) → Reverse geocoding

// Get coordinates from address
Future<{latitude, longitude}> getCoordinatesFromAddress(address)
  → Forward geocoding

// Format location display
String formatLocationDisplay(latitude, longitude) → Human readable
```

---

### DatabaseService

#### Emergency Contacts

```dart
// Add new contact
Future<String> addEmergencyContact(EmergencyContact contact) → Returns ID

// Get all contacts
Future<List<EmergencyContact>> getEmergencyContacts(String uid)
  → Returns sorted by priority

// Update contact
Future<void> updateEmergencyContact(String uid, String contactId, Map data)

// Delete contact
Future<void> deleteEmergencyContact(String uid, String contactId)

// Real-time updates
Stream<List<EmergencyContact>> getEmergencyContactsStream(String uid)
```

#### Accident Reports

```dart
// Add new report
Future<String> addAccidentReport(AccidentReport report) → Returns ID

// Get all reports
Future<List<AccidentReport>> getAccidentReports(String uid)
  → Returns newest first

// Get single report
Future<AccidentReport?> getAccidentReport(String uid, String reportId)

// Update report status
Future<void> updateAccidentReport(String uid, String reportId, String status)

// Delete report
Future<void> deleteAccidentReport(String uid, String reportId)

// Real-time updates
Stream<List<AccidentReport>> getAccidentReportsStream(String uid)

// Get user statistics
Future<{total, confirmed, resolved, false_alarms}> getUserStatistics(uid)
```

---

### NotificationService

```dart
// Initialize notification system
Future<void> initializeNotifications() → Setup channels

// Send accident alert
Future<void> sendAccidentDetectedNotification({
  required String title,
  required String body,
  required String latitude,
  required String longitude,
  required String mapUrl,
}) → High priority alert

// Send emergency alert
Future<void> sendEmergencyAlert({
  required String contactName,
  required String message,
  required String mapUrl,
})

// Send general notification
Future<void> sendGeneralNotification({
  required String title,
  required String body,
})

// Call emergency number
Future<void> callEmergency(String phoneNumber) → Dials tel: URL

// Send SMS
Future<void> sendSMS(String phoneNumber, String message) → Sends sms: URL

// Open maps
Future<void> openMapsUrl(String mapUrl) → Launches Google Maps

// Cancel notification
Future<void> cancelNotification(int id)

// Cancel all
Future<void> cancelAllNotifications()
```

---

## Data Models

### User Model
```dart
User(
  uid: String,
  name: String,
  email: String,
  phone: String,
  profileImageUrl: String?,
  createdAt: DateTime,
  monitoringEnabled: bool,
)

// Methods
Map<String, dynamic> toMap()
User.fromMap(Map<String, dynamic> map)
User copyWith({...})
```

### EmergencyContact Model
```dart
EmergencyContact(
  id: String,
  userId: String,
  name: String,
  phone: String,
  email: String?,
  relationship: String,
  priority: int,      // 1-5 (1 = highest)
  createdAt: DateTime,
)

// Methods
Map<String, dynamic> toMap()
EmergencyContact.fromMap(Map<String, dynamic> map)
EmergencyContact copyWith({...})
```

### AccidentReport Model
```dart
AccidentReport(
  id: String,
  userId: String,
  timestamp: DateTime,
  latitude: double,
  longitude: double,
  impactForce: double,
  severity: String,   // low, medium, high, critical
  status: String,     // pending, confirmed, resolved, false_alarm
  alertSent: bool,
  contactsAlerted: List<String>,
  mapUrl: String?,
  userNote: String?,
)

// Methods
Map<String, dynamic> toMap()
AccidentReport.fromMap(Map<String, dynamic> map)
AccidentReport copyWith({...})
```

---

## REST API Integration (Future)

Placeholder for future REST API endpoints:

```
POST   /api/accidents/report        - Create accident report
GET    /api/accidents/{id}           - Get report details
PUT    /api/accidents/{id}           - Update report
DELETE /api/accidents/{id}           - Delete report

GET    /api/contacts                 - List emergency contacts
POST   /api/contacts                 - Add new contact
PUT    /api/contacts/{id}            - Update contact
DELETE /api/contacts/{id}            - Delete contact

GET    /api/stats                    - Get user statistics
POST   /api/alert/send               - Send manual alert
```

---

## WebSocket Events (Future)

Real-time event streaming:

```
emergency:alert        - Emergency alert sent
accident:detected      - Accident detected
location:updated       - Location changed
contact:added          - New contact added
report:created         - New report created
monitoring:toggled     - Monitoring status changed
```

---

## Error Codes

### Authentication Errors
- `AUTH_001`: Invalid email format
- `AUTH_002`: Weak password
- `AUTH_003`: Email already exists
- `AUTH_004`: User not found
- `AUTH_005`: Wrong password
- `AUTH_006`: User disabled

### Database Errors
- `DB_001`: Collection not found
- `DB_002`: Document not found
- `DB_003`: Write failed
- `DB_004`: Read failed
- `DB_005`: Permission denied
- `DB_006`: Query invalid

### Sensor Errors
- `SENSOR_001`: Sensors not available
- `SENSOR_002`: Permission denied
- `SENSOR_003`: Device not supported

### Location Errors
- `LOC_001`: Location service disabled
- `LOC_002`: Permission denied
- `LOC_003`: Timeout getting location
- `LOC_004`: Invalid coordinates

---

## Rate Limits

**Firebase Free Tier**:
- Reads: 50,000 per day
- Writes: 20,000 per day
- Deletes: 20,000 per day

**Recommendations**:
- Cache email verification tokens
- Batch database writes
- Use indexes for queries
- Limit location updates

---

## Versioning

Current API Version: **v1.0.0**

Changelog:
- v1.0.0: Initial release
  - User authentication
  - Accident detection
  - Emergency contacts
  - Real-time alerts
