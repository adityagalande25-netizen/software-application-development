import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/contacts/emergency_contacts_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/help/help_info_screen.dart';
import '../screens/history/accident_history_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AppMenuDrawer extends StatelessWidget {
  final String currentRoute;

  const AppMenuDrawer({
    super.key,
    required this.currentRoute,
  });

  Future<void> _navigateTo(BuildContext context, String route) async {
    if (route == currentRoute) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);

    Widget screen;
    switch (route) {
      case AppRoutes.home:
        screen = const HomeScreen();
        break;
      case AppRoutes.contacts:
        screen = const EmergencyContactsScreen();
        break;
      case AppRoutes.history:
        screen = const AccidentHistoryScreen();
        break;
      case AppRoutes.settings:
        screen = const SettingsScreen();
        break;
      case AppRoutes.help:
        screen = const HelpInfoScreen();
        break;
      default:
        screen = const HomeScreen();
        break;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, animation, __) {
          return FadeTransition(opacity: animation, child: screen);
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.pop(context);
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shield, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Accident Detection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              selected: currentRoute == AppRoutes.home,
              onTap: () => _navigateTo(context, AppRoutes.home),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Emergency Contacts'),
              selected: currentRoute == AppRoutes.contacts,
              onTap: () => _navigateTo(context, AppRoutes.contacts),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Accident History'),
              selected: currentRoute == AppRoutes.history,
              onTap: () => _navigateTo(context, AppRoutes.history),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              selected: currentRoute == AppRoutes.settings,
              onTap: () => _navigateTo(context, AppRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Help & Info'),
              selected: currentRoute == AppRoutes.help,
              onTap: () => _navigateTo(context, AppRoutes.help),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}