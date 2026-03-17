import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/sensor_monitoring_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/database_service.dart';
import '../../models/accident_report_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_menu_drawer.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _sensorService = SensorMonitoringService(impactThreshold: 25.0);
  final _locationService = LocationService();
  final _databaseService = DatabaseService();

  bool _isMonitoring = false;
  bool _accidentDetected = false;
  int _countdownSeconds = 10;
  Timer? _countdownTimer;
  late final AnimationController _ambientController;
  late final AnimationController _sosPulseController;
  double _currentImpactForce = 0;
  Map<String, dynamic> _currentSensorData = {};

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _sosPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addObserver(this);
    _initializeMonitoring();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isMonitoring) {
        _startMonitoring();
      }
    } else if (state == AppLifecycleState.paused) {
      if (_isMonitoring) {
        _stopMonitoring();
      }
    }
  }

  Future<void> _initializeMonitoring() async {
    final hasLocationPermission = await _locationService.requestLocationPermission();
    if (!hasLocationPermission && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for accident detection')),
      );
    }
  }

  void _startMonitoring() {
    if (_isMonitoring) return;

    setState(() => _isMonitoring = true);

    _sensorService.onImpactDetected = (impactForce) {
      _handleAccidentDetected(impactForce);
    };

    _sensorService.onSensorDataChanged = (data) {
      setState(() => _currentSensorData = data);
    };

    _sensorService.startMonitoring();
  }

  void _stopMonitoring() {
    if (!_isMonitoring) return;

    setState(() => _isMonitoring = false);
    _sensorService.stopMonitoring();
    _cancelCountdown();
  }

  Future<void> _handleAccidentDetected(double impactForce) async {
    if (!mounted) return;

    setState(() {
      _accidentDetected = true;
      _currentImpactForce = impactForce;
      _countdownSeconds = 10;
    });

    NotificationService.sendAccidentDetectedNotification(
      title: 'Accident Detected!',
      body: 'Impact Force: ${impactForce.toStringAsFixed(2)} m/s²',
      latitude: '0',
      longitude: '0',
      mapUrl: '',
    );

    _startCountdown();

    // Show confirmation dialog
    if (mounted) {
      _showAccidentConfirmationDialog(impactForce);
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        _sendEmergencyAlert();
        timer.cancel();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _accidentDetected = false;
      _countdownSeconds = 10;
    });
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final location = await _locationService.getCurrentLocation();
      if (location == null) return;

      final report = AccidentReport(
        id: const Uuid().v4(),
        userId: user.uid,
        timestamp: DateTime.now(),
        latitude: location.latitude,
        longitude: location.longitude,
        impactForce: _currentImpactForce,
        severity: _getSeverity(_currentImpactForce),
        alertSent: true,
        contactsAlerted: [],
        mapUrl: _locationService.getGoogleMapsUrl(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
        status: 'confirmed',
      );

      await _databaseService.addAccidentReport(report);

      // Get emergency contacts
      final contacts = await _databaseService.getEmergencyContacts(user.uid);
      final alertedContacts = <String>[];

      for (final contact in contacts) {
        try {
          await NotificationService.sendSMS(
            contact.phone,
            'EMERGENCY! Accident detected at: ${report.mapUrl}. Please contact authorities.',
          );
          alertedContacts.add(contact.id);
        } catch (e) {
          print('Error sending SMS to ${contact.name}: $e');
        }
      }

      report.copyWith(contactsAlerted: alertedContacts);
      await _databaseService.updateAccidentReport(report.copyWith(contactsAlerted: alertedContacts));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency alert sent to all contacts')),
        );
        NotificationService.openMapsUrl(report.mapUrl!);
      }
    } catch (e) {
      print('Error sending emergency alert: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending alert: $e')),
        );
      }
    } finally {
      setState(() {
        _accidentDetected = false;
        _countdownSeconds = 10;
      });
    }
  }

  String _getSeverity(double impactForce) {
    if (impactForce > 50) return 'critical';
    if (impactForce > 40) return 'high';
    if (impactForce > 30) return 'medium';
    return 'low';
  }

  void _showAccidentConfirmationDialog(double impactForce) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AccidentConfirmationDialog(
        impactForce: impactForce,
        countdownSeconds: _countdownSeconds,
        onConfirm: _sendEmergencyAlert,
        onCancel: _cancelCountdown,
      ),
    );
  }

  Future<void> _manualSOS() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send SOS?'),
        content: const Text('Send emergency alert to all emergency contacts?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendEmergencyAlert();
            },
            child: const Text('Send SOS', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopMonitoring();
    _countdownTimer?.cancel();
    _ambientController.dispose();
    _sosPulseController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenuDrawer(currentRoute: AppRoutes.home),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              AnimatedBuilder(
                animation: _ambientController,
                builder: (context, child) {
                  final value = _ambientController.value;
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(Colors.red.shade800, Colors.red.shade600, value)!,
                          Color.lerp(Colors.deepOrange.shade600, Colors.red.shade900, value)!,
                        ],
                        begin: Alignment(-1 + (value * 0.5), -1),
                        end: Alignment(1, 1 - (value * 0.4)),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        RotationTransition(
                          turns: Tween<double>(begin: -0.02, end: 0.02).animate(_ambientController),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.red, size: 26),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${user?.displayName ?? 'User'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Monitoring your safety in real time',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Monitoring Status
              Card(
                color: _isMonitoring ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _isMonitoring ? Colors.green : Colors.red,
                        child: Icon(
                          _isMonitoring ? Icons.check_circle : Icons.pause_circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isMonitoring ? 'Monitoring Active' : 'Monitoring Inactive',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isMonitoring
                                  ? 'Real-time sensor monitoring enabled'
                                  : 'Click START to enable monitoring',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isMonitoring,
                        onChanged: (value) {
                          if (value) {
                            _startMonitoring();
                          } else {
                            _stopMonitoring();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // SOS Button
              SizedBox(
                height: 100,
                child: AnimatedBuilder(
                  animation: _sosPulseController,
                  builder: (context, child) {
                    final scale = 0.96 + (_sosPulseController.value * 0.05);
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: ElevatedButton(
                    onPressed: _manualSOS,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emergency, size: 40, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'MANUAL SOS',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sensor Data
              if (_currentSensorData.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Sensor Data',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _sensorDataRow(
                          'Acceleration',
                          '${_currentSensorData['accelerometer']?['magnitude']?.toStringAsFixed(2) ?? '0'} m/s²',
                        ),
                        _sensorDataRow(
                          'Rotation',
                          '${_currentSensorData['gyroscope']?['magnitude']?.toStringAsFixed(2) ?? '0'} rad/s',
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              AnimatedBuilder(
                animation: _ambientController,
                builder: (context, child) {
                  final bob = ((_ambientController.value - 0.5).abs()) * 8;
                  return Transform.translate(
                    offset: Offset(0, bob),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.tips_and_updates_outlined),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Use the menu to open Profile, Contacts, History, Settings, and Help.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sensorDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

}

class _AccidentConfirmationDialog extends StatefulWidget {
  final double impactForce;
  final int countdownSeconds;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _AccidentConfirmationDialog({
    required this.impactForce,
    required this.countdownSeconds,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_AccidentConfirmationDialog> createState() => _AccidentConfirmationDialogState();
}

class _AccidentConfirmationDialogState extends State<_AccidentConfirmationDialog> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(_animationController),
              child: Icon(
                Icons.warning,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ACCIDENT DETECTED!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            Text(
              'Impact Force: ${widget.impactForce.toStringAsFixed(2)} m/s²',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, color: Colors.amber.shade900),
                  const SizedBox(width: 8),
                  Text(
                    'Sending alert in ${widget.countdownSeconds}s',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onCancel();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onConfirm();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Send Alert', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
