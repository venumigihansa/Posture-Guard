import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Final initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize plugin
    await _notificationsPlugin.initialize(initializationSettings);

    // Create notification channel (required for Android 8.0+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'posture_alerts_channel',
      'Posture Alerts',
      description: 'This channel is used for posture notifications.',
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Runtime permission for Android 13+ (API 33+)
    if (Platform.isAndroid) {
      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Check if notification permissions are granted
      final status = await Permission.notification.status;

      if (!status.isGranted) {
        // Request permission for notifications
        await Permission.notification.request();
      }
    }
  }

  static Future<void> showPostureAlert() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'posture_alerts_channel',
      'Posture Alerts',
      channelDescription: 'This channel is used for posture notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Posture Alert!',
      'You\'re slouching! Straighten your back.',
      notificationDetails,
    );
  }
}
