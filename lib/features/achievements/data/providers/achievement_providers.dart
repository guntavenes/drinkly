import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hydration/data/providers/hydration_providers.dart';
import '../../domain/models/achievement_model.dart';

final achievementsProvider = Provider<List<AchievementModel>>((ref) {
  final weeklyTotal = ref.watch(weeklyHydrationTotalProvider);
  final currentStreak = ref.watch(currentStreakProvider);

  return [
    AchievementModel(
      icon: Icons.water_drop_rounded,
      title: 'First Sip',
      subtitle: 'Add your first water entry',
      progressText: weeklyTotal > 0 ? 'Completed' : '0 / 1',
      unlocked: weeklyTotal > 0,
    ),
    AchievementModel(
      icon: Icons.local_fire_department_rounded,
      title: '3 Day Streak',
      subtitle: 'Reach your goal 3 days in a row',
      progressText: '$currentStreak / 3 days',
      unlocked: currentStreak >= 3,
    ),
    AchievementModel(
      icon: Icons.emoji_events_rounded,
      title: '10 Liters',
      subtitle: 'Drink 10 liters in a week',
      progressText: '${(weeklyTotal / 1000).toStringAsFixed(1)} / 10 L',
      unlocked: weeklyTotal >= 10000,
    ),
    const AchievementModel(
      icon: Icons.workspace_premium_rounded,
      title: 'Hydration Hero',
      subtitle: 'Reach 50 liters total',
      progressText: 'Coming soon',
      unlocked: false,
    ),
  ];
});

final unlockedAchievementsCountProvider = Provider<int>((ref) {
  final achievements = ref.watch(achievementsProvider);
  return achievements.where((item) => item.unlocked).length;
});

final totalAchievementsCountProvider = Provider<int>((ref) {
  final achievements = ref.watch(achievementsProvider);
  return achievements.length;
});
