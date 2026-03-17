import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/emergency_contact_model.dart';
import '../models/accident_report_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== User Profile ==========

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      throw 'Error getting user profile: $e';
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(data, SetOptions(merge: true));
    } catch (e) {
      throw 'Error updating user profile: $e';
    }
  }

  // ========== Emergency Contacts ==========

  // Add emergency contact
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    try {
      await _firestore
          .collection('users')
          .doc(contact.userId)
          .collection('emergency_contacts')
          .doc(contact.id)
          .set(contact.toMap());
    } catch (e) {
      throw 'Error adding emergency contact: $e';
    }
  }

  // Get emergency contacts
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_contacts')
          .orderBy('priority', descending: false)
          .get();

      return snapshot.docs.map((doc) => EmergencyContact.fromMap(doc.data())).toList();
    } catch (e) {
      throw 'Error getting emergency contacts: $e';
    }
  }

  // Update emergency contact
  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    try {
      await _firestore
          .collection('users')
          .doc(contact.userId)
          .collection('emergency_contacts')
          .doc(contact.id)
          .update(contact.toMap());
    } catch (e) {
      throw 'Error updating emergency contact: $e';
    }
  }

  // Delete emergency contact
  Future<void> deleteEmergencyContact(String userId, String contactId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_contacts')
          .doc(contactId)
          .delete();
    } catch (e) {
      throw 'Error deleting emergency contact: $e';
    }
  }

  // ========== Accident Reports ==========

  // Add accident report
  Future<void> addAccidentReport(AccidentReport report) async {
    try {
      await _firestore
          .collection('users')
          .doc(report.userId)
          .collection('accident_reports')
          .doc(report.id)
          .set(report.toMap());

      // Also add to global reports collection for analytics
      await _firestore.collection('all_accident_reports').doc(report.id).set(report.toMap());
    } catch (e) {
      throw 'Error adding accident report: $e';
    }
  }

  // Get accident reports
  Future<List<AccidentReport>> getAccidentReports(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('accident_reports')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => AccidentReport.fromMap(doc.data())).toList();
    } catch (e) {
      throw 'Error getting accident reports: $e';
    }
  }

  // Get accident report by ID
  Future<AccidentReport?> getAccidentReport(String userId, String reportId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('accident_reports')
          .doc(reportId)
          .get();

      if (doc.exists) {
        return AccidentReport.fromMap(doc.data()!);
      }
    } catch (e) {
      throw 'Error getting accident report: $e';
    }
    return null;
  }

  // Update accident report
  Future<void> updateAccidentReport(AccidentReport report) async {
    try {
      await _firestore
          .collection('users')
          .doc(report.userId)
          .collection('accident_reports')
          .doc(report.id)
          .update(report.toMap());

      await _firestore
          .collection('all_accident_reports')
          .doc(report.id)
          .update(report.toMap());
    } catch (e) {
      throw 'Error updating accident report: $e';
    }
  }

  // Delete accident report
  Future<void> deleteAccidentReport(String userId, String reportId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('accident_reports')
          .doc(reportId)
          .delete();

      await _firestore.collection('all_accident_reports').doc(reportId).delete();
    } catch (e) {
      throw 'Error deleting accident report: $e';
    }
  }

  // Get stream of accident reports
  Stream<List<AccidentReport>> getAccidentReportsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accident_reports')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AccidentReport.fromMap(doc.data())).toList();
    });
  }

  // Get statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final reports = await getAccidentReports(userId);
      
      final confirmed = reports.where((r) => r.status == 'confirmed').length;
      final resolved = reports.where((r) => r.status == 'resolved').length;
      final falseAlarms = reports.where((r) => r.status == 'false_alarm').length;

      return {
        'totalReports': reports.length,
        'confirmedAccidents': confirmed,
        'resolvedAccidents': resolved,
        'falseAlarms': falseAlarms,
        'lastIncident': reports.isNotEmpty ? reports.first.timestamp : null,
      };
    } catch (e) {
      throw 'Error getting statistics: $e';
    }
  }
}
