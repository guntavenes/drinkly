import 'notification_service.dart';

class NotificationPermission {
  NotificationPermission._();

  static Future<bool> request() {
    return NotificationService.instance.requestPermission();
  }
}
