import 'package:drinkly/core/utils/formatters.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class OverviewGrid extends StatelessWidget {
  const OverviewGrid({
    super.key,
    required this.weeklyTotal,
    required this.dailyAverage,
    required this.bestDay,
    required this.currentStreak,
  });

  final int weeklyTotal;
  final double dailyAverage;
  final int bestDay;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            OverviewCard(
              icon: Icons.water_drop_outlined,
              title: Formatters.formatVolume(weeklyTotal),
              subtitle: 'This Week',
            ),
            const SizedBox(width: 12),
            OverviewCard(
              icon: Icons.show_chart_rounded,
              title: Formatters.formatVolume(dailyAverage.round()),
              subtitle: 'Week Average',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OverviewCard(
              icon: Icons.emoji_events_outlined,
              title: Formatters.formatVolume(bestDay),
              subtitle: 'Best Day',
            ),
            const SizedBox(width: 12),
            OverviewCard(
              icon: Icons.local_fire_department_rounded,
              title: '$currentStreak days',
              subtitle: 'Current Streak',
            ),
          ],
        ),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 22,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
