import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/hydration_entry_model.dart';
import '../mappers/hydration_entry_mapper.dart';

class HydrationRepository {
  HydrationRepository(this._database);

  final AppDatabase _database;

  Stream<List<HydrationEntryModel>> watchTodayEntries() {
    return _database.watchTodayEntries().map(
      (entries) => entries.map((entry) => entry.toModel()).toList(),
    );
  }

  Stream<List<HydrationEntryModel>> watchEntriesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    return _database
        .watchEntriesBetween(start: start, end: end)
        .map((entries) => entries.map((entry) => entry.toModel()).toList());
  }

  Stream<List<HydrationEntryModel>> watchAllEntries() {
    return _database.watchAllEntries().map(
      (entries) => entries.map((entry) => entry.toModel()).toList(),
    );
  }

  Future<void> addWater({
    required int amount,
    DateTime? createdAt,
    String drinkType = 'water',
  }) async {
    await _database.insertHydrationEntry(
      HydrationEntriesCompanion.insert(
        amount: amount,
        drinkType: Value(drinkType),
        createdAt: createdAt ?? DateTime.now(),
      ),
    );
  }

  Future<void> deleteEntry(int id) async {
    await _database.deleteHydrationEntryById(id);
  }
}
