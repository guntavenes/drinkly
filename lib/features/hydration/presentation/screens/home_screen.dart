import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const int dailyGoal = 2500;
  static const int currentAmount = 0;

  @override
  Widget build(BuildContext context) {
    final progress = currentAmount / dailyGoal;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF7FF), AppColors.lightBackground],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Drinkly',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bugün su hedefine birlikte ulaşalım 💧',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        width: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 180,
                              width: 180,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 16,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.10,
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '💧',
                                  style: TextStyle(fontSize: 36),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$currentAmount ml',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.lightText,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Günlük hedef: 2500 ml',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                const Text(
                  'Hızlı ekle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: const [
                    _QuickAddButton(amount: 250),
                    SizedBox(width: 12),
                    _QuickAddButton(amount: 330),
                    SizedBox(width: 12),
                    _QuickAddButton(amount: 500),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Center(
          child: Text(
            '+$amount\nml',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
