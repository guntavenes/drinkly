import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({super.key, required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = values.fold<int>(2500, (max, value) {
      return value > max ? value : max;
    });

    return GlassCard(
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < values.length; i++)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _formatLiter(values[i]),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      height: values[i] == 0
                          ? 12
                          : 150 * (values[i] / maxValue),
                      width: 28,
                      decoration: BoxDecoration(
                        color: i == DateTime.now().weekday - 1
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: .28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      days[i],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextSecondary,
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

  String _formatLiter(int ml) {
    if (ml == 0) return '0L';
    return '${(ml / 1000).toStringAsFixed(1)}L';
  }
}
