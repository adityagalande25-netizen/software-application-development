import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFC62828);
  static const Color primaryLight = Color(0xFFEF5350);

  // Secondary colors
  static const Color secondary = Color(0xFF1E88E5);
  static const Color secondaryDark = Color(0xFF1565C0);
  static const Color secondaryLight = Color(0xFF42A5F5);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color greyLight = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF424242);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Severity colors
  static const Color severityCritical = Color(0xFFE53935);
  static const Color severityHigh = Color(0xFFFF6F00);
  static const Color severityMedium = Color(0xFFFFC107);
  static const Color severityLow = Color(0xFF4CAF50);

  // Gradient colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Overlay colors
  static const Color overlay30 = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color overlay50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color overlay70 = Color.fromRGBO(0, 0, 0, 0.7);
}

/// App string constants
class AppStrings {
  // App name and general
  static const String appName = 'Accident Detection';
  static const String appVersion = '1.0.0';

  // Authentication
  static const String loginTitle = 'Welcome Back';
  static const String loginEmail = 'Email';
  static const String loginPassword = 'Password';
  static const String loginButton = 'Login';
  static const String signupTitle = 'Create Account';
  static const String signupName = 'Full Name';
  static const String signupPhone = 'Phone Number';
  static const String signupConfirmPassword = 'Confirm Password';
  static const String signupButton = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String haveAccount = 'Already have an account?';
  static const String noAccount = 'Don\'t have an account?';

  // Navigation
  static const String home = 'Home';
  static const String contacts = 'Contacts';
  static const String history = 'History';
  static const String settings = 'Settings';

  // Dashboard
  static const String monitoringOn = 'Monitoring ON';
  static const String monitoringOff = 'Monitoring OFF';
  static const String sosButton = 'SOS';
  static const String sosDescription = 'Tap to send emergency alert';
  static const String acceleration = 'Acceleration';
  static const String rotation = 'Rotation';

  // Emergency contacts
  static const String addContact = 'Add Emergency Contact';
  static const String editContact = 'Edit Contact';
  static const String deleteContact = 'Delete Contact';
  static const String contactName = 'Contact Name';
  static const String contactPhone = 'Phone Number';
  static const String contactEmail = 'Email (Optional)';
  static const String contactRelationship = 'Relationship';
  static const String contactPriority = 'Priority (1-5)';
  static const String noContacts = 'No emergency contacts added';
  static const String noContactsDescription = 'Add your first emergency contact to get started';

  // Accident history
  static const String accidentHistory = 'Accident History';
  static const String noHistory = 'No accident records';
  static const String noHistoryDescription = 'Your accident records will appear here';
  static const String impactForce = 'Impact Force';
  static const String severity = 'Severity';
  static const String status = 'Status';
  static const String location = 'Location';
  static const String timestamp = 'Date & Time';
  static const String viewOnMap = 'View on Map';

  // Settings
  static const String userProfile = 'User Profile';
  static const String notifications = 'Notifications';
  static const String sensorSettings = 'Sensor Settings';
  static const String about = 'About';
  static const String logout = 'Logout';
  static const String enableNotifications = 'Enable Notifications';
  static const String enableSmsAlerts = 'Enable SMS Alerts';
  static const String impactThreshold = 'Impact Threshold';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';

  // Status messages
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String close = 'Close';

  // Error messages
  static const String errorLoadingData = 'Error loading data';
  static const String errorSavingData = 'Error saving data';
  static const String errorDeletingData = 'Error deleting data';
  static const String errorNetwork = 'Network error';
  static const String errorUnexpected = 'An unexpected error occurred';

  // Success messages
  static const String successSaved = 'Saved successfully';
  static const String successDeleted = 'Deleted successfully';
  static const String successUpdated = 'Updated successfully';
  static const String successLogin = 'Login successful';
  static const String successSignup = 'Account created successfully';
  static const String successLogout = 'Logged out successfully';

  // Accident detection
  static const String accidentDetected = 'ACCIDENT DETECTED';
  static const String accidentConfirming = 'Confirming accident...';
  static const String accidentConfirmed = 'Accident confirmed';
  static const String accidentDismissed = 'Alert dismissed';
  static const String alertingSent = 'Emergency alerts sent';
  static const String contactAlert = 'has been alerted about your accident';

  // Permissions
  static const String locationPermissionRequired = 'Location permission is required';
  static const String sensorPermissionRequired = 'Sensor permission is required';
  static const String notificationPermissionRequired = 'Notification permission is required';
}

/// Route constants
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String contacts = '/contacts';
  static const String history = '/history';
  static const String settings = '/settings';
}

/// Duration constants
class AppDurations {
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 1000);
  static const Duration debounce = Duration(milliseconds: 500);
  static const Duration throttle = Duration(milliseconds: 1000);
}

/// Size constants
class AppSizes {
  // Padding
  static const double paddingXSmall = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;

  // Border radius
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  // Icon sizes
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 48;
  static const double iconXLarge = 64;

  // Font sizes
  static const double fontSmall = 12;
  static const double fontMedium = 14;
  static const double fontLarge = 16;
  static const double fontXLarge = 20;
  static const double fontSize2XLarge = 24;

  // Button sizes
  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 40;
  static const double buttonHeightLarge = 56;

  // Input field height
  static const double inputFieldHeight = 56;
}

/// Animation constants
class AppAnimations {
  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeInOut;
  static const Curve bounceInCurve = Curves.bounceIn;
  static const Curve bounceOutCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;
}

/// Number constants
class AppNumbers {
  // API
  static const int apiTimeout = 30000; // milliseconds

  // Sensor
  static const double impactThresholdDefault = 25.0;
  static const double impactThresholdMin = 10.0;
  static const double impactThresholdMax = 50.0;
  static const double severityLowThreshold = 30.0;
  static const double severityMediumThreshold = 40.0;
  static const double severityHighThreshold = 50.0;

  // Timer
  static const int confirmationSeconds = 10;
  static const int gpsTimeoutSeconds = 10;

  // Validation
  static const int minPasswordLength = 6;
  static const int minPhoneLength = 10;
  static const int maxContactsPerUser = 20;
  static const int maxReportsPerUser = 1000;
}

/// Regex patterns
class AppPatterns {
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phonePattern = RegExp(r'^[0-9]{10,15}$');

  static final RegExp namePattern = RegExp(r'^[a-zA-Z\s]{2,}$');

  static final RegExp passwordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$',
  );
}
