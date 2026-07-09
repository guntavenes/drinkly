import 'package:drinkly/features/hydration/domain/models/hydration_entry_model.dart';
import 'package:drinkly/features/statistics/data/providers/insight_providers.dart';
import 'package:drinkly/features/statistics/data/providers/statistics_providers.dart';
import 'package:drinkly/features/statistics/domain/models/statistics_period.dart';
import 'package:drinkly/features/statistics/presentation/widgets/hydration_summary_card.dart';
import 'package:drinkly/features/statistics/presentation/widgets/insights_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hydration/data/providers/hydration_providers.dart';
import '../widgets/overview_grid.dart';
import '../widgets/period_selector.dart';
import '../widgets/weekly_chart_card.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allHydrationEntriesProvider);
    final period = ref.watch(statisticsPeriodProvider);

    final chartValues = entriesAsync.maybeWhen(
      data: (entries) => _chartValues(entries, period),
      orElse: () => <int>[],
    );

    final total = chartValues.fold<int>(0, (sum, value) => sum + value);

    final average = chartValues.isEmpty ? 0.0 : total / chartValues.length;

    final bestValue = chartValues.isEmpty
        ? 0
        : chartValues.reduce((a, b) => a > b ? a : b);
    final currentStreak = ref.watch(currentStreakProvider);
    final averageAmount = ref.watch(averageDrinkAmountProvider);
    final favoriteAmount = ref.watch(favoriteDrinkAmountProvider);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const PeriodSelector(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _periodLabel(period),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .55),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              HydrationSummaryCard(weeklyTotal: total),
              const SizedBox(height: 24),
              OverviewGrid(
                weeklyTotal: total,
                dailyAverage: average,
                bestDay: bestValue,
                currentStreak: currentStreak,
              ),
              const SizedBox(height: 24),
              WeeklyChartCard(values: chartValues, period: period),
              const SizedBox(height: 24),
              InsightsCard(
                averageAmount: averageAmount,
                favoriteAmount: favoriteAmount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<int> _chartValues(
    List<HydrationEntryModel> entries,
    StatisticsPeriod period,
  ) {
    final now = DateTime.now();

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

          if (index >= 0 && index < 7) {
            values[index] += entry.amount;
          }
        }

        return values;

      case StatisticsPeriod.month:
        final values = List<int>.filled(4, 0);

        for (final entry in entries) {
          if (entry.createdAt.year == now.year &&
              entry.createdAt.month == now.month) {
            final weekIndex = ((entry.createdAt.day - 1) / 7).floor();

            if (weekIndex >= 0 && weekIndex < 4) {
              values[weekIndex] += entry.amount;
            }
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

  String _periodLabel(StatisticsPeriod period) {
    switch (period) {
      case StatisticsPeriod.week:
        return 'Showing this week';
      case StatisticsPeriod.month:
        return 'Month view coming next';
      case StatisticsPeriod.year:
        return 'Year view coming next';
    }
  }
}
