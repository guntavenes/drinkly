import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class SmartStatusCard extends StatelessWidget {
  const SmartStatusCard({
    super.key,
    required this.currentAmount,
    required this.dailyGoal,
  });

  final int currentAmount;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    final remaining = (dailyGoal - currentAmount).clamp(0, dailyGoal);
    final progress = dailyGoal == 0 ? 0.0 : currentAmount / dailyGoal;

    final message = _message(progress, remaining);
    final icon = _icon(progress);
    final accentColor = _accentColor(
      progress,
      Theme.of(context).colorScheme.primary,
    );

    return GlassCard(
      borderRadius: 26,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: .18),
                  accentColor.withValues(alpha: .07),
                ],
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progress >= 1 ? 'DAILY GOAL' : 'SMART INSIGHT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              progress >= 1 ? 'Done' : '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: progress >= 1 ? accentColor : secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _accentColor(double progress, Color primaryColor) {
    if (progress >= 1) return AppColors.success;
    if (progress >= .75) return const Color(0xFFFF8A3D);
    if (progress >= .4) return primaryColor;
    return AppColors.accent;
  }

  IconData _icon(double progress) {
    if (progress >= 1) return Icons.celebration_rounded;
    if (progress >= .75) return Icons.local_fire_department_rounded;
    if (progress >= .4) return Icons.water_drop_rounded;
    return Icons.lightbulb_outline_rounded;
  }

  String _message(double progress, int remaining) {
    if (progress >= 1) {
      return 'Today\'s goal completed. Amazing work! 🎉';
    }

    if (progress >= .75) {
      return 'Almost there! Only $remaining ml left today.';
    }

    if (progress >= .4) {
      return 'Nice progress. Keep sipping through the day.';
    }

    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning! Start your day with some water.';
    }

    if (hour < 18) {
      return 'A small water break would be perfect now.';
    }

    return 'Don\'t forget your evening hydration.';
  }
}
