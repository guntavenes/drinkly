import '../../../../core/database/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._database);

  final AppDatabase _database;

  Stream<AppSetting?> watchSettings() {
    return _database.watchSettings();
  }

  Future<void> initialize() async {
    await _database.createDefaultSettingsIfNeeded();
  }

  Future<void> updateDailyGoal(int goal) async {
    await _database.updateDailyGoal(goal);
  }
}
