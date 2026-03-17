import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/app_menu_drawer.dart';

class HelpInfoScreen extends StatelessWidget {
  const HelpInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Info'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenuDrawer(currentRoute: AppRoutes.help),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Accident Detection',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This app monitors your phone sensors to detect strong impacts. '
                    'If a possible accident is detected, you get a countdown to cancel before alerts are sent.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How It Works',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text('1. Enable monitoring from Home.'),
                  SizedBox(height: 6),
                  Text('2. Add emergency contacts.'),
                  SizedBox(height: 6),
                  Text('3. On impact detection, cancel if safe or send alert.'),
                  SizedBox(height: 6),
                  Text('4. Alerts include your current location link.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Features',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text('• Automatic accident detection'),
                  SizedBox(height: 6),
                  Text('• Manual SOS'),
                  SizedBox(height: 6),
                  Text('• Emergency contact notifications'),
                  SizedBox(height: 6),
                  Text('• Accident history tracking'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
