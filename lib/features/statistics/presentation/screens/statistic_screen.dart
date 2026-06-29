import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
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

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const PeriodSelector(),
              const SizedBox(height: 28),
              WeeklyChartCard(values: weeklyTotals),
              const SizedBox(height: 24),
              OverviewGrid(
                weeklyTotal: weeklyTotal,
                dailyAverage: weeklyAverage,
                bestDay: bestDay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
