import 'package:drinkly/shared/widgets/app_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../data/providers/hydration_providers.dart';
import '../../domain/models/hydration_entry_model.dart';

class TodayActivitySection extends ConsumerWidget {
  const TodayActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(todayHydrationEntriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Today\'s Activity', actionText: 'View All'),
        const SizedBox(height: 16),
        entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return const _EmptyActivity();
            }

            return Column(
              children: [
                for (final entry in entries.take(3)) ...[
                  _ActivityEntryTile(entry: entry),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => Text(
            'Something went wrong: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class _ActivityEntryTile extends StatelessWidget {
  const _ActivityEntryTile({required this.entry});

  final HydrationEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: const Icon(
        Icons.local_drink_outlined,
        color: AppColors.primary,
        size: 28,
      ),
      title: entry.amountText,
      subtitle: 'Water',
      trailing: entry.timeText,
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : AppColors.primary.withValues(alpha: .08),
        ),
      ),
      child: Text(
        'No water added yet. Start with a quick add.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: secondaryTextColor,
        ),
      ),
    );
  }
}
