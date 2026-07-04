import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/providers/achievement_providers.dart';
import '../../domain/models/achievement_model.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final unlockedCount = achievements.where((item) => item.unlocked).length;

    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);
    final progress = achievements.isEmpty
        ? 0.0
        : unlockedCount / achievements.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: -.08),
              const SizedBox(height: 28),
              _OverallProgressCard(
                unlockedCount: unlockedCount,
                totalCount: achievements.length,
                progress: progress,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .08),
              const SizedBox(height: 24),
              Text(
                'All Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < achievements.length; i++) ...[
                _AchievementTile(
                      data: achievements[i],
                      secondaryTextColor: secondaryTextColor,
                    )
                    .animate(delay: (70 * i).ms)
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: .08),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard({
    required this.unlockedCount,
    required this.totalCount,
    required this.progress,
  });

  final int unlockedCount;
  final int totalCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '$unlockedCount / $totalCount unlocked',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: AppColors.primary.withValues(alpha: .10),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Keep unlocking healthy hydration habits.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.data,
    required this.secondaryTextColor,
  });

  final AchievementModel data;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    final color = data.unlocked
        ? AppColors.primary
        : secondaryTextColor.withValues(alpha: .55);

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AnimatedScale(
            scale: data.unlocked ? 1.0 : .94,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: data.unlocked ? .14 : .10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.unlocked ? data.icon : Icons.lock_rounded,
                color: color,
                size: 27,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: data.unlocked ? textColor : secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.progressText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              data.unlocked
                  ? Icons.check_circle_rounded
                  : Icons.lock_outline_rounded,
              key: ValueKey(data.unlocked),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
