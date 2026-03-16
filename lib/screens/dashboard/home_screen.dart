import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/sensor_monitoring_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/database_service.dart';
import '../../models/accident_report_model.dart';
import '../contacts/emergency_contacts_screen.dart';
import '../history/accident_history_screen.dart';
import '../settings/settings_screen.dart';
import '../../screens/auth/login_screen.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _authService = AuthService();
  final _sensorService = SensorMonitoringService(impactThreshold: 25.0);
  final _locationService = LocationService();
  final _databaseService = DatabaseService();

  bool _isMonitoring = false;
  bool _accidentDetected = false;
  int _countdownSeconds = 10;
  Timer? _countdownTimer;
  double _currentImpactForce = 0;
  Map<String, dynamic> _currentSensorData = {};

  @override
  void initState() {
    super.initState();
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

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _stopMonitoring();
              _authService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopMonitoring();
    _countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user?.displayName ?? 'User'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your device is continuously monitoring for accidents',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
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

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _quickActionCard(
                    icon: Icons.contacts,
                    title: 'Emergency Contacts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
                    ),
                  ),
                  _quickActionCard(
                    icon: Icons.history,
                    title: 'Accident History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccidentHistoryScreen()),
                    ),
                  ),
                  _quickActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    ),
                  ),
                  _quickActionCard(
                    icon: Icons.info,
                    title: 'Help & Info',
                    onTap: () => _showHelpDialog(),
                  ),
                ],
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

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This App'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Accident Detection System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'This app uses your phone\'s sensors to detect accidents automatically. When a sudden impact is detected, you\'ll have 10 seconds to cancel the alert before emergency contacts are notified.',
              ),
              SizedBox(height: 12),
              Text(
                'Features:\n'
                '• Automatic accident detection\n'
                '• Real-time GPS location sharing\n'
                '• Emergency contact alerts\n'
                '• Accident history tracking\n'
                '• Manual SOS button',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
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
