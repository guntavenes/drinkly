import 'dart:math';

class NotificationMessages {
  NotificationMessages._();

  static final _random = Random();

  static const List<String> _morningTitles = [
    '☀️ Good morning',
    '💧 Start fresh',
    '🚰 Morning hydration',
    '🌤️ New day, new sip',
  ];

  static const List<String> _morningBodies = [
    'Start your day with a glass of water.',
    'A little water now can set the tone for the day.',
    'Your morning hydration is waiting.',
    'Wake up your body with some water.',
  ];

  static const List<String> _dayTitles = [
    '💧 Time for water',
    '💙 Stay hydrated',
    '🚰 Water break',
    '🌊 Every sip counts',
    '🥤 Hydration time',
    '✨ Small sip, big difference',
  ];

  static const List<String> _dayBodies = [
    'A glass of water would be great right now.',
    'Your body will thank you.',
    'Keep your hydration streak alive.',
    'Take a short break and drink some water.',
    'You are getting closer to today\'s goal.',
    'Healthy habits start with one sip.',
    'A quick sip can make a big difference.',
    'Don\'t wait until you feel thirsty.',
  ];

  static const List<String> _eveningTitles = [
    '🌙 Evening hydration',
    '💧 One more sip',
    '✨ Finish strong',
    '🥤 Last water break',
  ];

  static const List<String> _eveningBodies = [
    'One last glass of water can help you finish the day well.',
    'You are almost done for today. Keep going.',
    'A calm evening sip sounds perfect.',
    'Finish your hydration goal before the day ends.',
  ];

  static String randomTitle({DateTime? now}) {
    final hour = (now ?? DateTime.now()).hour;

    if (hour < 12) {
      return _pick(_morningTitles);
    }

    if (hour >= 18) {
      return _pick(_eveningTitles);
    }

    return _pick(_dayTitles);
  }

  static String randomBody({DateTime? now}) {
    final hour = (now ?? DateTime.now()).hour;

    if (hour < 12) {
      return _pick(_morningBodies);
    }

    if (hour >= 18) {
      return _pick(_eveningBodies);
    }

    return _pick(_dayBodies);
  }

  static String _pick(List<String> values) {
    return values[_random.nextInt(values.length)];
  }
}
