import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class SensorMonitoringService {
  final double impactThreshold; // m/s²
  final Duration debounceTime;

  late StreamSubscription _accelerometerSubscription;
  late StreamSubscription _gyroscopeSubscription;

  double _lastX = 0, _lastY = 0, _lastZ = 0;
  double _lastGyroX = 0, _lastGyroY = 0, _lastGyroZ = 0;
  DateTime? _lastImpactTime;

  List<double> _accelerometerBuffer = [];
  List<double> _gyroscopeBuffer = [];

  Function(double)? onImpactDetected;
  Function(Map<String, dynamic>)? onSensorDataChanged;

  SensorMonitoringService({
    this.impactThreshold = 25.0,
    this.debounceTime = const Duration(milliseconds: 500),
    this.onImpactDetected,
    this.onSensorDataChanged,
  });

  // Start monitoring sensors
  void startMonitoring() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;

      // Calculate impact force: √(x² + y² + z²)
      double impactForce = sqrt((_lastX * _lastX) + (_lastY * _lastY) + (_lastZ * _lastZ));

      _accelerometerBuffer.add(impactForce);
      if (_accelerometerBuffer.length > 100) {
        _accelerometerBuffer.removeAt(0);
      }

      // Check for impact
      if (impactForce > impactThreshold) {
        _checkImpact(impactForce);
      }

      _notifySensorData();
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      _lastGyroX = event.x;
      _lastGyroY = event.y;
      _lastGyroZ = event.z;

      _gyroscopeBuffer.add(sqrt((event.x * event.x) + (event.y * event.y) + (event.z * event.z)));
      if (_gyroscopeBuffer.length > 100) {
        _gyroscopeBuffer.removeAt(0);
      }

      _notifySensorData();
    });
  }

  // Stop monitoring sensors
  void stopMonitoring() {
    _accelerometerSubscription.cancel();
    _gyroscopeSubscription.cancel();
  }

  // Check if impact is genuine accident
  void _checkImpact(double impactForce) {
    final now = DateTime.now();
    if (_lastImpactTime == null || now.difference(_lastImpactTime!) > debounceTime) {
      _lastImpactTime = now;
      onImpactDetected?.call(impactForce);
    }
  }

  // Notify sensor data change
  void _notifySensorData() {
    onSensorDataChanged?.call({
      'accelerometer': {
        'x': _lastX,
        'y': _lastY,
        'z': _lastZ,
        'magnitude': sqrt((_lastX * _lastX) + (_lastY * _lastY) + (_lastZ * _lastZ)),
      },
      'gyroscope': {
        'x': _lastGyroX,
        'y': _lastGyroY,
        'z': _lastGyroZ,
        'magnitude': sqrt((_lastGyroX * _lastGyroX) + (_lastGyroY * _lastGyroY) + (_lastGyroZ * _lastGyroZ)),
      },
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get current sensor readings
  Map<String, dynamic> getCurrentReadings() {
    return {
      'accelerometer': {
        'x': _lastX,
        'y': _lastY,
        'z': _lastZ,
        'magnitude': sqrt((_lastX * _lastX) + (_lastY * _lastY) + (_lastZ * _lastZ)),
      },
      'gyroscope': {
        'x': _lastGyroX,
        'y': _lastGyroY,
        'z': _lastGyroZ,
        'magnitude': sqrt((_lastGyroX * _lastGyroX) + (_lastGyroY * _lastGyroY) + (_lastGyroZ * _lastGyroZ)),
      },
    };
  }

  // Get average impact force
  double getAverageImpactForce() {
    if (_accelerometerBuffer.isEmpty) return 0;
    return _accelerometerBuffer.reduce((a, b) => a + b) / _accelerometerBuffer.length;
  }

  // Get peak impact force
  double getPeakImpactForce() {
    if (_accelerometerBuffer.isEmpty) return 0;
    return _accelerometerBuffer.reduce((a, b) => a > b ? a : b);
  }

  // Analyze if impact is likely an accident
  bool isLikelyAccident() {
    if (_accelerometerBuffer.length < 10) return false;

    double peakForce = getPeakImpactForce();
    double avgForce = getAverageImpactForce();
    double peakGyro = _gyroscopeBuffer.isEmpty ? 0 : _gyroscopeBuffer.reduce((a, b) => a > b ? a : b);

    // Check multiple conditions
    bool highImpact = peakForce > impactThreshold;
    bool abnormalRotation = peakGyro > 5.0; // high rotation
    bool force = avgForce > (impactThreshold * 0.7); // sustained force

    return highImpact && (abnormalRotation || force);
  }

  // Reset buffers
  void resetBuffers() {
    _accelerometerBuffer.clear();
    _gyroscopeBuffer.clear();
    _lastImpactTime = null;
  }
}
