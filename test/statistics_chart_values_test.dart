import 'package:drinkly/features/hydration/domain/models/hydration_entry_model.dart';
import 'package:drinkly/features/statistics/data/providers/statistics_data_providers.dart';
import 'package:drinkly/features/statistics/domain/models/statistics_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('monthly statistics include days 29 through 31', () {
    final entries = [
      HydrationEntryModel(id: 1, amount: 250, createdAt: DateTime(2026, 8, 29)),
      HydrationEntryModel(id: 2, amount: 500, createdAt: DateTime(2026, 8, 31)),
    ];

    final values = calculateStatisticsChartValues(
      entries: entries,
      period: StatisticsPeriod.month,
      now: DateTime(2026, 8, 15),
    );

    expect(values, [0, 0, 0, 0, 750]);
  });

  test('monthly statistics exclude entries from other months', () {
    final entries = [
      HydrationEntryModel(id: 1, amount: 250, createdAt: DateTime(2026, 7, 31)),
    ];

    final values = calculateStatisticsChartValues(
      entries: entries,
      period: StatisticsPeriod.month,
      now: DateTime(2026, 8, 15),
    );

    expect(values, [0, 0, 0, 0, 0]);
  });
}
