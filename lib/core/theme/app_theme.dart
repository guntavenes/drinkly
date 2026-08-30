import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_theme_style.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme(AppThemeStyle style) {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.lightText,
      displayColor: AppColors.lightText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE6EEF8),

      colorScheme: ColorScheme.fromSeed(
        seedColor: style.primary,
        brightness: Brightness.light,
      ).copyWith(surface: Colors.white, onSurface: AppColors.lightText),

      iconTheme: IconThemeData(color: style.primary),

      textTheme: textTheme,
      extensions: [DrinklyTheme(style)],

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: .96),
        indicatorColor: style.primary.withValues(alpha: .11),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? style.primary
                : AppColors.lightTextSecondary,
          );
        }),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: false,
        surfaceTintColor: Colors.transparent,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData darkTheme(AppThemeStyle style) {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.darkText, displayColor: AppColors.darkText);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: const Color(0xFF1E293B),
      dividerColor: const Color(0xFF334155),

      colorScheme: ColorScheme.fromSeed(
        seedColor: style.primary,
        brightness: Brightness.dark,
      ).copyWith(surface: const Color(0xFF1E293B), onSurface: Colors.white),

      iconTheme: IconThemeData(color: style.primary),

      textTheme: textTheme,
      extensions: [DrinklyTheme(style)],

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.darkSurface.withValues(alpha: .98),
        indicatorColor: style.primary.withValues(alpha: .18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? style.secondary
                : AppColors.darkTextSecondary,
          );
        }),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
