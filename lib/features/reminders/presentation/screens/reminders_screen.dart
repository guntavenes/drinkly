import 'package:drinkly/features/reminders/application/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../settings/data/providers/settings_providers.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    final remindersEnabled = settingsAsync.maybeWhen(
      data: (settings) => settings?.remindersEnabled ?? false,
      orElse: () => false,
    );

    final startHour = settingsAsync.maybeWhen(
      data: (settings) => settings?.reminderStartHour ?? 8,
      orElse: () => 8,
    );

    final startMinute = settingsAsync.maybeWhen(
      data: (settings) => settings?.reminderStartMinute ?? 0,
      orElse: () => 0,
    );

    final endHour = settingsAsync.maybeWhen(
      data: (settings) => settings?.reminderEndHour ?? 22,
      orElse: () => 22,
    );

    final endMinute = settingsAsync.maybeWhen(
      data: (settings) => settings?.reminderEndMinute ?? 0,
      orElse: () => 0,
    );

    final intervalMinutes = settingsAsync.maybeWhen(
      data: (settings) => settings?.reminderIntervalMinutes ?? 120,
      orElse: () => 120,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _RemindersHeader(onBack: () => Navigator.pop(context)),
              const SizedBox(height: 28),
              GlassCard(
                padding: EdgeInsets.zero,
                borderRadius: 24,
                child: Column(
                  children: [
                    _ReminderSwitchTile(
                      value: remindersEnabled,
                      onChanged: (value) async {
                        await ref
                            .read(notificationControllerProvider)
                            .updateReminder(value);
                      },
                    ),
                    const _Divider(),
                    _ReminderTile(
                      icon: Icons.schedule_rounded,
                      title: 'Start Time',
                      value: _formatTime(startHour, startMinute),
                      onTap: () =>
                          _pickStartTime(context, ref, startHour, startMinute),
                    ),
                    const _Divider(),
                    _ReminderTile(
                      icon: Icons.nights_stay_outlined,
                      title: 'End Time',
                      value: _formatTime(endHour, endMinute),
                      onTap: () =>
                          _pickEndTime(context, ref, endHour, endMinute),
                    ),
                    const _Divider(),
                    _ReminderTile(
                      icon: Icons.repeat_rounded,
                      title: 'Repeat',
                      value: _intervalText(intervalMinutes),
                      onTap: () =>
                          _showIntervalSheet(context, ref, intervalMinutes),
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

  static String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _intervalText(int minutes) {
    if (minutes == 30) return 'Every 30 min';
    if (minutes == 60) return 'Every 1 hour';
    return 'Every ${minutes ~/ 60} hours';
  }

  Future<void> _pickStartTime(
    BuildContext context,
    WidgetRef ref,
    int hour,
    int minute,
  ) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (selected == null) return;

    final repository = ref.read(settingsRepositoryProvider);
    await repository.updateReminderStartTime(
      hour: selected.hour,
      minute: selected.minute,
    );

    await ref.read(notificationControllerProvider).refreshSchedule();
  }

  Future<void> _pickEndTime(
    BuildContext context,
    WidgetRef ref,
    int hour,
    int minute,
  ) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (selected == null) return;

    final repository = ref.read(settingsRepositoryProvider);
    await repository.updateReminderEndTime(
      hour: selected.hour,
      minute: selected.minute,
    );

    await ref.read(notificationControllerProvider).refreshSchedule();
  }

  void _showIntervalSheet(
    BuildContext context,
    WidgetRef ref,
    int currentInterval,
  ) {
    final intervals = [30, 60, 120, 180, 240];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final textColor = Theme.of(sheetContext).colorScheme.onSurface;
        final cardColor = Theme.of(sheetContext).cardColor;
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;

        return Material(
          color: cardColor,
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
                  'Repeat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                for (final interval in intervals)
                  InkWell(
                    onTap: () async {
                      final repository = ref.read(settingsRepositoryProvider);
                      await repository.updateReminderInterval(interval);

                      await ref
                          .read(notificationControllerProvider)
                          .refreshSchedule();

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
                            Icons.repeat_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _intervalText(interval),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (interval == currentInterval)
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

class _ReminderSwitchTile extends StatelessWidget {
  const _ReminderSwitchTile({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'Enable Reminders',
              style: TextStyle(fontWeight: FontWeight.w800, color: textColor),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

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
            Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
          ],
        ),
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

class _RemindersHeader extends StatelessWidget {
  const _RemindersHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onBack,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reminders',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Stay hydrated every day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
