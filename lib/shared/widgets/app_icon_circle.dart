import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppIconCircle extends StatelessWidget {
  const AppIconCircle({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: .12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
      ),
    );
  }
}
