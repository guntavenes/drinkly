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

@DriftDatabase(tables: [HydrationEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'drinkly.sqlite'));

    return NativeDatabase(file);
  });
}
