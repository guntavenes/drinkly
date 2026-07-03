import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/primary_progress_bar.dart';

class TodayHydrationCard extends StatelessWidget {
  const TodayHydrationCard({
    super.key,
    required this.currentAmount,
    required this.dailyGoal,
    required this.onEditGoal,
  });

  final int currentAmount;
  final int dailyGoal;
  final VoidCallback onEditGoal;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    final progress = (currentAmount / dailyGoal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final remaining = (dailyGoal - currentAmount).clamp(0, dailyGoal);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEditGoal,
                child: Text(
                  'Edit Goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(currentAmount),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -1.4,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'ml',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF8E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF22A447),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'of ${_formatAmount(dailyGoal)} ml',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 18),
          PrimaryProgressBar(value: progress),
          const SizedBox(height: 18),
          Row(
            children: [
              _MiniMetric(
                icon: Icons.water_drop_outlined,
                title: '${_formatAmount(remaining)} ml',
                subtitle: 'left to reach your goal',
              ),
              const Spacer(),
              _MiniMetric(
                icon: Icons.flag_rounded,
                title: '${_formatAmount(dailyGoal)} ml',
                subtitle: 'Daily Goal',
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatAmount(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.alignEnd = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Row(
      textDirection: alignEnd ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: alignEnd
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
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
      ],
    );
  }
}
