import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/data/providers/settings_providers.dart';
import 'app_shell.dart';

class DrinklyApp extends ConsumerWidget {
  const DrinklyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final darkMode = settingsAsync.maybeWhen(
      data: (settings) => settings?.darkMode ?? false,
      orElse: () => false,
    );

    return MaterialApp(
      title: 'Drinkly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AppShell(),
    );
  }
}
