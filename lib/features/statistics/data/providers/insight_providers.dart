import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hydration/data/providers/hydration_providers.dart';

final averageDrinkAmountProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(allHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      if (entries.isEmpty) return 0;

      final total = entries.fold<int>(0, (sum, entry) => sum + entry.amount);

      return (total / entries.length).round();
    },
    orElse: () => 0,
  );
});

final favoriteDrinkAmountProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(allHydrationEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      if (entries.isEmpty) return 0;

      final counter = <int, int>{};

      for (final e in entries) {
        counter[e.amount] = (counter[e.amount] ?? 0) + 1;
      }

      return counter.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    },
    orElse: () => 0,
  );
});
