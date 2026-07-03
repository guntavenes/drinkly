import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/providers/statistics_providers.dart';
import '../../domain/models/statistics_period.dart';

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(statisticsPeriodProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : const Color(0xFFEAF2FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          _PeriodItem(
            title: 'Week',
            period: StatisticsPeriod.week,
            selected: selected == StatisticsPeriod.week,
          ),
          _PeriodItem(
            title: 'Month',
            period: StatisticsPeriod.month,
            selected: selected == StatisticsPeriod.month,
          ),
          _PeriodItem(
            title: 'Year',
            period: StatisticsPeriod.year,
            selected: selected == StatisticsPeriod.year,
          ),
        ],
      ),
    );
  }
}

class _PeriodItem extends ConsumerWidget {
  const _PeriodItem({
    required this.title,
    required this.period,
    required this.selected,
  });

  final String title;
  final StatisticsPeriod period;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondary = textColor.withValues(alpha: .60);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(statisticsPeriodProvider.notifier).state = period;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : secondary,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}
