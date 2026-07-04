import 'package:drinkly/core/utils/formatters.dart';
import 'package:drinkly/shared/widgets/app_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../hydration/data/providers/hydration_providers.dart';
import '../../../hydration/domain/models/hydration_entry_model.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  final Set<String> _expandedDays = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(allHydrationEntriesProvider);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);
    final searchText = _searchController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: entriesAsync.when(
            data: (entries) {
              final visibleEntries = _recentEntries(entries);

              final filteredEntries = visibleEntries.where((entry) {
                if (searchText.isEmpty) return true;

                return entry.amountText.toLowerCase().contains(searchText) ||
                    entry.timeText.toLowerCase().contains(searchText) ||
                    _dayLabel(
                      entry.createdAt,
                    ).toLowerCase().contains(searchText);
              }).toList();

              final groupedEntries = _groupEntriesByDay(filteredEntries);

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
                  const SizedBox(height: 24),
                  _TextSearchField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  if (entries.isEmpty)
                    _EmptyHistory(
                      secondaryTextColor: secondaryTextColor,
                      message: 'No history yet.',
                    )
                  else if (filteredEntries.isEmpty)
                    _EmptyHistory(
                      secondaryTextColor: secondaryTextColor,
                      message: 'No matching entries.',
                    )
                  else
                    for (final group in groupedEntries.entries) ...[
                      _DayHistoryCard(
                        title: group.key,
                        entries: group.value,
                        expanded: _expandedDays.contains(group.key),
                        onTap: () {
                          setState(() {
                            if (_expandedDays.contains(group.key)) {
                              _expandedDays.remove(group.key);
                            } else {
                              _expandedDays.add(group.key);
                            }
                          });
                        },
                        onDelete: (entry) async {
                          final repository = ref.read(
                            hydrationRepositoryProvider,
                          );

                          await repository.deleteEntry(entry.id);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Entry deleted'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () async {
                                  await repository.addWater(
                                    amount: entry.amount,
                                    createdAt: entry.createdAt,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
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

  List<HydrationEntryModel> _recentEntries(List<HydrationEntryModel> entries) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = today.subtract(const Duration(days: 6));

    return entries.where((entry) {
      final entryDay = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );

      return !entryDay.isBefore(sevenDaysAgo);
    }).toList();
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

class _TextSearchField extends StatelessWidget {
  const _TextSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          icon: const Icon(Icons.search_rounded, color: AppColors.primary),
          hintText: 'Search history',
          hintStyle: TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _DayHistoryCard extends StatelessWidget {
  const _DayHistoryCard({
    required this.title,
    required this.entries,
    required this.expanded,
    required this.onTap,
    required this.onDelete,
  });

  final String title;
  final List<HydrationEntryModel> entries;
  final bool expanded;
  final VoidCallback onTap;
  final Future<void> Function(HydrationEntryModel entry) onDelete;

  @override
  Widget build(BuildContext context) {
    final total = entries.fold<int>(0, (sum, entry) => sum + entry.amount);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Formatters.formatAmount(total)} ml • ${entries.length} entries',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  Formatters.formatVolume(total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      for (final entry in entries) ...[
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
                          onDismissed: (_) => onDelete(entry),
                          child: _HistoryEntryTile(entry: entry),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
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
  const _EmptyHistory({
    required this.secondaryTextColor,
    required this.message,
  });

  final Color secondaryTextColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Text(
          message,
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
