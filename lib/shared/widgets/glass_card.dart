import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).cardColor
            : Colors.white.withValues(alpha: .92),

        borderRadius: BorderRadius.circular(borderRadius),

        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : Colors.white.withValues(alpha: .85),
        ),

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: .35)
                : AppColors.primary.withValues(alpha: .10),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}
