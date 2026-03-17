import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/database_service.dart';
import '../../models/accident_report_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_menu_drawer.dart';

class AccidentHistoryScreen extends StatefulWidget {
  const AccidentHistoryScreen({super.key});

  @override
  State<AccidentHistoryScreen> createState() => _AccidentHistoryScreenState();
}

class _AccidentHistoryScreenState extends State<AccidentHistoryScreen> {
  final _databaseService = DatabaseService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident History'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenuDrawer(currentRoute: AppRoutes.history),
      body: userId == null
          ? const Center(child: Text('User not authenticated'))
          : FutureBuilder<List<AccidentReport>>(
              future: _databaseService.getAccidentReports(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final reports = snapshot.data ?? [];

                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 80, color: Colors.green.shade300),
                        const SizedBox(height: 16),
                        const Text('No accident reports recorded'),
                        const SizedBox(height: 8),
                        const Text(
                          'Stay safe!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return _AccidentReportCard(report: report);
                  },
                );
              },
            ),
    );
  }
}

class _AccidentReportCard extends StatelessWidget {
  final AccidentReport report;

  const _AccidentReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');
    final severityColor = _getSeverityColor(report.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: severityColor.withOpacity(0.2),
          child: Icon(Icons.warning, color: severityColor),
        ),
        title: Text(
          '${report.severity.toUpperCase()} - ${report.status.toUpperCase()}',
          style: TextStyle(fontWeight: FontWeight.bold, color: severityColor),
        ),
        subtitle: Text(dateFormat.format(report.timestamp)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow('Impact Force', '${report.impactForce.toStringAsFixed(2)} m/s²'),
                _InfoRow('Severity', report.severity),
                _InfoRow('Status', report.status),
                _InfoRow('Location', '${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}'),
                _InfoRow('Timestamp', dateFormat.format(report.timestamp)),
                _InfoRow('Alert Sent', report.alertSent ? 'Yes' : 'No'),
                if (report.contactsAlerted.isNotEmpty)
                  _InfoRow('Contacts Alerted', '${report.contactsAlerted.length}'),
                if (report.userNote != null)
                  _InfoRow('User Note', report.userNote!),
                const SizedBox(height: 12),
                if (report.mapUrl != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Open map URL
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('View on Map'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
