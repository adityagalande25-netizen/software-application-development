import 'package:flutter/material.dart';

/// String extensions
extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isEmpty => this.isEmpty;

  /// Check if string has content
  bool get isNotEmpty => this.isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Check if string is numeric
  bool get isNumeric => num.tryParse(this) != null;

  /// Reverse string
  String get reversed => split('').reversed.join('');

  /// Remove all whitespace
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');
}

/// Double extensions
extension DoubleExtensions on double {
  /// Check if value is positive
  bool get isPositive => this > 0;

  /// Check if value is negative
  bool get isNegative => this < 0;

  /// Check if value is zero
  bool get isZero => this == 0;

  /// Check if value is between range
  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }

  /// Clamp value to range
  double clampBetween(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Get difference in days from now
  int get daysFromNow {
    return DateTime.now().difference(this).inDays;
  }

  /// Get difference in hours from now
  int get hoursFromNow {
    return DateTime.now().difference(this).inHours;
  }

  /// Get difference in minutes from now
  int get minutesFromNow {
    return DateTime.now().difference(this).inMinutes;
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Safely get element at index
  T? getAtIndex(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Check if list is empty
  bool get isEmpty => length == 0;

  /// Check if list has content
  bool get isNotEmpty => length > 0;

  /// Get first element safely
  T? get firstOrNull => isNotEmpty ? first : null;

  /// Get last element safely
  T? get lastOrNull => isNotEmpty ? last : null;

  /// Shuffle list
  List<T> shuffled() {
    final shuffled = this;
    shuffled.shuffle();
    return shuffled;
  }
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get device padding (notch/safe area)
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;

  /// Check if device in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device in landscape mode
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Get device brightness
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// Check if device in dark mode
  bool get isDarkMode => brightness == Brightness.dark;

  /// Pop current route
  void pop<T extends Object>([T? result]) {
    Navigator.pop(this, result);
  }

  /// Push named route
  Future<T?> pushNamed<T extends Object>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  /// Replace current route
  Future<T?> pushReplacementNamed<T extends Object, TO extends Object>(String routeName, {TO? result, Object? arguments}) {
    return Navigator.pushReplacementNamed<T, TO>(this, routeName, result: result, arguments: arguments);
  }

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: duration,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }
}
