import 'package:drinkly/core/notifications/notification_messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('completed goal produces a completion notification', () {
    expect(
      NotificationMessages.smartTitle(todayTotal: 2500, dailyGoal: 2500),
      '🎉 Goal completed',
    );
    expect(
      NotificationMessages.smartBody(todayTotal: 2500, dailyGoal: 2500),
      'Today\'s goal completed. Amazing work!',
    );
  });

  test('near-complete goal includes the remaining amount', () {
    expect(
      NotificationMessages.smartBody(todayTotal: 2000, dailyGoal: 2500),
      'Almost there! Only 500 ml left today.',
    );
  });
}
