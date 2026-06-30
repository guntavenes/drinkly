import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final dailyGoal = settingsAsync.maybeWhen(
      data: (settings) => settings?.dailyGoal ?? 2500,

      orElse: () => 2500,
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: 28),
              const _ProfileCard(),
              const SizedBox(height: 20),
              _SettingsGroup(
                dailyGoal: dailyGoal,
                onDailyGoalTap: () {
                  _showDailyGoalSheet(context, ref, dailyGoal);
                },
              ),
              const SizedBox(height: 20),
              const _AboutGroup(),
            ],
          ),
        ),
      ),
    );
  }
}

void _showDailyGoalSheet(BuildContext context, WidgetRef ref, int currentGoal) {
  final goals = [1500, 2000, 2500, 3000, 3500, 4000];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Padding(
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
                InkWell(
                  onTap: () async {
                    final repository = ref.read(settingsRepositoryProvider);
                    await repository.updateDailyGoal(goal);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flag_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '$goal ml',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                        if (goal == currentGoal)
                          const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drinkly',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Stay hydrated every day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.dailyGoal, required this.onDailyGoalTap});

  final int dailyGoal;
  final VoidCallback onDailyGoalTap;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.flag_rounded,
            title: 'Daily Goal',
            value: '$dailyGoal ml',
            onTap: onDailyGoalTap,
          ),
          const _Divider(),
          const _SettingsTile(
            icon: Icons.straighten_rounded,
            title: 'Units',
            value: 'Milliliters',
          ),
          const _Divider(),
          const _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Reminders',
            value: 'Off',
          ),
          const _Divider(),
          const _SettingsSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            value: false,
          ),
        ],
      ),
    );
  }
}

class _AboutGroup extends StatelessWidget {
  const _AboutGroup();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: const [
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            value: '',
          ),
          _Divider(),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Drinkly',
            value: 'v1.0.0',
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightText,
                ),
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.lightText,
              ),
            ),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: AppColors.primary.withValues(alpha: .08),
    );
  }
}
