import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme_style.dart';

class ThemedScreenBackground extends StatelessWidget {
  const ThemedScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DrinklyTheme>()!.style;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(AppColors.darkBackground, style.primary, .11)!,
                  AppColors.darkBackground,
                ]
              : [
                  Color.lerp(Colors.white, style.primary, .075)!,
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -110,
            right: -80,
            child: _Glow(color: style.secondary),
          ),
          Positioned(
            top: 430,
            left: -120,
            child: _Glow(color: style.primary, size: 240),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, this.size = 220});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: .12), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
