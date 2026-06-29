import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/providers/hydration_providers.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_add_section.dart';
import '../widgets/today_activity_section.dart';
import '../widgets/today_hydration_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAmount = ref.watch(todayHydrationTotalProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);

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
                    _showEditGoalSheet(context, ref);
                  },
                ),
                const SizedBox(height: 28),
                QuickAddSection(
                  onAddWater: (amount) async {
                    final repository = ref.read(hydrationRepositoryProvider);
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
    );
  }
}

void _showEditGoalSheet(BuildContext context, WidgetRef ref) {
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
                  onTap: () {
                    ref.read(dailyGoalProvider.notifier).state = goal;
                    Navigator.pop(context);
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
                  trailing: goal == ref.read(dailyGoalProvider)
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
