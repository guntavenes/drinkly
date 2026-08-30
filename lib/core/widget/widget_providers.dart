import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/hydration/data/providers/hydration_providers.dart';
import '../../features/settings/data/providers/settings_providers.dart';
import 'widget_service.dart';

final widgetSyncProvider = Provider<void>((ref) {
  Future<void> sync() async {
    final entries = ref
        .read(todayHydrationEntriesProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final settings = ref
        .read(settingsProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);

    if (entries == null || settings == null) return;

    final total = entries.fold<int>(0, (sum, entry) => sum + entry.amount);
    await WidgetService.sync(
      todayTotal: total,
      dailyGoal: settings.dailyGoal,
      themeStyle: settings.themeStyle,
    );
  }

  ref.listen(todayHydrationEntriesProvider, (_, _) => unawaited(sync()));
  ref.listen(settingsProvider, (_, _) => unawaited(sync()));
});
