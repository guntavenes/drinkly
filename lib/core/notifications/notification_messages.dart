import 'dart:math';

class NotificationMessages {
  NotificationMessages._();

  static final _random = Random();

  static const List<String> titles = [
    '💧 Time to hydrate',
    '💙 Stay hydrated',
    '🚰 Drink some water',
    '🌊 Every sip counts',
    '💦 Water break',
  ];

  static const List<String> bodies = [
    'A glass of water would be great right now.',
    'Your body will thank you.',
    'Keep your hydration streak alive.',
    'Small sips make a big difference.',
    'Take a short break and drink some water.',
    'You are getting closer to today\'s goal.',
    'Healthy habits start with one sip.',
  ];

  static String randomTitle() {
    return titles[_random.nextInt(titles.length)];
  }

  static String randomBody() {
    return bodies[_random.nextInt(bodies.length)];
  }
}
