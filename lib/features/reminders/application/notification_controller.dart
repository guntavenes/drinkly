import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_permission.dart';
import '../../../core/notifications/notification_scheduler.dart';
import '../../../core/notifications/notification_service.dart';
import '../../settings/data/providers/settings_providers.dart';

final notificationControllerProvider = Provider(
  (ref) => NotificationController(ref),
);

class NotificationController {
  NotificationController(this.ref);

  final Ref ref;

  Future<void> updateReminder(bool enabled) async {
    final repository = ref.read(settingsRepositoryProvider);

    final granted = await NotificationPermission.request();

    if (!granted) {
      await repository.updateRemindersEnabled(false);
      await NotificationScheduler.instance.cancelAll();
      return;
    }

    await repository.updateRemindersEnabled(enabled);

    final settings = await repository.readSettings();

    if (settings == null) return;

    if (!enabled) {
      await NotificationScheduler.instance.cancelAll();
      return;
    }

    await NotificationScheduler.instance.scheduleFromSettings(settings);
  }

  Future<void> refreshSchedule() async {
    final repository = ref.read(settingsRepositoryProvider);
    final settings = await repository.readSettings();

    if (settings == null) return;

    if (!settings.remindersEnabled) {
      await NotificationScheduler.instance.cancelAll();
      return;
    }

    await NotificationScheduler.instance.scheduleFromSettings(settings);
  }

  Future<void> showTestNotification() async {
    await NotificationService.instance.showTestNotificationAfter5Seconds();
  }
}
