import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../models/emergency_contact_model.dart';
import '../models/accident_report_model.dart';

/// Mock data for testing
class MockData {
  /// Generate mock user
  static User generateMockUser({
    String? uid,
    String name = 'John Doe',
    String email = 'john@example.com',
    String phone = '+1234567890',
  }) {
    return User(
      uid: uid ?? 'test_uid_123',
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now(),
      monitoringEnabled: true,
    );
  }

  /// Generate mock emergency contact
  static EmergencyContact generateMockEmergencyContact({
    String? id,
    String? userId,
    String name = 'Emergency Contact',
    String phone = '+1234567890',
    int priority = 1,
  }) {
    return EmergencyContact(
      id: id ?? 'contact_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId ?? 'test_uid_123',
      name: name,
      phone: phone,
      email: 'contact@example.com',
      relationship: 'Friend',
      priority: priority,
      createdAt: DateTime.now(),
    );
  }

  /// Generate mock accident report
  static AccidentReport generateMockAccidentReport({
    String? id,
    String? userId,
    double impactForce = 45.5,
    String severity = 'high',
    String status = 'confirmed',
  }) {
    return AccidentReport(
      id: id ?? 'report_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId ?? 'test_uid_123',
      timestamp: DateTime.now(),
      latitude: 40.7128,
      longitude: -74.0060,
      impactForce: impactForce,
      severity: severity,
      status: status,
      alertSent: true,
      contactsAlerted: ['contact_123', 'contact_456'],
      mapUrl: 'https://maps.google.com/?q=40.7128,-74.0060',
      userNote: 'Test accident report',
    );
  }

  /// Generate mock list of emergency contacts
  static List<EmergencyContact> generateMockContacts({
    int count = 3,
    String? userId,
  }) {
    final List<EmergencyContact> contacts = [];
    for (int i = 1; i <= count; i++) {
      contacts.add(
        generateMockEmergencyContact(
          id: 'contact_$i',
          userId: userId,
          name: 'Contact $i',
          priority: i,
        ),
      );
    }
    return contacts;
  }

  /// Generate mock list of accident reports
  static List<AccidentReport> generateMockReports({
    int count = 5,
    String? userId,
  }) {
    final List<AccidentReport> reports = [];
    final severities = ['low', 'medium', 'high', 'critical'];
    final statuses = ['pending', 'confirmed', 'resolved', 'false_alarm'];

    for (int i = 0; i < count; i++) {
      reports.add(
        generateMockAccidentReport(
          id: 'report_${i + 1}',
          userId: userId,
          impactForce: 20.0 + (i * 10),
          severity: severities[i % severities.length],
          status: statuses[i % statuses.length],
        ),
      );
    }
    return reports;
  }

  /// Generate mock user statistics
  static Map<String, dynamic> generateMockStatistics() {
    return {
      'totalAccidents': 5,
      'confirmedAccidents': 3,
      'resolvedAccidents': 2,
      'falseAlarms': 2,
      'emergencyContactsCount': 3,
      'averageResponseTime': '2.5 mins',
      'lastUpdateTime': DateTime.now(),
    };
  }
}

/// Test data generator for various scenarios
class TestDataGenerator {
  /// Generate test sensor data
  static Map<String, double> generateTestSensorData({
    double accelerationX = 0.0,
    double accelerationY = 0.0,
    double accelerationZ = -10.0,
    double rotationX = 0.0,
    double rotationY = 0.0,
    double rotationZ = 0.0,
  }) {
    return {
      'acceleration_x': accelerationX,
      'acceleration_y': accelerationY,
      'acceleration_z': accelerationZ,
      'rotation_x': rotationX,
      'rotation_y': rotationY,
      'rotation_z': rotationZ,
    };
  }

  /// Generate impact detection test case
  static Map<String, double> generateImpactData({
    double forceMagnitude = 45.0,
  }) {
    // Simulate impact force distribution
    final angle1 = 20.0 * (3.14159 / 180.0);
    final angle2 = 45.0 * (3.14159 / 180.0);

    return {
      'acceleration_x': forceMagnitude * cos(angle1),
      'acceleration_y': forceMagnitude * sin(angle1),
      'acceleration_z': forceMagnitude * cos(angle2),
    };
  }

  /// Generate location test data
  static Map<String, double> generateLocationData({
    double latitude = 40.7128,
    double longitude = -74.0060,
    double accuracy = 10.0,
  }) {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
    };
  }

  /// Generate various severity levels
  static List<Map<String, dynamic>> generateSeverityTestCases() {
    return [
      {'force': 15.0, 'severity': 'low', 'description': 'Minor bump'},
      {'force': 35.0, 'severity': 'medium', 'description': 'Moderate collision'},
      {'force': 45.0, 'severity': 'high', 'description': 'Significant impact'},
      {'force': 60.0, 'severity': 'critical', 'description': 'Severe crash'},
    ];
  }
}

/// Performance test utilities
class PerformanceTester {
  /// Measure function execution time
  static Future<Duration> measureExecutionTime(Future Function() fn) async {
    final startTime = DateTime.now();
    await fn();
    final endTime = DateTime.now();
    return endTime.difference(startTime);
  }

  /// Profile async operation
  static Future<Map<String, dynamic>> profileAsyncOperation(
    String operationName,
    Future Function() fn,
  ) async {
    final startTime = DateTime.now();
    final startMemory = 0; // Would require platform channel

    try {
      await fn();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      return {
        'operation': operationName,
        'duration_ms': duration.inMilliseconds,
        'success': true,
        'error': null,
      };
    } catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      return {
        'operation': operationName,
        'duration_ms': duration.inMilliseconds,
        'success': false,
        'error': e.toString(),
      };
    }
  }
}

/// Test scenario builder
class TestScenario {
  final String name;
  final String description;
  final List<String> steps;
  final Map<String, dynamic> expectedResults;

  TestScenario({
    required this.name,
    required this.description,
    required this.steps,
    required this.expectedResults,
  });

  /// Get scenario summary
  String getSummary() {
    return '''
Test Scenario: $name
Description: $description
Steps: ${steps.length}
Expected Results: ${expectedResults.length} checks
    ''';
  }
}

/// Common test scenarios
final testScenarios = [
  TestScenario(
    name: 'Normal Impact Detection',
    description: 'Test accident detection with normal impact',
    steps: [
      'Enable monitoring',
      'Simulate vehicle impact',
      'Verify impact detection',
      'Confirm alert received',
    ],
    expectedResults: {
      'accidentDetected': true,
      'alertSent': true,
      'contactsNotified': 3,
    },
  ),
  TestScenario(
    name: 'False Alarm Prevention',
    description: 'Test false alarm prevention mechanism',
    steps: [
      'Enable monitoring',
      'Simulate minor bump',
      'Verify impact NOT detected',
      'Confirm no alert sent',
    ],
    expectedResults: {
      'accidentDetected': false,
      'alertSent': false,
      'false_alarm_prevented': true,
    },
  ),
  TestScenario(
    name: 'Emergency Alert Flow',
    description: 'Test emergency alert delivery',
    steps: [
      'Trigger manual SOS',
      'Get current location',
      'Notify all contacts',
      'Open map link',
    ],
    expectedResults: {
      'locationObtained': true,
      'smsSent': true,
      'contactsAlerted': true,
    },
  ),
];
