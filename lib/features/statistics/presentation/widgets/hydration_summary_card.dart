import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class HydrationSummaryCard extends StatelessWidget {
  const HydrationSummaryCard({super.key, required this.weeklyTotal});

  final int weeklyTotal;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);
    final liters = (weeklyTotal / 1000).toStringAsFixed(1);

    return GlassCard(
      borderRadius: 30,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$liters L',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text(
                'Keep it up!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
