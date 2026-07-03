// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HydrationEntriesTable extends HydrationEntries
    with TableInfo<$HydrationEntriesTable, HydrationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HydrationEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drinkTypeMeta = const VerificationMeta(
    'drinkType',
  );
  @override
  late final GeneratedColumn<String> drinkType = GeneratedColumn<String>(
    'drink_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('water'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, drinkType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hydration_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HydrationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('drink_type')) {
      context.handle(
        _drinkTypeMeta,
        drinkType.isAcceptableOrUnknown(data['drink_type']!, _drinkTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HydrationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HydrationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      drinkType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drink_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HydrationEntriesTable createAlias(String alias) {
    return $HydrationEntriesTable(attachedDatabase, alias);
  }
}

class HydrationEntry extends DataClass implements Insertable<HydrationEntry> {
  final int id;
  final int amount;
  final String drinkType;
  final DateTime createdAt;
  const HydrationEntry({
    required this.id,
    required this.amount,
    required this.drinkType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    map['drink_type'] = Variable<String>(drinkType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HydrationEntriesCompanion toCompanion(bool nullToAbsent) {
    return HydrationEntriesCompanion(
      id: Value(id),
      amount: Value(amount),
      drinkType: Value(drinkType),
      createdAt: Value(createdAt),
    );
  }

  factory HydrationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HydrationEntry(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      drinkType: serializer.fromJson<String>(json['drinkType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'drinkType': serializer.toJson<String>(drinkType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HydrationEntry copyWith({
    int? id,
    int? amount,
    String? drinkType,
    DateTime? createdAt,
  }) => HydrationEntry(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    drinkType: drinkType ?? this.drinkType,
    createdAt: createdAt ?? this.createdAt,
  );
  HydrationEntry copyWithCompanion(HydrationEntriesCompanion data) {
    return HydrationEntry(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      drinkType: data.drinkType.present ? data.drinkType.value : this.drinkType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HydrationEntry(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('drinkType: $drinkType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, drinkType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HydrationEntry &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.drinkType == this.drinkType &&
          other.createdAt == this.createdAt);
}

class HydrationEntriesCompanion extends UpdateCompanion<HydrationEntry> {
  final Value<int> id;
  final Value<int> amount;
  final Value<String> drinkType;
  final Value<DateTime> createdAt;
  const HydrationEntriesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.drinkType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HydrationEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    this.drinkType = const Value.absent(),
    required DateTime createdAt,
  }) : amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<HydrationEntry> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? drinkType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (drinkType != null) 'drink_type': drinkType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HydrationEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<String>? drinkType,
    Value<DateTime>? createdAt,
  }) {
    return HydrationEntriesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      drinkType: drinkType ?? this.drinkType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (drinkType.present) {
      map['drink_type'] = Variable<String>(drinkType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationEntriesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('drinkType: $drinkType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2500),
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ml'),
  );
  static const VerificationMeta _reminderStartHourMeta = const VerificationMeta(
    'reminderStartHour',
  );
  @override
  late final GeneratedColumn<int> reminderStartHour = GeneratedColumn<int>(
    'reminder_start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _reminderStartMinuteMeta =
      const VerificationMeta('reminderStartMinute');
  @override
  late final GeneratedColumn<int> reminderStartMinute = GeneratedColumn<int>(
    'reminder_start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reminderEndHourMeta = const VerificationMeta(
    'reminderEndHour',
  );
  @override
  late final GeneratedColumn<int> reminderEndHour = GeneratedColumn<int>(
    'reminder_end_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _reminderEndMinuteMeta = const VerificationMeta(
    'reminderEndMinute',
  );
  @override
  late final GeneratedColumn<int> reminderEndMinute = GeneratedColumn<int>(
    'reminder_end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reminderIntervalMinutesMeta =
      const VerificationMeta('reminderIntervalMinutes');
  @override
  late final GeneratedColumn<int> reminderIntervalMinutes =
      GeneratedColumn<int>(
        'reminder_interval_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(120),
      );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<int> weightKg = GeneratedColumn<int>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<int> activityLevel = GeneratedColumn<int>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastCelebratedDateMeta =
      const VerificationMeta('lastCelebratedDate');
  @override
  late final GeneratedColumn<DateTime> lastCelebratedDate =
      GeneratedColumn<DateTime>(
        'last_celebrated_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyGoal,
    remindersEnabled,
    darkMode,
    unit,
    reminderStartHour,
    reminderStartMinute,
    reminderEndHour,
    reminderEndMinute,
    reminderIntervalMinutes,
    userName,
    weightKg,
    activityLevel,
    lastCelebratedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('reminder_start_hour')) {
      context.handle(
        _reminderStartHourMeta,
        reminderStartHour.isAcceptableOrUnknown(
          data['reminder_start_hour']!,
          _reminderStartHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_start_minute')) {
      context.handle(
        _reminderStartMinuteMeta,
        reminderStartMinute.isAcceptableOrUnknown(
          data['reminder_start_minute']!,
          _reminderStartMinuteMeta,
        ),
      );
    }
    if (data.containsKey('reminder_end_hour')) {
      context.handle(
        _reminderEndHourMeta,
        reminderEndHour.isAcceptableOrUnknown(
          data['reminder_end_hour']!,
          _reminderEndHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_end_minute')) {
      context.handle(
        _reminderEndMinuteMeta,
        reminderEndMinute.isAcceptableOrUnknown(
          data['reminder_end_minute']!,
          _reminderEndMinuteMeta,
        ),
      );
    }
    if (data.containsKey('reminder_interval_minutes')) {
      context.handle(
        _reminderIntervalMinutesMeta,
        reminderIntervalMinutes.isAcceptableOrUnknown(
          data['reminder_interval_minutes']!,
          _reminderIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('last_celebrated_date')) {
      context.handle(
        _lastCelebratedDateMeta,
        lastCelebratedDate.isAcceptableOrUnknown(
          data['last_celebrated_date']!,
          _lastCelebratedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      darkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dark_mode'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      reminderStartHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_start_hour'],
      )!,
      reminderStartMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_start_minute'],
      )!,
      reminderEndHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_end_hour'],
      )!,
      reminderEndMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_end_minute'],
      )!,
      reminderIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_interval_minutes'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_kg'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_level'],
      )!,
      lastCelebratedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_celebrated_date'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int dailyGoal;
  final bool remindersEnabled;
  final bool darkMode;
  final String unit;
  final int reminderStartHour;
  final int reminderStartMinute;
  final int reminderEndHour;
  final int reminderEndMinute;
  final int reminderIntervalMinutes;
  final String? userName;
  final int? weightKg;
  final int activityLevel;
  final DateTime? lastCelebratedDate;
  const AppSetting({
    required this.id,
    required this.dailyGoal,
    required this.remindersEnabled,
    required this.darkMode,
    required this.unit,
    required this.reminderStartHour,
    required this.reminderStartMinute,
    required this.reminderEndHour,
    required this.reminderEndMinute,
    required this.reminderIntervalMinutes,
    this.userName,
    this.weightKg,
    required this.activityLevel,
    this.lastCelebratedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['unit'] = Variable<String>(unit);
    map['reminder_start_hour'] = Variable<int>(reminderStartHour);
    map['reminder_start_minute'] = Variable<int>(reminderStartMinute);
    map['reminder_end_hour'] = Variable<int>(reminderEndHour);
    map['reminder_end_minute'] = Variable<int>(reminderEndMinute);
    map['reminder_interval_minutes'] = Variable<int>(reminderIntervalMinutes);
    if (!nullToAbsent || userName != null) {
      map['user_name'] = Variable<String>(userName);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<int>(weightKg);
    }
    map['activity_level'] = Variable<int>(activityLevel);
    if (!nullToAbsent || lastCelebratedDate != null) {
      map['last_celebrated_date'] = Variable<DateTime>(lastCelebratedDate);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      dailyGoal: Value(dailyGoal),
      remindersEnabled: Value(remindersEnabled),
      darkMode: Value(darkMode),
      unit: Value(unit),
      reminderStartHour: Value(reminderStartHour),
      reminderStartMinute: Value(reminderStartMinute),
      reminderEndHour: Value(reminderEndHour),
      reminderEndMinute: Value(reminderEndMinute),
      reminderIntervalMinutes: Value(reminderIntervalMinutes),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      activityLevel: Value(activityLevel),
      lastCelebratedDate: lastCelebratedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCelebratedDate),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
      unit: serializer.fromJson<String>(json['unit']),
      reminderStartHour: serializer.fromJson<int>(json['reminderStartHour']),
      reminderStartMinute: serializer.fromJson<int>(
        json['reminderStartMinute'],
      ),
      reminderEndHour: serializer.fromJson<int>(json['reminderEndHour']),
      reminderEndMinute: serializer.fromJson<int>(json['reminderEndMinute']),
      reminderIntervalMinutes: serializer.fromJson<int>(
        json['reminderIntervalMinutes'],
      ),
      userName: serializer.fromJson<String?>(json['userName']),
      weightKg: serializer.fromJson<int?>(json['weightKg']),
      activityLevel: serializer.fromJson<int>(json['activityLevel']),
      lastCelebratedDate: serializer.fromJson<DateTime?>(
        json['lastCelebratedDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'darkMode': serializer.toJson<bool>(darkMode),
      'unit': serializer.toJson<String>(unit),
      'reminderStartHour': serializer.toJson<int>(reminderStartHour),
      'reminderStartMinute': serializer.toJson<int>(reminderStartMinute),
      'reminderEndHour': serializer.toJson<int>(reminderEndHour),
      'reminderEndMinute': serializer.toJson<int>(reminderEndMinute),
      'reminderIntervalMinutes': serializer.toJson<int>(
        reminderIntervalMinutes,
      ),
      'userName': serializer.toJson<String?>(userName),
      'weightKg': serializer.toJson<int?>(weightKg),
      'activityLevel': serializer.toJson<int>(activityLevel),
      'lastCelebratedDate': serializer.toJson<DateTime?>(lastCelebratedDate),
    };
  }

  AppSetting copyWith({
    int? id,
    int? dailyGoal,
    bool? remindersEnabled,
    bool? darkMode,
    String? unit,
    int? reminderStartHour,
    int? reminderStartMinute,
    int? reminderEndHour,
    int? reminderEndMinute,
    int? reminderIntervalMinutes,
    Value<String?> userName = const Value.absent(),
    Value<int?> weightKg = const Value.absent(),
    int? activityLevel,
    Value<DateTime?> lastCelebratedDate = const Value.absent(),
  }) => AppSetting(
    id: id ?? this.id,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    darkMode: darkMode ?? this.darkMode,
    unit: unit ?? this.unit,
    reminderStartHour: reminderStartHour ?? this.reminderStartHour,
    reminderStartMinute: reminderStartMinute ?? this.reminderStartMinute,
    reminderEndHour: reminderEndHour ?? this.reminderEndHour,
    reminderEndMinute: reminderEndMinute ?? this.reminderEndMinute,
    reminderIntervalMinutes:
        reminderIntervalMinutes ?? this.reminderIntervalMinutes,
    userName: userName.present ? userName.value : this.userName,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    lastCelebratedDate: lastCelebratedDate.present
        ? lastCelebratedDate.value
        : this.lastCelebratedDate,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      unit: data.unit.present ? data.unit.value : this.unit,
      reminderStartHour: data.reminderStartHour.present
          ? data.reminderStartHour.value
          : this.reminderStartHour,
      reminderStartMinute: data.reminderStartMinute.present
          ? data.reminderStartMinute.value
          : this.reminderStartMinute,
      reminderEndHour: data.reminderEndHour.present
          ? data.reminderEndHour.value
          : this.reminderEndHour,
      reminderEndMinute: data.reminderEndMinute.present
          ? data.reminderEndMinute.value
          : this.reminderEndMinute,
      reminderIntervalMinutes: data.reminderIntervalMinutes.present
          ? data.reminderIntervalMinutes.value
          : this.reminderIntervalMinutes,
      userName: data.userName.present ? data.userName.value : this.userName,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      lastCelebratedDate: data.lastCelebratedDate.present
          ? data.lastCelebratedDate.value
          : this.lastCelebratedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('darkMode: $darkMode, ')
          ..write('unit: $unit, ')
          ..write('reminderStartHour: $reminderStartHour, ')
          ..write('reminderStartMinute: $reminderStartMinute, ')
          ..write('reminderEndHour: $reminderEndHour, ')
          ..write('reminderEndMinute: $reminderEndMinute, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('userName: $userName, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('lastCelebratedDate: $lastCelebratedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyGoal,
    remindersEnabled,
    darkMode,
    unit,
    reminderStartHour,
    reminderStartMinute,
    reminderEndHour,
    reminderEndMinute,
    reminderIntervalMinutes,
    userName,
    weightKg,
    activityLevel,
    lastCelebratedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.dailyGoal == this.dailyGoal &&
          other.remindersEnabled == this.remindersEnabled &&
          other.darkMode == this.darkMode &&
          other.unit == this.unit &&
          other.reminderStartHour == this.reminderStartHour &&
          other.reminderStartMinute == this.reminderStartMinute &&
          other.reminderEndHour == this.reminderEndHour &&
          other.reminderEndMinute == this.reminderEndMinute &&
          other.reminderIntervalMinutes == this.reminderIntervalMinutes &&
          other.userName == this.userName &&
          other.weightKg == this.weightKg &&
          other.activityLevel == this.activityLevel &&
          other.lastCelebratedDate == this.lastCelebratedDate);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int> dailyGoal;
  final Value<bool> remindersEnabled;
  final Value<bool> darkMode;
  final Value<String> unit;
  final Value<int> reminderStartHour;
  final Value<int> reminderStartMinute;
  final Value<int> reminderEndHour;
  final Value<int> reminderEndMinute;
  final Value<int> reminderIntervalMinutes;
  final Value<String?> userName;
  final Value<int?> weightKg;
  final Value<int> activityLevel;
  final Value<DateTime?> lastCelebratedDate;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.unit = const Value.absent(),
    this.reminderStartHour = const Value.absent(),
    this.reminderStartMinute = const Value.absent(),
    this.reminderEndHour = const Value.absent(),
    this.reminderEndMinute = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.userName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.lastCelebratedDate = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.unit = const Value.absent(),
    this.reminderStartHour = const Value.absent(),
    this.reminderStartMinute = const Value.absent(),
    this.reminderEndHour = const Value.absent(),
    this.reminderEndMinute = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.userName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.lastCelebratedDate = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? dailyGoal,
    Expression<bool>? remindersEnabled,
    Expression<bool>? darkMode,
    Expression<String>? unit,
    Expression<int>? reminderStartHour,
    Expression<int>? reminderStartMinute,
    Expression<int>? reminderEndHour,
    Expression<int>? reminderEndMinute,
    Expression<int>? reminderIntervalMinutes,
    Expression<String>? userName,
    Expression<int>? weightKg,
    Expression<int>? activityLevel,
    Expression<DateTime>? lastCelebratedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (darkMode != null) 'dark_mode': darkMode,
      if (unit != null) 'unit': unit,
      if (reminderStartHour != null) 'reminder_start_hour': reminderStartHour,
      if (reminderStartMinute != null)
        'reminder_start_minute': reminderStartMinute,
      if (reminderEndHour != null) 'reminder_end_hour': reminderEndHour,
      if (reminderEndMinute != null) 'reminder_end_minute': reminderEndMinute,
      if (reminderIntervalMinutes != null)
        'reminder_interval_minutes': reminderIntervalMinutes,
      if (userName != null) 'user_name': userName,
      if (weightKg != null) 'weight_kg': weightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (lastCelebratedDate != null)
        'last_celebrated_date': lastCelebratedDate,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyGoal,
    Value<bool>? remindersEnabled,
    Value<bool>? darkMode,
    Value<String>? unit,
    Value<int>? reminderStartHour,
    Value<int>? reminderStartMinute,
    Value<int>? reminderEndHour,
    Value<int>? reminderEndMinute,
    Value<int>? reminderIntervalMinutes,
    Value<String?>? userName,
    Value<int?>? weightKg,
    Value<int>? activityLevel,
    Value<DateTime?>? lastCelebratedDate,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      darkMode: darkMode ?? this.darkMode,
      unit: unit ?? this.unit,
      reminderStartHour: reminderStartHour ?? this.reminderStartHour,
      reminderStartMinute: reminderStartMinute ?? this.reminderStartMinute,
      reminderEndHour: reminderEndHour ?? this.reminderEndHour,
      reminderEndMinute: reminderEndMinute ?? this.reminderEndMinute,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      userName: userName ?? this.userName,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      lastCelebratedDate: lastCelebratedDate ?? this.lastCelebratedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (reminderStartHour.present) {
      map['reminder_start_hour'] = Variable<int>(reminderStartHour.value);
    }
    if (reminderStartMinute.present) {
      map['reminder_start_minute'] = Variable<int>(reminderStartMinute.value);
    }
    if (reminderEndHour.present) {
      map['reminder_end_hour'] = Variable<int>(reminderEndHour.value);
    }
    if (reminderEndMinute.present) {
      map['reminder_end_minute'] = Variable<int>(reminderEndMinute.value);
    }
    if (reminderIntervalMinutes.present) {
      map['reminder_interval_minutes'] = Variable<int>(
        reminderIntervalMinutes.value,
      );
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<int>(weightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<int>(activityLevel.value);
    }
    if (lastCelebratedDate.present) {
      map['last_celebrated_date'] = Variable<DateTime>(
        lastCelebratedDate.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('darkMode: $darkMode, ')
          ..write('unit: $unit, ')
          ..write('reminderStartHour: $reminderStartHour, ')
          ..write('reminderStartMinute: $reminderStartMinute, ')
          ..write('reminderEndHour: $reminderEndHour, ')
          ..write('reminderEndMinute: $reminderEndMinute, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('userName: $userName, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('lastCelebratedDate: $lastCelebratedDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HydrationEntriesTable hydrationEntries = $HydrationEntriesTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hydrationEntries,
    appSettings,
  ];
}

typedef $$HydrationEntriesTableCreateCompanionBuilder =
    HydrationEntriesCompanion Function({
      Value<int> id,
      required int amount,
      Value<String> drinkType,
      required DateTime createdAt,
    });
typedef $$HydrationEntriesTableUpdateCompanionBuilder =
    HydrationEntriesCompanion Function({
      Value<int> id,
      Value<int> amount,
      Value<String> drinkType,
      Value<DateTime> createdAt,
    });

class $$HydrationEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drinkType => $composableBuilder(
    column: $table.drinkType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HydrationEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drinkType => $composableBuilder(
    column: $table.drinkType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HydrationEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HydrationEntriesTable> {
  $$HydrationEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get drinkType =>
      $composableBuilder(column: $table.drinkType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HydrationEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HydrationEntriesTable,
          HydrationEntry,
          $$HydrationEntriesTableFilterComposer,
          $$HydrationEntriesTableOrderingComposer,
          $$HydrationEntriesTableAnnotationComposer,
          $$HydrationEntriesTableCreateCompanionBuilder,
          $$HydrationEntriesTableUpdateCompanionBuilder,
          (
            HydrationEntry,
            BaseReferences<
              _$AppDatabase,
              $HydrationEntriesTable,
              HydrationEntry
            >,
          ),
          HydrationEntry,
          PrefetchHooks Function()
        > {
  $$HydrationEntriesTableTableManager(
    _$AppDatabase db,
    $HydrationEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HydrationEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HydrationEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HydrationEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> drinkType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HydrationEntriesCompanion(
                id: id,
                amount: amount,
                drinkType: drinkType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amount,
                Value<String> drinkType = const Value.absent(),
                required DateTime createdAt,
              }) => HydrationEntriesCompanion.insert(
                id: id,
                amount: amount,
                drinkType: drinkType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HydrationEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HydrationEntriesTable,
      HydrationEntry,
      $$HydrationEntriesTableFilterComposer,
      $$HydrationEntriesTableOrderingComposer,
      $$HydrationEntriesTableAnnotationComposer,
      $$HydrationEntriesTableCreateCompanionBuilder,
      $$HydrationEntriesTableUpdateCompanionBuilder,
      (
        HydrationEntry,
        BaseReferences<_$AppDatabase, $HydrationEntriesTable, HydrationEntry>,
      ),
      HydrationEntry,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> dailyGoal,
      Value<bool> remindersEnabled,
      Value<bool> darkMode,
      Value<String> unit,
      Value<int> reminderStartHour,
      Value<int> reminderStartMinute,
      Value<int> reminderEndHour,
      Value<int> reminderEndMinute,
      Value<int> reminderIntervalMinutes,
      Value<String?> userName,
      Value<int?> weightKg,
      Value<int> activityLevel,
      Value<DateTime?> lastCelebratedDate,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> dailyGoal,
      Value<bool> remindersEnabled,
      Value<bool> darkMode,
      Value<String> unit,
      Value<int> reminderStartHour,
      Value<int> reminderStartMinute,
      Value<int> reminderEndHour,
      Value<int> reminderEndMinute,
      Value<int> reminderIntervalMinutes,
      Value<String?> userName,
      Value<int?> weightKg,
      Value<int> activityLevel,
      Value<DateTime?> lastCelebratedDate,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderStartHour => $composableBuilder(
    column: $table.reminderStartHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderStartMinute => $composableBuilder(
    column: $table.reminderStartMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderEndHour => $composableBuilder(
    column: $table.reminderEndHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderEndMinute => $composableBuilder(
    column: $table.reminderEndMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCelebratedDate => $composableBuilder(
    column: $table.lastCelebratedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderStartHour => $composableBuilder(
    column: $table.reminderStartHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderStartMinute => $composableBuilder(
    column: $table.reminderStartMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderEndHour => $composableBuilder(
    column: $table.reminderEndHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderEndMinute => $composableBuilder(
    column: $table.reminderEndMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCelebratedDate => $composableBuilder(
    column: $table.lastCelebratedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get reminderStartHour => $composableBuilder(
    column: $table.reminderStartHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderStartMinute => $composableBuilder(
    column: $table.reminderStartMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderEndHour => $composableBuilder(
    column: $table.reminderEndHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderEndMinute => $composableBuilder(
    column: $table.reminderEndMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<int> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCelebratedDate => $composableBuilder(
    column: $table.lastCelebratedDate,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> reminderStartHour = const Value.absent(),
                Value<int> reminderStartMinute = const Value.absent(),
                Value<int> reminderEndHour = const Value.absent(),
                Value<int> reminderEndMinute = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<int?> weightKg = const Value.absent(),
                Value<int> activityLevel = const Value.absent(),
                Value<DateTime?> lastCelebratedDate = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                dailyGoal: dailyGoal,
                remindersEnabled: remindersEnabled,
                darkMode: darkMode,
                unit: unit,
                reminderStartHour: reminderStartHour,
                reminderStartMinute: reminderStartMinute,
                reminderEndHour: reminderEndHour,
                reminderEndMinute: reminderEndMinute,
                reminderIntervalMinutes: reminderIntervalMinutes,
                userName: userName,
                weightKg: weightKg,
                activityLevel: activityLevel,
                lastCelebratedDate: lastCelebratedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> reminderStartHour = const Value.absent(),
                Value<int> reminderStartMinute = const Value.absent(),
                Value<int> reminderEndHour = const Value.absent(),
                Value<int> reminderEndMinute = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<int?> weightKg = const Value.absent(),
                Value<int> activityLevel = const Value.absent(),
                Value<DateTime?> lastCelebratedDate = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                dailyGoal: dailyGoal,
                remindersEnabled: remindersEnabled,
                darkMode: darkMode,
                unit: unit,
                reminderStartHour: reminderStartHour,
                reminderStartMinute: reminderStartMinute,
                reminderEndHour: reminderEndHour,
                reminderEndMinute: reminderEndMinute,
                reminderIntervalMinutes: reminderIntervalMinutes,
                userName: userName,
                weightKg: weightKg,
                activityLevel: activityLevel,
                lastCelebratedDate: lastCelebratedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HydrationEntriesTableTableManager get hydrationEntries =>
      $$HydrationEntriesTableTableManager(_db, _db.hydrationEntries);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
