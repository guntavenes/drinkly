import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hydration/data/providers/hydration_providers.dart';
import '../../../hydration/domain/models/hydration_entry_model.dart';
import '../../domain/models/statistics_period.dart';
import 'statistics_providers.dart';

final statisticsChartValuesProvider = Provider<List<int>>((ref) {
  final period = ref.watch(statisticsPeriodProvider);
  final entriesAsync = ref.watch(allHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) => calculateStatisticsChartValues(
      entries: entries,
      period: period,
      now: DateTime.now(),
    ),
    orElse: () => [],
  );
});

List<int> calculateStatisticsChartValues({
  required List<HydrationEntryModel> entries,
  required StatisticsPeriod period,
  required DateTime now,
}) {
  switch (period) {
    case StatisticsPeriod.week:
      final today = DateTime(now.year, now.month, now.day);
      final start = today.subtract(Duration(days: today.weekday - 1));
      final values = List<int>.filled(7, 0);

      for (final entry in entries) {
        final day = DateTime(
          entry.createdAt.year,
          entry.createdAt.month,
          entry.createdAt.day,
        );
        final index = day.difference(start).inDays;

        if (index >= 0 && index < values.length) {
          values[index] += entry.amount;
        }
      }

      return values;

    case StatisticsPeriod.month:
      // Five buckets are required because days 29–31 belong to a fifth week.
      final values = List<int>.filled(5, 0);

      for (final entry in entries) {
        if (entry.createdAt.year == now.year &&
            entry.createdAt.month == now.month) {
          final weekIndex = (entry.createdAt.day - 1) ~/ 7;
          values[weekIndex] += entry.amount;
        }
      }

      return values;

    case StatisticsPeriod.year:
      final values = List<int>.filled(12, 0);

      for (final entry in entries) {
        if (entry.createdAt.year == now.year) {
          values[entry.createdAt.month - 1] += entry.amount;
        }
      }

      return values;
  }
}

final statisticsTotalProvider = Provider<int>((ref) {
  final values = ref.watch(statisticsChartValuesProvider);
  return values.fold<int>(0, (sum, value) => sum + value);
});

final statisticsAverageProvider = Provider<double>((ref) {
  final values = ref.watch(statisticsChartValuesProvider);
  if (values.isEmpty) return 0;

  return values.fold<int>(0, (sum, value) => sum + value) / values.length;
});

final statisticsBestValueProvider = Provider<int>((ref) {
  final values = ref.watch(statisticsChartValuesProvider);
  if (values.isEmpty) return 0;

  return values.reduce((a, b) => a > b ? a : b);
});
