import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'utils/helpers.dart';
import 'utils/logger.dart';
import 'utils/navigation.dart';

String? _initializationError;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    Logger.info('Initializing Firebase...');
    await Firebase.initializeApp();
    Logger.info('Firebase initialized successfully');

    // Initialize Notifications
    Logger.info('Initializing Notifications...');
    await NotificationService.initializeNotifications();
    Logger.info('Notifications initialized successfully');

    // Initialize App
    Logger.info('Initializing App...');
    await AppInitializer.initializeApp();
    Logger.info('App initialized successfully');

    runApp(const AccidentDetectionApp());
  } catch (e, stackTrace) {
    _initializationError = e.toString();
    Logger.error('Fatal error during app initialization', e, stackTrace);
    runApp(ErrorBootApp(errorMessage: _initializationError));
  }
}

class AccidentDetectionApp extends StatelessWidget {
  const AccidentDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: _buildHome(),
      onGenerateRoute: AppRouter.generateRoute,
      navigatorObservers: [NavigationObserver()],
    );
  }

  /// Build home screen based on authentication state
  Widget _buildHome() {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          Logger.logAuthentication('User authenticated', userId: (snapshot.data as User?)?.uid);
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

/// Error app for initialization failures
class ErrorBootApp extends StatelessWidget {
  final String? errorMessage;

  const ErrorBootApp({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize app',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ??
                    'Please check your internet connection and try again',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Logger.info('User clicked retry');
                  _retryInitialization();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryInitialization() async {
    Logger.info('Retrying app initialization');
    try {
      await Firebase.initializeApp();
      await NotificationService.initializeNotifications();
      await AppInitializer.initializeApp();
      // If successful, restart the app by rebuilding the root widget
      runApp(const AccidentDetectionApp());
    } catch (e, stackTrace) {
      Logger.error('Retry initialization failed', e, stackTrace);
      // Optionally show a dialog or update the screen
    }
  }
}
