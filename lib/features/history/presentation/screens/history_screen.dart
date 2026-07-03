import 'package:drinkly/shared/widgets/app_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../hydration/data/providers/hydration_providers.dart';
import '../../../hydration/domain/models/hydration_entry_model.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allHydrationEntriesProvider);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return _EmptyHistory(secondaryTextColor: secondaryTextColor);
              }

              final groupedEntries = _groupEntriesByDay(entries);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (final group in groupedEntries.entries) ...[
                    SectionHeader(title: group.key),
                    const SizedBox(height: 14),
                    for (final entry in group.value) ...[
                      Dismissible(
                        key: ValueKey(entry.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) async {
                          final repository = ref.read(
                            hydrationRepositoryProvider,
                          );

                          await repository.deleteEntry(entry.id);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Entry deleted')),
                            );
                          }
                        },
                        child: _HistoryEntryTile(entry: entry),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 16),
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
        ),
      ),
    );
  }

  Map<String, List<HydrationEntryModel>> _groupEntriesByDay(
    List<HydrationEntryModel> entries,
  ) {
    final grouped = <String, List<HydrationEntryModel>>{};

    for (final entry in entries) {
      final key = _dayLabel(entry.createdAt);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(entry);
    }

    return grouped;
  }

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return 'Today';

    if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    return '${date.day}.${date.month}.${date.year}';
  }
}

class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({required this.entry});

  final HydrationEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: const Icon(
        Icons.water_drop_outlined,
        color: AppColors.primary,
        size: 28,
      ),
      title: entry.amountText,
      subtitle: 'Water',
      trailing: entry.timeText,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.secondaryTextColor});

  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Text(
          'No history yet.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
