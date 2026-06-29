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

final weeklyHydrationEntriesProvider = StreamProvider<List<HydrationEntry>>((
  ref,
) {
  final repository = ref.watch(hydrationRepositoryProvider);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  return repository.watchEntriesBetween(start: startOfWeek, end: endOfWeek);
});

final weeklyHydrationTotalsProvider = Provider<List<int>>((ref) {
  final entriesAsync = ref.watch(weeklyHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      final totals = List<int>.filled(7, 0);

      for (final entry in entries) {
        final index = entry.createdAt.weekday - 1;

        if (index >= 0 && index < 7) {
          totals[index] += entry.amount;
        }
      }

      return totals;
    },
    orElse: () => List<int>.filled(7, 0),
  );
});

final weeklyHydrationTotalProvider = Provider<int>((ref) {
  final totals = ref.watch(weeklyHydrationTotalsProvider);
  return totals.fold<int>(0, (sum, value) => sum + value);
});

final weeklyHydrationAverageProvider = Provider<double>((ref) {
  final totals = ref.watch(weeklyHydrationTotalsProvider);

  final weeklyTotal = totals.fold<int>(0, (sum, value) => sum + value);

  return weeklyTotal / 7;
});

final weeklyHydrationBestDayProvider = Provider<int>((ref) {
  final totals = ref.watch(weeklyHydrationTotalsProvider);

  if (totals.isEmpty) {
    return 0;
  }

  return totals.reduce((a, b) => a > b ? a : b);
});
