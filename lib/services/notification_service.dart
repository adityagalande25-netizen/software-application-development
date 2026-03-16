import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationService {
  // Initialize notifications
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'accident_alerts',
          channelKey: 'accident_channel',
          channelName: 'Accident Alerts',
          channelDescription: 'Critical accident detection alerts',
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          locked: true,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelGroupKey: 'emergency_alerts',
          channelKey: 'emergency_channel',
          channelName: 'Emergency Alerts',
          channelDescription: 'Emergency response notifications',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
        NotificationChannel(
          channelGroupKey: 'general_notifications',
          channelKey: 'general_channel',
          channelName: 'General Notifications',
          channelDescription: 'General app notifications',
          importance: NotificationImportance.Default,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Send accident detected notification
  static Future<void> sendAccidentDetectedNotification({
    required String title,
    required String body,
    required String latitude,
    required String longitude,
    required String mapUrl,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'accident_channel',
        title: title,
        body: body,
        payload: {
          'latitude': latitude,
          'longitude': longitude,
          'mapUrl': mapUrl,
        },
        notificationLayout: NotificationLayout.BigText,
        color: const Color.fromARGB(255, 255, 0, 0),
        criticalAlert: true,
      ),
    );
  }

  // Send emergency alert
  static Future<void> sendEmergencyAlert({
    required String contactName,
    required String message,
    required String mapUrl,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'emergency_channel',
        title: 'Emergency Alert Sent',
        body: '$contactName has been alerted: $message',
        payload: {'mapUrl': mapUrl},
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  // Send general notification
  static Future<void> sendGeneralNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'general_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Call emergency number
  static Future<void> callEmergency(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Send SMS
  static Future<void> sendSMS(String phoneNumber, String message) async {
    final uri = Uri(scheme: 'sms', path: phoneNumber, queryParameters: {'body': message});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Open map
  static Future<void> openMapsUrl(String mapUrl) async {
    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl), mode: LaunchMode.externalApplication);
    }
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
