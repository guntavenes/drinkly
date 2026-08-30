import 'package:drinkly/core/theme/app_theme_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stored theme names restore the matching theme', () {
    for (final style in AppThemeStyle.values) {
      expect(AppThemeStyle.fromStorage(style.name), style);
    }
  });

  test('unknown stored themes safely fall back to Ocean', () {
    expect(AppThemeStyle.fromStorage('unknown'), AppThemeStyle.ocean);
    expect(AppThemeStyle.fromStorage(null), AppThemeStyle.ocean);
  });
}
