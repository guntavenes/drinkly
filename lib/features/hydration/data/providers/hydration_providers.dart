import 'package:drinkly/features/settings/data/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/database/database_provider.dart';
import '../../domain/models/hydration_entry_model.dart';
import '../repositories/hydration_repository.dart';

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return HydrationRepository(database);
});

final todayHydrationEntriesProvider = StreamProvider<List<HydrationEntryModel>>(
  (ref) {
    final repository = ref.watch(hydrationRepositoryProvider);
    return repository.watchTodayEntries();
  },
);

final allHydrationEntriesProvider = StreamProvider<List<HydrationEntryModel>>((
  ref,
) {
  final repository = ref.watch(hydrationRepositoryProvider);
  return repository.watchAllEntries();
});

final weeklyHydrationEntriesProvider =
    StreamProvider<List<HydrationEntryModel>>((ref) {
      final repository = ref.watch(hydrationRepositoryProvider);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      return repository.watchEntriesBetween(start: startOfWeek, end: endOfWeek);
    });

final dailyGoalProvider = StateProvider<int>((ref) => 2500);

final todayHydrationTotalProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(todayHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      return entries.fold<int>(0, (total, entry) => total + entry.amount);
    },
    orElse: () => 0,
  );
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
  final weeklyTotal = ref.watch(weeklyHydrationTotalProvider);
  return weeklyTotal / 7;
});

final weeklyHydrationBestDayProvider = Provider<int>((ref) {
  final totals = ref.watch(weeklyHydrationTotalsProvider);

  if (totals.isEmpty) {
    return 0;
  }

  return totals.reduce((a, b) => a > b ? a : b);
});

final currentStreakProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(allHydrationEntriesProvider);
  final settingsAsync = ref.watch(settingsProvider);

  final dailyGoal = settingsAsync.maybeWhen(
    data: (settings) => settings?.dailyGoal ?? 2500,
    orElse: () => 2500,
  );

  return entriesAsync.maybeWhen(
    data: (entries) {
      if (entries.isEmpty) return 0;

      final totalsByDay = <DateTime, int>{};

      for (final entry in entries) {
        final day = DateTime(
          entry.createdAt.year,
          entry.createdAt.month,
          entry.createdAt.day,
        );

        totalsByDay[day] = (totalsByDay[day] ?? 0) + entry.amount;
      }

      var streak = 0;
      var cursor = DateTime.now();

      cursor = DateTime(cursor.year, cursor.month, cursor.day);

      final todayTotal = totalsByDay[cursor] ?? 0;

      if (todayTotal < dailyGoal) {
        cursor = cursor.subtract(const Duration(days: 1));
      }

      while (true) {
        final total = totalsByDay[cursor] ?? 0;

        if (total < dailyGoal) {
          break;
        }

        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      }

      return streak;
    },
    orElse: () => 0,
  );
});

final smartQuickAddAmountsProvider = Provider<List<int>>((ref) {
  final entriesAsync = ref.watch(allHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      if (entries.isEmpty) {
        return [250, 500, 750];
      }

      final counter = <int, int>{};

      for (final entry in entries) {
        counter[entry.amount] = (counter[entry.amount] ?? 0) + 1;
      }

      final sorted = counter.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final amounts = sorted.map((entry) => entry.key).take(3).toList();

      while (amounts.length < 3) {
        for (final fallback in [250, 500, 750]) {
          if (!amounts.contains(fallback)) {
            amounts.add(fallback);
          }

          if (amounts.length == 3) break;
        }
      }

      return amounts;
    },
    orElse: () => [250, 500, 750],
  );
});
