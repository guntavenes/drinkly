import 'package:drinkly/features/statistics/data/providers/insight_providers.dart';
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
    final weeklyTotals = ref.watch(weeklyHydrationTotalsProvider);
    final weeklyTotal = ref.watch(weeklyHydrationTotalProvider);
    final weeklyAverage = ref.watch(weeklyHydrationAverageProvider);
    final bestDay = ref.watch(weeklyHydrationBestDayProvider);
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
              const SizedBox(height: 24),
              HydrationSummaryCard(weeklyTotal: weeklyTotal),
              const SizedBox(height: 24),
              OverviewGrid(
                weeklyTotal: weeklyTotal,
                dailyAverage: weeklyAverage,
                bestDay: bestDay,
                currentStreak: currentStreak,
              ),
              const SizedBox(height: 24),
              WeeklyChartCard(values: weeklyTotals),
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
}
