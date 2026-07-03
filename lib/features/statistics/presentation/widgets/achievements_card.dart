import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({
    super.key,
    required this.weeklyTotal,
    required this.currentStreak,
  });

  final int weeklyTotal;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _AchievementItem(
        icon: Icons.water_drop_rounded,
        title: 'First Sip',
        subtitle: 'Add your first water entry',
        unlocked: weeklyTotal > 0,
      ),
      _AchievementItem(
        icon: Icons.local_fire_department_rounded,
        title: '3 Day Streak',
        subtitle: 'Reach your goal 3 days in a row',
        unlocked: currentStreak >= 3,
      ),
      _AchievementItem(
        icon: Icons.emoji_events_rounded,
        title: '10 Liters',
        subtitle: 'Drink 10 liters in a week',
        unlocked: weeklyTotal >= 10000,
      ),
    ];

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.lightText,
            ),
          ),
          const SizedBox(height: 16),
          for (final achievement in achievements) ...[
            _AchievementRow(item: achievement),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _AchievementItem {
  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.unlocked,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool unlocked;
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({required this.item});

  final _AchievementItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.unlocked
        ? AppColors.primary
        : AppColors.lightTextSecondary.withValues(alpha: .45);

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.unlocked ? item.icon : Icons.lock_rounded,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: item.unlocked
                      ? AppColors.lightText
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          item.unlocked
              ? Icons.check_circle_rounded
              : Icons.lock_outline_rounded,
          color: color,
          size: 22,
        ),
      ],
    );
  }
}
