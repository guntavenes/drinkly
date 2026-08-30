import 'package:drinkly/shared/widgets/app_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        const SectionHeader(title: 'Today\'s activity'),
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    return AppListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.water_drop_rounded, color: primaryColor, size: 21),
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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE9EEF5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.water_drop_outlined, color: primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your day starts here',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Add your first drink with a quick tap.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
