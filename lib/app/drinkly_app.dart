import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/hydration/presentation/screens/home_screen.dart';

class DrinklyApp extends StatelessWidget {
  const DrinklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drinkly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
