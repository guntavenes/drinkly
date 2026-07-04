import 'package:drinkly/features/statistics/data/providers/insight_providers.dart';
import 'package:drinkly/features/statistics/data/providers/statistics_data_providers.dart';
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
    final chartValues = ref.watch(statisticsChartValuesProvider);
    final total = ref.watch(statisticsTotalProvider);
    final average = ref.watch(statisticsAverageProvider);
    final bestValue = ref.watch(statisticsBestValueProvider);
    final currentStreak = ref.watch(currentStreakProvider);
    final averageAmount = ref.watch(averageDrinkAmountProvider);
    final favoriteAmount = ref.watch(favoriteDrinkAmountProvider);
    final period = ref.watch(statisticsPeriodProvider);
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
