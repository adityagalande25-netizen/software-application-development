import 'package:intl/intl.dart';

/// Format timestamp to readable date
String formatDate(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy').format(dateTime);
}

/// Format timestamp to readable time
String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

/// Format timestamp to full datetime
String formatDateTime(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
}

/// Format timestamp to relative time (e.g., "2 hours ago")
String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks weeks ago';
  } else {
    return formatDate(dateTime);
  }
}

/// Format double to string with precision
String formatDouble(double value, {int decimals = 2}) {
  return value.toStringAsFixed(decimals);
}

/// Format impact force with unit
String formatImpactForce(double force) {
  return '${formatDouble(force, decimals: 1)} m/s²';
}

/// Format location coordinates
String formatCoordinates(double latitude, double longitude) {
  return '${formatDouble(latitude, decimals: 4)}, ${formatDouble(longitude, decimals: 4)}';
}

/// Format severity level to readable text
String formatSeverity(String severity) {
  switch (severity.toLowerCase()) {
    case 'critical':
      return 'Critical';
    case 'high':
      return 'High';
    case 'medium':
      return 'Medium';
    case 'low':
      return 'Low';
    default:
      return 'Unknown';
  }
}

/// Format status to readable text
String formatStatus(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pending';
    case 'confirmed':
      return 'Confirmed';
    case 'resolved':
      return 'Resolved';
    case 'false_alarm':
      return 'False Alarm';
    default:
      return 'Unknown';
  }
}

/// Parse ISO8601 string to DateTime
DateTime parseDateTime(String dateString) {
  return DateTime.parse(dateString);
}

/// Convert DateTime to ISO8601 string
String toIso8601(DateTime dateTime) {
  return dateTime.toIso8601String();
}
