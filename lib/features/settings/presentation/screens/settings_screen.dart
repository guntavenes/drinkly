import 'package:drinkly/features/profile/presentation/screens/profile_screen.dart';
import 'package:drinkly/features/settings/presentation/screens/hydration_sources_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../reminders/presentation/screens/reminders_screen.dart';
import '../../data/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _privacyUrl =
      'https://guntavenes.github.io/drinkly/privacy.html';

  static const _termsUrl = 'https://guntavenes.github.io/drinkly/terms.html';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final userName = settingsAsync.maybeWhen(
      data: (settings) => settings?.userName ?? 'Drinkly User',
      orElse: () => 'Drinkly User',
    );

    final dailyGoal = settingsAsync.maybeWhen(
      data: (settings) => settings?.dailyGoal ?? 2500,
      orElse: () => 2500,
    );

    final remindersEnabled = settingsAsync.maybeWhen(
      data: (settings) => settings?.remindersEnabled ?? false,
      orElse: () => false,
    );

    final darkMode = settingsAsync.maybeWhen(
      data: (settings) => settings?.darkMode ?? false,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 28),
              _ProfileCard(
                userName: userName,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _SettingsGroup(
                dailyGoal: dailyGoal,
                remindersEnabled: remindersEnabled,
                darkMode: darkMode,
                onDailyGoalTap: () {
                  _showDailyGoalSheet(context, ref, dailyGoal);
                },
                onReminderTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RemindersScreen()),
                  );
                },
                onDarkModeChanged: (value) async {
                  final repository = ref.read(settingsRepositoryProvider);
                  await repository.updateDarkMode(value);
                },
              ),
              const SizedBox(height: 20),
              _AboutGroup(
                onShareTap: () {
                  final box = context.findRenderObject() as RenderBox?;

                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          '💧 I\'m using Drinkly to build a healthier hydration habit.\n\nDownload Drinkly:\nhttps://apps.apple.com/',
                      sharePositionOrigin: box == null
                          ? null
                          : box.localToGlobal(Offset.zero) & box.size,
                    ),
                  );
                },
                onRateTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Available after App Store release'),
                    ),
                  );
                },
                onPrivacyTap: () => _openUrl(_privacyUrl),
                onTermsTap: () => _openUrl(_termsUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showDailyGoalSheet(
    BuildContext context,
    WidgetRef ref,
    int currentGoal,
  ) {
    final goals = [1500, 2000, 2500, 3000, 3500, 4000];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final textColor = Theme.of(sheetContext).colorScheme.onSurface;
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;

        return Material(
          color: Theme.of(sheetContext).cardColor,
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
                    color: isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Daily Goal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                for (final goal in goals)
                  InkWell(
                    onTap: () async {
                      final repository = ref.read(settingsRepositoryProvider);
                      await repository.updateDailyGoal(goal);

                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: textColor,
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
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.userName, required this.onTap});

  final String userName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: GlassCard(
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
                Icons.person_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Drink more. Feel better.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.dailyGoal,
    required this.remindersEnabled,
    required this.darkMode,
    required this.onDailyGoalTap,
    required this.onReminderTap,
    required this.onDarkModeChanged,
  });

  final int dailyGoal;
  final bool remindersEnabled;
  final bool darkMode;
  final VoidCallback onDailyGoalTap;
  final VoidCallback onReminderTap;
  final ValueChanged<bool> onDarkModeChanged;

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
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Reminders',
            value: remindersEnabled ? 'On' : 'Off',
            onTap: onReminderTap,
          ),
          const _Divider(),
          _SettingsSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            value: darkMode,
            onChanged: onDarkModeChanged,
          ),
        ],
      ),
    );
  }
}

class _AboutGroup extends StatelessWidget {
  const _AboutGroup({
    required this.onShareTap,
    required this.onRateTap,
    required this.onPrivacyTap,
    required this.onTermsTap,
  });

  final VoidCallback onShareTap;
  final VoidCallback onRateTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.share_rounded,
            title: 'Share Drinkly',
            value: '',
            onTap: onShareTap,
          ),
          const _Divider(),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            title: 'Rate Drinkly',
            value: '',
            onTap: onRateTap,
          ),
          const _Divider(),
          _SettingsTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            value: '',
            onTap: onPrivacyTap,
          ),
          const _Divider(),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            value: '',
            onTap: onTermsTap,
          ),
          const _Divider(),
          _SettingsTile(
            icon: Icons.menu_book_outlined,
            title: 'Hydration Sources',
            value: '',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HydrationSourcesScreen(),
                ),
              );
            },
          ),
          const _Divider(),
          const _VersionTile(),
        ],
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  const _VersionTile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData
            ? 'v${snapshot.data!.version} (${snapshot.data!.buildNumber})'
            : 'v1.0.0';

        return _SettingsTile(
          icon: Icons.info_outline_rounded,
          title: 'Version',
          value: version,
        );
      },
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
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

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
                style: TextStyle(fontWeight: FontWeight.w800, color: textColor),
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                ),
              ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
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
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w800, color: textColor),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
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
      color: Theme.of(context).dividerColor,
    );
  }
}
