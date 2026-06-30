import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class HydrationEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get amount => integer()();

  TextColumn get drinkType => text().withDefault(const Constant('water'))();

  DateTimeColumn get createdAt => dateTime()();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get dailyGoal => integer().withDefault(const Constant(2500))();

  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();

  TextColumn get unit => text().withDefault(const Constant('ml'))();
}

@DriftDatabase(tables: [HydrationEntries, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        await into(appSettings).insert(AppSettingsCompanion.insert());
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(appSettings);

          await into(appSettings).insert(AppSettingsCompanion.insert());
        }
      },
    );
  }

  Future<int> insertHydrationEntry(HydrationEntriesCompanion entry) {
    return into(hydrationEntries).insert(entry);
  }

  Stream<List<HydrationEntry>> watchTodayEntries() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    return (select(hydrationEntries)
          ..where((tbl) => tbl.createdAt.isBetweenValues(start, end))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Stream<List<HydrationEntry>> watchEntriesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    return (select(hydrationEntries)
          ..where((tbl) => tbl.createdAt.isBetweenValues(start, end))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Stream<List<HydrationEntry>> watchAllEntries() {
    return (select(hydrationEntries)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<void> deleteHydrationEntryById(int id) {
    return (delete(hydrationEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<AppSetting?> watchSettings() {
    return select(appSettings).watchSingleOrNull();
  }

  Future<void> createDefaultSettingsIfNeeded() async {
    final existing = await select(appSettings).getSingleOrNull();

    if (existing != null) return;

    await into(appSettings).insert(AppSettingsCompanion.insert());
  }

  Future<void> updateDailyGoal(int dailyGoal) async {
    await update(
      appSettings,
    ).write(AppSettingsCompanion(dailyGoal: Value(dailyGoal)));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'drinkly.sqlite'));

    return NativeDatabase(file);
  });
}
