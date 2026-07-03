import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrimaryProgressBar extends StatelessWidget {
  const PrimaryProgressBar({super.key, required this.value, this.height = 12});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: safeValue),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: animatedValue,
            minHeight: height,
            backgroundColor: isDark
                ? const Color(0xFF334155)
                : AppColors.primary.withValues(alpha: .10),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        );
      },
    );
  }
}
