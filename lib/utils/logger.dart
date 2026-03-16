import 'dart:developer' as developer;

/// Logger utility for debugging and logging
class Logger {
  static const String _tag = '[AccidentDetectionApp]';

  /// Log debug message
  static void debug(String message) {
    developer.log('$_tag [DEBUG] $message', level: 0);
    print('$_tag [DEBUG] $message');
  }

  /// Log info message
  static void info(String message) {
    developer.log('$_tag [INFO] $message', level: 800);
    print('$_tag [INFO] $message');
  }

  /// Log warning message
  static void warning(String message) {
    developer.log('$_tag [WARNING] $message', level: 900);
    print('$_tag [WARNING] $message');
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log('$_tag [ERROR] $message', level: 1000, error: error, stackTrace: stackTrace);
    print('$_tag [ERROR] $message');
    if (error != null) print('Error details: $error');
    if (stackTrace != null) print('Stack trace: $stackTrace');
  }

  /// Log sensor data
  static void logSensorData(String sensorName, Map<String, dynamic> data) {
    debug('$sensorName: $data');
  }

  /// Log location data
  static void logLocationData(double latitude, double longitude, double accuracy) {
    debug('Location - Lat: $latitude, Lng: $longitude, Accuracy: ${accuracy}m');
  }

  /// Log accident detection
  static void logAccidentDetection(double impactForce, String severity) {
    warning('ACCIDENT DETECTED - Force: ${impactForce.toStringAsFixed(2)} m/s², Severity: $severity');
  }

  /// Log emergency alert
  static void logEmergencyAlert(String reason, int contactsNotified) {
    warning('EMERGENCY ALERT - Reason: $reason, Contacts Notified: $contactsNotified');
  }

  /// Log Firebase operation
  static void logFirebaseOperation(String operation, String collection, {bool success = true}) {
    final status = success ? 'SUCCESS' : 'FAILED';
    info('Firestore - $operation on $collection: $status');
  }

  /// Log authentication
  static void logAuthentication(String event, {String? userId, bool success = true}) {
    final status = success ? 'SUCCESS' : 'FAILED';
    final userInfo = userId != null ? ' (User: $userId)' : '';
    info('Auth - $event: $status$userInfo');
  }

  /// Log permission request
  static void logPermissionRequest(String permission, bool granted) {
    final status = granted ? 'GRANTED' : 'DENIED';
    info('Permission - $permission: $status');
  }

  /// Log screen navigation
  static void logScreenNavigation(String screenName) {
    debug('Navigating to: $screenName');
  }

  /// Log general event
  static void logEvent(String event, {Map<String, dynamic>? params}) {
    final paramsStr = params != null ? ' - $params' : '';
    info('Event: $event$paramsStr');
  }
}

/// Error handler utility
class ErrorHandler {
  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    if (error is Exception) {
      final msg = error.toString();

      if (msg.contains('PERMISSION_DENIED')) {
        return 'Permission denied. Please enable required permissions in settings.';
      } else if (msg.contains('LOCATION_SERVICES_DISABLED')) {
        return 'Location services are disabled. Please enable GPS.';
      } else if (msg.contains('NETWORK')) {
        return 'Network error. Please check your internet connection.';
      } else if (msg.contains('TIMEOUT')) {
        return 'Request timeout. Please try again.';
      } else if (msg.contains('FIREBASE')) {
        return 'Server error. Please try again later.';
      } else if (msg.contains('user-not-found')) {
        return 'User not found. Please check your email.';
      } else if (msg.contains('wrong-password')) {
        return 'Incorrect password. Please try again.';
      } else if (msg.contains('email-already-in-use')) {
        return 'Email already in use. Please use a different email.';
      } else if (msg.contains('weak-password')) {
        return 'Password is too weak. Please use a stronger password.';
      } else if (msg.contains('invalid-email')) {
        return 'Invalid email address. Please check and try again.';
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Log and return error
  static String handleError(dynamic error, String context) {
    Logger.error('Error in $context: $error');
    return getUserMessage(error);
  }

  /// Handle Firebase error
  static String handleFirebaseError(dynamic error) {
    Logger.error('Firebase error: $error');
    return getUserMessage(error);
  }

  /// Handle location error
  static String handleLocationError(dynamic error) {
    Logger.error('Location error: $error');
    return getUserMessage(error);
  }

  /// Handle sensor error
  static String handleSensorError(dynamic error) {
    Logger.error('Sensor error: $error');
    return 'Failed to read sensor data. Please check device sensors.';
  }

  /// Handle notification error
  static String handleNotificationError(dynamic error) {
    Logger.error('Notification error: $error');
    return 'Failed to send notification. Please try again.';
  }
}
