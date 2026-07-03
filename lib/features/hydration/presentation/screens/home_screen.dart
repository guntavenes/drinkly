import 'package:confetti/confetti.dart';
import 'package:drinkly/features/settings/data/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/providers/hydration_providers.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_add_section.dart';
import '../widgets/today_activity_section.dart';
import '../widgets/today_hydration_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentAmount = ref.watch(todayHydrationTotalProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final quickAddAmounts = ref.watch(smartQuickAddAmountsProvider);

    final dailyGoal = settingsAsync.maybeWhen(
      data: (settings) => settings?.dailyGoal ?? 2500,
      orElse: () => 2500,
    );

    final progress = dailyGoal == 0 ? 0.0 : currentAmount / dailyGoal;

    final lastCelebratedDate = settingsAsync.maybeWhen(
      data: (settings) => settings?.lastCelebratedDate,
      orElse: () => null,
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final alreadyCelebratedToday =
        lastCelebratedDate != null &&
        lastCelebratedDate.year == today.year &&
        lastCelebratedDate.month == today.month &&
        lastCelebratedDate.day == today.day;

    if (progress >= 1 && !alreadyCelebratedToday) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final repository = ref.read(settingsRepositoryProvider);
        await repository.updateLastCelebratedDate(today);

        _confettiController.play();

        if (!context.mounted) return;

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('🎉 Amazing!'),
              content: const Text('You reached today\'s hydration goal!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Awesome!'),
                ),
              ],
            );
          },
        );
      });
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? const [Color(0xFF0F172A), Color(0xFF020617)]
                    : const [Color(0xFFEAF7FF), AppColors.lightBackground],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GreetingHeader(),
                    const SizedBox(height: 28),
                    TodayHydrationCard(
                      currentAmount: currentAmount,
                      dailyGoal: dailyGoal,
                      onEditGoal: () {
                        _showEditGoalSheet(context, ref, dailyGoal);
                      },
                    ),
                    const SizedBox(height: 28),
                    QuickAddSection(
                      amounts: quickAddAmounts,
                      onAddWater: (amount) async {
                        await HapticFeedback.lightImpact();

                        final repository = ref.read(
                          hydrationRepositoryProvider,
                        );

                        await repository.addWater(amount: amount);
                      },
                    ),
                    const SizedBox(height: 28),
                    const TodayActivitySection(),
                  ],
                ),
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
        ],
      ),
    );
  }

  void _showEditGoalSheet(
    BuildContext context,
    WidgetRef ref,
    int currentGoal,
  ) {
    final goals = [2000, 2500, 3000, 3500, 4000];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Daily Goal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 20),
                for (final goal in goals)
                  ListTile(
                    onTap: () async {
                      final repository = ref.read(settingsRepositoryProvider);

                      await repository.updateDailyGoal(goal);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    leading: const Icon(
                      Icons.flag_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      '$goal ml',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightText,
                      ),
                    ),
                    trailing: goal == currentGoal
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
