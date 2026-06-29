import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class HydrationRepository {
  HydrationRepository(this._database);

  final AppDatabase _database;

  Stream<List<HydrationEntry>> watchTodayEntries() {
    return _database.watchTodayEntries();
  }

  Stream<List<HydrationEntry>> watchEntriesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    return _database.watchEntriesBetween(start: start, end: end);
  }

  Future<void> addWater({
    required int amount,
    String drinkType = 'water',
  }) async {
    await _database.insertHydrationEntry(
      HydrationEntriesCompanion.insert(
        amount: amount,
        drinkType: Value(drinkType),
        createdAt: DateTime.now(),
      ),
    );
  }
}
