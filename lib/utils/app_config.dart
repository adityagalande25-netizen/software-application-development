class AppConfig {
  // App Info
  static const String appName = 'Accident Detection System';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Sensor Configuration
  static const double impactThresholdDefault = 25.0;
  static const double impactThresholdMin = 10.0;
  static const double impactThresholdMax = 50.0;
  static const int sensorDataBufferSize = 100;
  static const int recordFrequencyMs = 100;

  // Accident Detection
  static const int accidentConfirmationDelaySeconds = 10;
  static const double severityCriticalThreshold = 50.0;
  static const double severityHighThreshold = 40.0;
  static const double severityMediumThreshold = 30.0;
  static const Duration impactDebounceTime = Duration(milliseconds: 500);

  // GPS Configuration
  static const double locationUpdateDistanceFilter = 10.0; // meters
  static const int locationTimeoutSeconds = 10;

  // UI Configuration
  static const int primaryAnimationDuration = 500; // milliseconds
  static const int transitionDuration = 300; // milliseconds

  // Database Configuration
  static const String firestoreUsersCollection = 'users';
  static const String firestoreContactsCollection = 'emergency_contacts';
  static const String firestoreReportsCollection = 'accident_reports';

  // Error Messages
  static const String errorLocationNotAvailable = 'Unable to get current location';
  static const String errorSensorNotAvailable = 'Sensor data not available';
  static const String errorNetworkConnection = 'Network connection failed';
  static const String errorAuthenticationFailed = 'Authentication failed';
  static const String errorDatabaseOperation = 'Database operation failed';

  // Success Messages
  static const String successContactAdded = 'Emergency contact added successfully';
  static const String successContactUpdated = 'Emergency contact updated successfully';
  static const String successContactDeleted = 'Emergency contact deleted successfully';
  static const String successAlertSent = 'Emergency alert sent to all contacts';
  static const String successProfileUpdated = 'Profile updated successfully';

  // Validation
  static const int minPasswordLength = 6;
  static const int minPhoneLength = 10;
  static const int maxNameLength = 100;
  static const int maxContactsPerUser = 20;

  // Firebase Cloud Messaging
  static const String fcmTopicEmergencyAlerts = 'accident_alerts';
  static const String fcmTopicNotifications = 'general_notifications';

  // Notification Configuration
  static const int notificationAccidentAlertId = 1;
  static const int notificationEmergencyAlertId = 2;
  static const int notificationGeneralId = 999;

  // API Endpoints (Firebase)
  static const String firestoreEmulator = 'localhost:8080';
  static const bool useFirestoreEmulator = false;

  // Analytics
  static const bool enableAnalytics = true;
  static const String analyticsEventAccidentDetected = 'accident_detected';
  static const String analyticsEventAlertSent = 'alert_sent';
  static const String analyticsEventContactAdded = 'contact_added';

  // Contact Priority Levels
  static const Map<int, String> priorityLevels = {
    1: 'Highest',
    2: 'High',
    3: 'Medium',
    4: 'Low',
    5: 'Lowest',
  };

  // Accident Severity Levels
  static const List<String> severityLevels = ['low', 'medium', 'high', 'critical'];

  // Accident Status
  static const List<String> accidentStatus = ['detected', 'confirmed', 'resolved', 'false_alarm'];

  // Color Codes
  static const String colorPrimary = '#E53935';
  static const String colorSuccess = '#43A047';
  static const String colorWarning = '#FB8C00';
  static const String colorDanger = '#E53935';
  static const String colorInfo = '#1E88E5';
}

class AppStrings {
  // Welcome & Auth
  static const String welcomeTitle = 'Accident Detection System';
  static const String welcomeSubtitle = 'Real-time Safety & Emergency Response';
  static const String loginTitle = 'Login';
  static const String signupTitle = 'Sign Up';
  static const String logout = 'Logout';
  static const String profileSettings = 'Profile Settings';

  // Monitoring
  static const String monitoringActive = 'Monitoring Active';
  static const String monitoringInactive = 'Monitoring Inactive';
  static const String monitoringEnabledText = 'Real-time sensor monitoring enabled';
  static const String monitoringDisabledText = 'Click START to enable monitoring';
  static const String manualSos = 'MANUAL SOS';
  static const String sosConfirmation = 'Send emergency alert to all emergency contacts?';

  // Accident Detection
  static const String accidentDetected = 'ACCIDENT DETECTED!';
  static const String confirmationCountdown = 'Sending alert in';
  static const String sendAlert = 'Send Alert';
  static const String cancelAlert = 'Cancel';
  static const String impactForce = 'Impact Force';
  static const String accidentConfirmed = 'Accident confirmed and reported';

  // Navigation
  static const String emergencyContacts = 'Emergency Contacts';
  static const String accidentHistory = 'Accident History';
  static const String settings = 'Settings';
  static const String helpInfo = 'Help & Info';
  static const String about = 'About This App';

  // Forms
  static const String nameLabel = 'Name';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String phoneLabel = 'Phone Number';
  static const String relationshipLabel = 'Relationship';
  static const String priorityLabel = 'Priority';

  // Buttons
  static const String addButton = 'Add';
  static const String editButton = 'Edit';
  static const String deleteButton = 'Delete';
  static const String saveButton = 'Save';
  static const String confirmButton = 'Confirm';
  static const String cancelButton = 'Cancel';
  static const String submitButton = 'Submit';
  static const String closeButton = 'Close';

  // Validation
  static const String errorNameRequired = 'Name is required';
  static const String errorEmailRequired = 'Email is required';
  static const String errorEmailInvalid = 'Enter a valid email';
  static const String errorPasswordRequired = 'Password is required';
  static const String errorPasswordTooShort = 'Password must be at least 6 characters';
  static const String errorPasswordMismatch = 'Passwords do not match';
  static const String errorPhoneRequired = 'Phone number is required';
  static const String errorPhoneInvalid = 'Enter a valid phone number';

  // Messages
  static const String noContactsAdded = 'No emergency contacts added yet';
  static const String noAccidentReports = 'No accident reports recorded';
  static const String staySecure = 'Stay safe out there!';
  static const String loadingPlease = 'Loading...';
  static const String processingRequest = 'Processing your request...';
}
