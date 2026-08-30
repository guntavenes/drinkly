import 'package:drinkly/core/utils/formatters.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_style.dart';

class TodayHydrationCard extends StatelessWidget {
  const TodayHydrationCard({
    super.key,
    required this.currentAmount,
    required this.dailyGoal,
    required this.onEditGoal,
  });

  final int currentAmount;
  final int dailyGoal;
  final VoidCallback onEditGoal;

  @override
  Widget build(BuildContext context) {
    final themeStyle = Theme.of(context).extension<DrinklyTheme>()!.style;
    final progress = dailyGoal <= 0
        ? 0.0
        : (currentAmount / dailyGoal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final remaining = (dailyGoal - currentAmount).clamp(0, dailyGoal);

    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeStyle.heroGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: themeStyle.primary.withValues(alpha: .28),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .17),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.water_drop_rounded, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'TODAY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onEditGoal,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.tune_rounded, size: 16),
                    label: const Text(
                      'Goal',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You have consumed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xD9FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: Formatters.formatAmount(currentAmount),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.8,
                                  height: 1,
                                ),
                              ),
                              const TextSpan(
                                text: ' ml',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          remaining == 0
                              ? 'Daily goal completed — great work!'
                              : '${Formatters.formatAmount(remaining)} ml remaining today',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xD9FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 104,
                    height: 104,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 9,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.white.withValues(
                              alpha: .18,
                            ),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.6,
                              ),
                            ),
                            const Text(
                              'of goal',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xCCFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .14),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flag_rounded, size: 17),
                    const SizedBox(width: 8),
                    const Text(
                      'Daily goal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${Formatters.formatAmount(dailyGoal)} ml',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
