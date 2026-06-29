import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../repositories/hydration_repository.dart';

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return HydrationRepository(database);
});

final todayHydrationEntriesProvider = StreamProvider<List<HydrationEntry>>((
  ref,
) {
  final repository = ref.watch(hydrationRepositoryProvider);
  return repository.watchTodayEntries();
});

final todayHydrationTotalProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(todayHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      return entries.fold<int>(0, (total, entry) => total + entry.amount);
    },
    orElse: () => 0,
  );
});

final dailyGoalProvider = StateProvider<int>((ref) => 2500);
