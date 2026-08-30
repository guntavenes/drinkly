import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';

import '../database/app_database.dart';

class WidgetService {
  const WidgetService._();

  static const appGroupId = 'group.com.enesguntav.drinkly';
  static const widgetName = 'DrinklyWidget';

  static Future<void> initialize() async {
    if (!Platform.isIOS) return;
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> sync({
    required int todayTotal,
    required int dailyGoal,
    required String themeStyle,
  }) async {
    if (!Platform.isIOS) return;

    await Future.wait([
      HomeWidget.saveWidgetData<int>('todayTotal', todayTotal),
      HomeWidget.saveWidgetData<int>('dailyGoal', dailyGoal),
      HomeWidget.saveWidgetData<String>('themeStyle', themeStyle),
      HomeWidget.saveWidgetData<String>(
        'lastUpdated',
        DateTime.now().toIso8601String(),
      ),
    ]);

    await HomeWidget.updateWidget(iOSName: widgetName);
  }

  static Future<int> consumePendingActions(AppDatabase database) async {
    if (!Platform.isIOS) return 0;

    final rawActions = await HomeWidget.getWidgetData<String>(
      'pendingActions',
      defaultValue: '[]',
    );

    if (rawActions == null || rawActions.isEmpty || rawActions == '[]') {
      return 0;
    }

    final decoded = jsonDecode(rawActions);
    if (decoded is! List) return 0;

    var imported = 0;
    for (final item in decoded) {
      if (item is! Map) continue;

      final amount = item['amount'];
      final timestamp = item['timestamp'];
      if (amount is! num || amount <= 0 || timestamp is! String) continue;

      final createdAt = DateTime.tryParse(timestamp)?.toLocal();
      if (createdAt == null) continue;

      await database.insertHydrationEntry(
        HydrationEntriesCompanion.insert(
          amount: amount.toInt(),
          createdAt: createdAt,
        ),
      );
      imported++;
    }

    if (imported > 0) {
      await HomeWidget.saveWidgetData<String>('pendingActions', '[]');
    }

    return imported;
  }
}
