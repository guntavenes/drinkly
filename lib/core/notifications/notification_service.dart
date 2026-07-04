import 'package:drinkly/core/notifications/notification_messages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_channel.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      iOS: iosSettings,
      android: androidSettings,
    );

    await _plugin.initialize(settings);
  }

  Future<bool> requestPermission() async {
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final iosGranted =
        await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final androidGranted =
        await androidPlugin?.requestNotificationsPermission() ?? true;

    return iosGranted && androidGranted;
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> showTestNotification() async {
    final granted = await requestPermission();

    if (!granted) return;

    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    try {
      await _plugin.show(
        id,
        NotificationMessages.randomTitle(),
        NotificationMessages.randomBody(),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
            interruptionLevel: InterruptionLevel.active,
          ),
          android: AndroidNotificationDetails(
            NotificationChannel.id,
            NotificationChannel.name,
            channelDescription: NotificationChannel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      debugPrint('Test notification sent with id: $id');
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  Future<void> showTestNotificationAfter5Seconds() async {
    final granted = await requestPermission();

    if (!granted) return;

    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 5));

    await _plugin.zonedSchedule(
      id,
      '💧 Drinkly Reminder',
      'This is a scheduled test notification.',
      scheduledDate,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
          interruptionLevel: InterruptionLevel.active,
        ),
        android: AndroidNotificationDetails(
          NotificationChannel.id,
          NotificationChannel.name,
          channelDescription: NotificationChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  FlutterLocalNotificationsPlugin get plugin => _plugin;
}
