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

  IntColumn get reminderStartHour => integer().withDefault(const Constant(8))();

  IntColumn get reminderStartMinute =>
      integer().withDefault(const Constant(0))();

  IntColumn get reminderEndHour => integer().withDefault(const Constant(22))();

  IntColumn get reminderEndMinute => integer().withDefault(const Constant(0))();

  IntColumn get reminderIntervalMinutes =>
      integer().withDefault(const Constant(120))();

  TextColumn get userName => text().nullable()();

  IntColumn get weightKg => integer().nullable()();

  IntColumn get activityLevel => integer().withDefault(const Constant(1))();

  DateTimeColumn get lastCelebratedDate => dateTime().nullable()();
}

@DriftDatabase(tables: [HydrationEntries, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

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

        if (from < 3) {
          await m.addColumn(appSettings, appSettings.reminderStartHour);
          await m.addColumn(appSettings, appSettings.reminderStartMinute);
          await m.addColumn(appSettings, appSettings.reminderEndHour);
          await m.addColumn(appSettings, appSettings.reminderEndMinute);
          await m.addColumn(appSettings, appSettings.reminderIntervalMinutes);
        }

        if (from < 4) {
          await m.addColumn(appSettings, appSettings.userName);
          await m.addColumn(appSettings, appSettings.weightKg);
          await m.addColumn(appSettings, appSettings.activityLevel);
        }
        if (from < 5) {
          await m.addColumn(appSettings, appSettings.lastCelebratedDate);
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

  Future<AppSetting?> readSettings() {
    return select(appSettings).getSingleOrNull();
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

  Future<void> updateRemindersEnabled(bool enabled) async {
    await update(
      appSettings,
    ).write(AppSettingsCompanion(remindersEnabled: Value(enabled)));
  }

  Future<void> updateReminderStartTime({
    required int hour,
    required int minute,
  }) async {
    await update(appSettings).write(
      AppSettingsCompanion(
        reminderStartHour: Value(hour),
        reminderStartMinute: Value(minute),
      ),
    );
  }

  Future<void> updateReminderEndTime({
    required int hour,
    required int minute,
  }) async {
    await update(appSettings).write(
      AppSettingsCompanion(
        reminderEndHour: Value(hour),
        reminderEndMinute: Value(minute),
      ),
    );
  }

  Future<void> updateReminderInterval(int minutes) async {
    await update(
      appSettings,
    ).write(AppSettingsCompanion(reminderIntervalMinutes: Value(minutes)));
  }

  Future<void> updateProfile({
    String? userName,
    int? weightKg,
    required int activityLevel,
  }) async {
    await update(appSettings).write(
      AppSettingsCompanion(
        userName: Value(userName),
        weightKg: Value(weightKg),
        activityLevel: Value(activityLevel),
      ),
    );
  }

  Future<void> updateLastCelebratedDate(DateTime date) async {
    await update(
      appSettings,
    ).write(AppSettingsCompanion(lastCelebratedDate: Value(date)));
  }

  Future<void> updateDarkMode(bool enabled) async {
    await update(
      appSettings,
    ).write(AppSettingsCompanion(darkMode: Value(enabled)));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'drinkly.sqlite'));

    return NativeDatabase(file);
  });
}
