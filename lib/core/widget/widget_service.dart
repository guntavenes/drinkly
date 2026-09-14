import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';

import '../database/app_database.dart';

class WidgetService {
  const WidgetService._();

  static const appGroupId = 'group.com.enesguntav.drinkly';
  static const widgetName = 'DrinklyWidget';
  static bool _isConsumingActions = false;

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(appGroupId);
    }
  }

  static Future<void> sync({
    required int todayTotal,
    required int dailyGoal,
    required String themeStyle,
  }) async {
    if (!Platform.isIOS && !Platform.isAndroid) return;

    final now = DateTime.now();
    await Future.wait([
      HomeWidget.saveWidgetData<int>('todayTotal', todayTotal),
      HomeWidget.saveWidgetData<String>(
        'totalDay',
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      ),
      HomeWidget.saveWidgetData<int>('dailyGoal', dailyGoal),
      HomeWidget.saveWidgetData<String>('themeStyle', themeStyle),
      HomeWidget.saveWidgetData<String>(
        'lastUpdated',
        DateTime.now().toIso8601String(),
      ),
    ]);

    await HomeWidget.updateWidget(
      iOSName: Platform.isIOS ? widgetName : null,
      qualifiedAndroidName: Platform.isAndroid
          ? 'com.enesguntav.drinkly.DrinklyWidgetProvider'
          : null,
    );
  }

  static Future<int> consumePendingActions(AppDatabase database) async {
    if (!Platform.isIOS && !Platform.isAndroid) return 0;
    if (_isConsumingActions) return 0;
    _isConsumingActions = true;

    try {
      return await _consumePendingActions(database);
    } finally {
      _isConsumingActions = false;
    }
  }

  static Future<int> _consumePendingActions(AppDatabase database) async {
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
    final consumedKeys = <String>{};
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
      consumedKeys.add(_actionKey(item));
      imported++;
    }

    if (imported > 0) {
      final latestRaw = await HomeWidget.getWidgetData<String>(
        'pendingActions',
        defaultValue: '[]',
      );
      dynamic latest;
      try {
        latest = latestRaw == null ? null : jsonDecode(latestRaw);
      } on FormatException {
        latest = null;
      }
      if (latest is List) {
        final remaining = latest
            .where(
              (item) =>
                  item is! Map || !consumedKeys.contains(_actionKey(item)),
            )
            .toList();
        await HomeWidget.saveWidgetData<String>(
          'pendingActions',
          jsonEncode(remaining),
        );
      }
    }

    return imported;
  }

  static String _actionKey(Map<dynamic, dynamic> item) {
    final id = item['id'];
    if (id is String && id.isNotEmpty) return id;
    return '${item['amount']}|${item['timestamp']}';
  }
}
