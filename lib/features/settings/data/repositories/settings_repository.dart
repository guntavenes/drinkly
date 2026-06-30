import '../../../../core/database/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._database);

  final AppDatabase _database;

  Stream<AppSetting?> watchSettings() {
    return _database.watchSettings();
  }

  Future<AppSetting?> readSettings() {
    return _database.readSettings();
  }

  Future<void> initialize() async {
    await _database.createDefaultSettingsIfNeeded();
  }

  Future<void> updateDailyGoal(int goal) async {
    await _database.updateDailyGoal(goal);
  }

  Future<void> updateRemindersEnabled(bool enabled) async {
    await _database.updateRemindersEnabled(enabled);
  }

  Future<void> updateReminderStartTime({
    required int hour,
    required int minute,
  }) async {
    await _database.updateReminderStartTime(hour: hour, minute: minute);
  }

  Future<void> updateReminderEndTime({
    required int hour,
    required int minute,
  }) async {
    await _database.updateReminderEndTime(hour: hour, minute: minute);
  }

  Future<void> updateReminderInterval(int minutes) async {
    await _database.updateReminderInterval(minutes);
  }
}
