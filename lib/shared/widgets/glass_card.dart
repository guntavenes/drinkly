import 'package:flutter/material.dart';

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
            ? Theme.of(context).cardColor.withValues(alpha: .94)
            : Colors.white.withValues(alpha: .96),

        borderRadius: BorderRadius.circular(borderRadius),

        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .07)
              : const Color(0xFFE9EEF5),
        ),

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: .24)
                : const Color(0xFF102A43).withValues(alpha: .07),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}
