import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/contacts/emergency_contacts_screen.dart';
import '../screens/history/accident_history_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'constants.dart';

/// App route generator
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.contacts:
        return MaterialPageRoute(builder: (_) => const EmergencyContactsScreen());

      case AppRoutes.history:
        return MaterialPageRoute(builder: (_) => const AccidentHistoryScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Navigate to route
  static Future<dynamic> navigateTo(BuildContext context, String routeName) {
    return Navigator.of(context).pushNamed(routeName);
  }

  /// Navigate to route and replace
  static Future<dynamic> navigateToAndReplace(BuildContext context, String routeName) {
    return Navigator.of(context).pushReplacementNamed(routeName);
  }

  /// Navigate to route and clear all
  static Future<dynamic> navigateToAndClearAll(BuildContext context, String routeName) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
    );
  }

  /// Pop current route
  static void pop(BuildContext context, {dynamic result}) {
    Navigator.of(context).pop(result);
  }

  /// Pop until route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  /// Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    String? routeName;
    Navigator.of(context).popUntil((route) {
      routeName = route.settings.name;
      return true;
    });
    return routeName;
  }
}

/// Navigation observer for tracking route changes
class NavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped route: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Replaced route: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}

/// Dialog navigation helper
class DialogNavigator {
  /// Show bottom sheet
  static Future<T?> showBottomSheet<T>(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  /// Show dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return showDialog<T>(
      context: context,
      builder: builder,
    );
  }

  /// Show full screen dialog
  static Future<T?> showFullScreenDialog<T>(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }
}
