class AccidentReport {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double impactForce;
  final String severity; // low, medium, high, critical
  final bool alertSent;
  final List<String> contactsAlerted;
  final String? mapUrl;
  final String status; // detected, confirmed, resolved, false_alarm
  final String? userNote;

  AccidentReport({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.impactForce,
    required this.severity,
    required this.alertSent,
    required this.contactsAlerted,
    this.mapUrl,
    required this.status,
    this.userNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'impactForce': impactForce,
      'severity': severity,
      'alertSent': alertSent,
      'contactsAlerted': contactsAlerted,
      'mapUrl': mapUrl,
      'status': status,
      'userNote': userNote,
    };
  }

  factory AccidentReport.fromMap(Map<String, dynamic> map) {
    return AccidentReport(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      impactForce: (map['impactForce'] ?? 0.0).toDouble(),
      severity: map['severity'] ?? 'medium',
      alertSent: map['alertSent'] ?? false,
      contactsAlerted: List<String>.from(map['contactsAlerted'] ?? []),
      mapUrl: map['mapUrl'],
      status: map['status'] ?? 'detected',
      userNote: map['userNote'],
    );
  }

  AccidentReport copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? impactForce,
    String? severity,
    bool? alertSent,
    List<String>? contactsAlerted,
    String? mapUrl,
    String? status,
    String? userNote,
  }) {
    return AccidentReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      impactForce: impactForce ?? this.impactForce,
      severity: severity ?? this.severity,
      alertSent: alertSent ?? this.alertSent,
      contactsAlerted: contactsAlerted ?? this.contactsAlerted,
      mapUrl: mapUrl ?? this.mapUrl,
      status: status ?? this.status,
      userNote: userNote ?? this.userNote,
    );
  }
}
