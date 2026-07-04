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

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.35,
              ),
            ),
          ),
          Text(
            progress >= 1 ? 'Done' : '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: progress >= 1 ? AppColors.primary : secondaryTextColor,
            ),
          ),
        ],
      ),
    );
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
