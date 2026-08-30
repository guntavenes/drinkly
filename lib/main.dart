import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/drinkly_app.dart';
import 'core/notifications/notification_service.dart';
import 'core/database/app_database.dart';
import 'core/widget/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.initialize();
  await WidgetService.initialize();

  final database = AppDatabase();
  await WidgetService.consumePendingActions(database);
  await database.close();

  runApp(const ProviderScope(child: DrinklyApp()));
}
