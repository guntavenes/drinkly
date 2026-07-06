import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/database/app_database.dart';
import 'notification_channel.dart';
import 'notification_messages.dart';
import 'notification_service.dart';

class NotificationScheduler {
  NotificationScheduler._();

  static final NotificationScheduler instance = NotificationScheduler._();

  Future<void> scheduleFromSettings(AppSetting settings) async {
    await NotificationService.instance.cancelAll();

    if (!settings.remindersEnabled) {
      return;
    }

    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
      settings.reminderStartHour,
      settings.reminderStartMinute,
    );

    final rawEnd = DateTime(
      now.year,
      now.month,
      now.day,
      settings.reminderEndHour,
      settings.reminderEndMinute,
    );

    final end = settings.reminderEndHour == 0 && settings.reminderEndMinute == 0
        ? DateTime(now.year, now.month, now.day, 23, 59)
        : rawEnd;

    var current = start;
    var notificationId = 1000;

    while (!current.isAfter(end)) {
      await _scheduleDailyReminder(id: notificationId, time: current);

      current = current.add(
        Duration(minutes: settings.reminderIntervalMinutes),
      );

      notificationId++;
    }
  }

  Future<void> _scheduleDailyReminder({
    required int id,
    required DateTime time,
  }) async {
    final scheduledDate = _nextInstanceOfTime(time);

    await NotificationService.instance.plugin.zonedSchedule(
      id,
      NotificationMessages.randomTitle(now: time),
      NotificationMessages.randomBody(now: time),
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannel.id,
          NotificationChannel.name,
          channelDescription: NotificationChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() {
    return NotificationService.instance.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
