import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int dailyGoal = 2500;

  int currentAmount = 0;

  void addWater(int amount) {
    setState(() {
      currentAmount += amount;

      if (currentAmount > dailyGoal) {
        currentAmount = dailyGoal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentAmount / dailyGoal;
    final percent = (progress * 100).round();

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
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 16,
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: 0.10),
                                    strokeCap: StrokeCap.round,
                                  ),
                                );
                              },
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
                                  '$percent%',
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
                      Text(
                        'Günlük hedef: $dailyGoal ml',
                        style: const TextStyle(
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
                  children: [
                    _QuickAddButton(
                      amount: 250,
                      icon: '🥛',
                      onTap: () => addWater(250),
                    ),
                    const SizedBox(width: 12),
                    _QuickAddButton(
                      amount: 330,
                      icon: '🧃',
                      onTap: () => addWater(330),
                    ),
                    const SizedBox(width: 12),
                    _QuickAddButton(
                      amount: 500,
                      icon: '🍶',
                      onTap: () => addWater(500),
                    ),
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
  const _QuickAddButton({
    required this.amount,
    required this.icon,
    required this.onTap,
  });

  final int amount;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  '+$amount ml',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
