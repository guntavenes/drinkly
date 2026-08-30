import 'package:drinkly/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/app_theme_style.dart';
import '../core/database/database_provider.dart';
import '../core/widget/widget_service.dart';
import '../core/widget/widget_providers.dart';
import '../features/settings/data/providers/settings_providers.dart';

class DrinklyApp extends ConsumerStatefulWidget {
  const DrinklyApp({super.key});

  @override
  ConsumerState<DrinklyApp> createState() => _DrinklyAppState();
}

class _DrinklyAppState extends ConsumerState<DrinklyApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetService.consumePendingActions(ref.read(appDatabaseProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widgetSyncProvider);
    final settingsAsync = ref.watch(settingsProvider);

    final darkMode = settingsAsync.maybeWhen(
      data: (settings) => settings?.darkMode ?? false,
      orElse: () => false,
    );

    final onboardingCompleted = settingsAsync.maybeWhen(
      data: (settings) => settings?.onboardingCompleted ?? false,
      orElse: () => false,
    );

    final themeStyle = settingsAsync.maybeWhen(
      data: (settings) => AppThemeStyle.fromStorage(settings?.themeStyle),
      orElse: () => AppThemeStyle.ocean,
    );

    final useDarkTheme = darkMode || themeStyle == AppThemeStyle.midnight;

    return MaterialApp(
      title: 'Drinkly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeStyle),
      darkTheme: AppTheme.darkTheme(themeStyle),
      themeMode: useDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(onboardingCompleted: onboardingCompleted),
    );
  }
}
