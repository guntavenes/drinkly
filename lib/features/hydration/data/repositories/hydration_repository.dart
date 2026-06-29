import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class HydrationRepository {
  HydrationRepository(this._database);

  final AppDatabase _database;

  Stream<List<HydrationEntry>> watchTodayEntries() {
    return _database.watchTodayEntries();
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
