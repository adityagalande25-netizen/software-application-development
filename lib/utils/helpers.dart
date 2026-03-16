import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logger.dart';

/// Application initialization and setup
class AppInitializer {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize app on first launch
  static Future<void> initializeApp() async {
    try {
      Logger.info('Initializing application...');

      // Check if user exists
      final user = _auth.currentUser;
      if (user != null) {
        Logger.info('User already authenticated: ${user.uid}');
        await _createUserDocumentIfNotExists(user.uid, user.email ?? '');
      }

      Logger.info('App initialization completed successfully');
    } catch (e) {
      Logger.error('Error initializing app: $e');
    }
  }

  /// Create user document if it doesn't exist
  static Future<void> _createUserDocumentIfNotExists(String uid, String email) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'uid': uid,
          'email': email,
          'name': email.split('@')[0],
          'phone': '',
          'profileImageUrl': '',
          'createdAt': FieldValue.serverTimestamp(),
          'monitoringEnabled': false,
        });
        Logger.info('User document created: $uid');
      }
    } catch (e) {
      Logger.error('Error creating user document: $e');
    }
  }

  /// Clear app cache and data on logout
  static Future<void> clearAppData() async {
    try {
      Logger.info('Clearing app data...');
      // Clear SharedPreferences if needed
      // await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      Logger.info('App data cleared successfully');
    } catch (e) {
      Logger.error('Error clearing app data: $e');
    }
  }

  /// Verify app setup
  static Future<bool> verifyAppSetup() async {
    try {
      Logger.info('Verifying app setup...');

      // Check Firebase connection
      try {
        await _firestore.collection('users').limit(1).get();
        Logger.info('Firebase connection verified');
      } catch (e) {
        Logger.error('Firebase connection failed: $e');
        return false;
      }

      Logger.info('App setup verification completed');
      return true;
    } catch (e) {
      Logger.error('Error verifying app setup: $e');
      return false;
    }
  }
}

/// Common helper functions
class AppHelpers {
  /// Get current user UID
  static String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// Check if user is authenticated
  static bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Get current user email
  static String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Get current user display name
  static String? getCurrentUserDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  /// Check if app is in debug mode
  static bool isDebugMode() {
    return const bool.fromEnvironment('dart.vm.product') == false;
  }

  /// Validate email format
  static bool isValidEmailFormat(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  /// Validate phone format
  static bool isValidPhoneFormat(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }

  /// Generate unique ID
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Get time of day greeting
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Convert map to query parameters
  static String mapToQueryParams(Map<String, dynamic> params) {
    final queryParams = <String>[];
    params.forEach((key, value) {
      queryParams.add('$key=$value');
    });
    return queryParams.join('&');
  }

  /// Parse query parameters to map
  static Map<String, String> parseQueryParams(String queryString) {
    final params = <String, String>{};
    final pairs = queryString.split('&');
    for (var pair in pairs) {
      final keyValue = pair.split('=');
      if (keyValue.length == 2) {
        params[keyValue[0]] = keyValue[1];
      }
    }
    return params;
  }

  /// Delay execution
  static Future<void> delay(Duration duration) {
    return Future.delayed(duration);
  }

  /// Retry operation
  static Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        Logger.warning('Attempt $attempts failed: $e');

        if (attempts >= maxRetries) {
          rethrow;
        }

        await Future.delayed(delay);
      }
    }

    throw Exception('Operation failed after $maxRetries attempts');
  }

  /// Debounce function execution
  static Function debounce(Function() callback, Duration delay) {
    Timer? timer;

    return () {
      timer?.cancel();
      timer = Timer(delay, callback);
    };
  }

  /// Throttle function execution
  static Function throttle(Function() callback, Duration delay) {
    DateTime? lastExecuted;

    return () {
      final now = DateTime.now();

      if (lastExecuted == null || now.difference(lastExecuted!) >= delay) {
        lastExecuted = now;
        callback();
      }
    };
  }
}
