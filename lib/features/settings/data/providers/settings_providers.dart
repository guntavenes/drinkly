import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return SettingsRepository(database);
});

final settingsProvider = StreamProvider((ref) {
  final repository = ref.watch(settingsRepositoryProvider);

  repository.initialize();

  return repository.watchSettings();
});
