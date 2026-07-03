import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class InsightsCard extends StatelessWidget {
  const InsightsCard({
    super.key,
    required this.averageAmount,
    required this.favoriteAmount,
  });

  final int averageAmount;
  final int favoriteAmount;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 18),
          _InsightRow(
            icon: Icons.local_drink_outlined,
            title: 'Average Drink',
            value: averageAmount == 0 ? '-' : '$averageAmount ml',
          ),
          const SizedBox(height: 16),
          _InsightRow(
            icon: Icons.favorite_rounded,
            title: 'Favorite Amount',
            value: favoriteAmount == 0 ? '-' : '$favoriteAmount ml',
          ),
          const SizedBox(height: 16),
          _InsightRow(
            icon: Icons.psychology_alt_outlined,
            title: 'Consistency',
            value: averageAmount > 0 ? 'Building habit' : 'No data yet',
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w800, color: textColor),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
