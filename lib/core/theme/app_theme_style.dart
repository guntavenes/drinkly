import 'package:flutter/material.dart';

enum AppThemeStyle {
  ocean,
  aurora,
  sunset,
  midnight;

  String get label => switch (this) {
    ocean => 'Ocean',
    aurora => 'Aurora',
    sunset => 'Sunset',
    midnight => 'Midnight',
  };

  String get description => switch (this) {
    ocean => 'Clear blue and refreshing',
    aurora => 'Calm violet and turquoise',
    sunset => 'Warm coral and golden',
    midnight => 'Deep blue and focused',
  };

  Color get primary => switch (this) {
    ocean => const Color(0xFF1677FF),
    aurora => const Color(0xFF7257F5),
    sunset => const Color(0xFFFF6B5E),
    midnight => const Color(0xFF6A8DFF),
  };

  Color get secondary => switch (this) {
    ocean => const Color(0xFF66D7FF),
    aurora => const Color(0xFF45D6BA),
    sunset => const Color(0xFFFFB650),
    midnight => const Color(0xFF65C7F7),
  };

  List<Color> get heroGradient => switch (this) {
    ocean => const [Color(0xFF1268F3), Color(0xFF4BAFFF)],
    aurora => const [Color(0xFF6948E8), Color(0xFF32BFA8)],
    sunset => const [Color(0xFFFF5F6D), Color(0xFFFFA94D)],
    midnight => const [Color(0xFF25355F), Color(0xFF526FAF)],
  };

  static AppThemeStyle fromStorage(String? value) {
    return AppThemeStyle.values.firstWhere(
      (style) => style.name == value,
      orElse: () => AppThemeStyle.ocean,
    );
  }
}

@immutable
class DrinklyTheme extends ThemeExtension<DrinklyTheme> {
  const DrinklyTheme(this.style);

  final AppThemeStyle style;

  @override
  DrinklyTheme copyWith({AppThemeStyle? style}) {
    return DrinklyTheme(style ?? this.style);
  }

  @override
  DrinklyTheme lerp(covariant DrinklyTheme? other, double t) {
    return t < .5 ? this : (other ?? this);
  }
}
