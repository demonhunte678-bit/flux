// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackingTypeMeta = const VerificationMeta(
    'trackingType',
  );
  @override
  late final GeneratedColumn<int> trackingType = GeneratedColumn<int>(
    'tracking_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayModeMeta = const VerificationMeta(
    'displayMode',
  );
  @override
  late final GeneratedColumn<int> displayMode = GeneratedColumn<int>(
    'display_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> customDays =
      GeneratedColumn<String>(
        'custom_days',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<int>>($HabitsTable.$convertercustomDays);
  static const VerificationMeta _targetFrequencyMeta = const VerificationMeta(
    'targetFrequency',
  );
  @override
  late final GeneratedColumn<int> targetFrequency = GeneratedColumn<int>(
    'target_frequency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<int> unit = GeneratedColumn<int>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customUnitMeta = const VerificationMeta(
    'customUnit',
  );
  @override
  late final GeneratedColumn<String> customUnit = GeneratedColumn<String>(
    'custom_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pauseStartDateMeta = const VerificationMeta(
    'pauseStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> pauseStartDate =
      GeneratedColumn<DateTime>(
        'pause_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pauseEndDateMeta = const VerificationMeta(
    'pauseEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> pauseEndDate = GeneratedColumn<DateTime>(
    'pause_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
  );
  static const VerificationMeta _customSuccessMessageMeta =
      const VerificationMeta('customSuccessMessage');
  @override
  late final GeneratedColumn<String> customSuccessMessage =
      GeneratedColumn<String>(
        'custom_success_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customFailureMessageMeta =
      const VerificationMeta('customFailureMessage');
  @override
  late final GeneratedColumn<String> customFailureMessage =
      GeneratedColumn<String>(
        'custom_failure_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<WeekendDays?, int> weekendDays =
      GeneratedColumn<int>(
        'weekend_days',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<WeekendDays?>($HabitsTable.$converterweekendDaysn);
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalValueMeta = const VerificationMeta(
    'goalValue',
  );
  @override
  late final GeneratedColumn<double> goalValue = GeneratedColumn<double>(
    'goal_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    trackingType,
    displayMode,
    icon,
    color,
    isArchived,
    notes,
    category,
    frequency,
    customDays,
    targetFrequency,
    targetValue,
    unit,
    customUnit,
    pauseStartDate,
    pauseEndDate,
    isPaused,
    customSuccessMessage,
    customFailureMessage,
    weekendDays,
    goalType,
    goalValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('tracking_type')) {
      context.handle(
        _trackingTypeMeta,
        trackingType.isAcceptableOrUnknown(
          data['tracking_type']!,
          _trackingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackingTypeMeta);
    }
    if (data.containsKey('display_mode')) {
      context.handle(
        _displayModeMeta,
        displayMode.isAcceptableOrUnknown(
          data['display_mode']!,
          _displayModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayModeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    } else if (isInserting) {
      context.missing(_isArchivedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('target_frequency')) {
      context.handle(
        _targetFrequencyMeta,
        targetFrequency.isAcceptableOrUnknown(
          data['target_frequency']!,
          _targetFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('custom_unit')) {
      context.handle(
        _customUnitMeta,
        customUnit.isAcceptableOrUnknown(data['custom_unit']!, _customUnitMeta),
      );
    }
    if (data.containsKey('pause_start_date')) {
      context.handle(
        _pauseStartDateMeta,
        pauseStartDate.isAcceptableOrUnknown(
          data['pause_start_date']!,
          _pauseStartDateMeta,
        ),
      );
    }
    if (data.containsKey('pause_end_date')) {
      context.handle(
        _pauseEndDateMeta,
        pauseEndDate.isAcceptableOrUnknown(
          data['pause_end_date']!,
          _pauseEndDateMeta,
        ),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    } else if (isInserting) {
      context.missing(_isPausedMeta);
    }
    if (data.containsKey('custom_success_message')) {
      context.handle(
        _customSuccessMessageMeta,
        customSuccessMessage.isAcceptableOrUnknown(
          data['custom_success_message']!,
          _customSuccessMessageMeta,
        ),
      );
    }
    if (data.containsKey('custom_failure_message')) {
      context.handle(
        _customFailureMessageMeta,
        customFailureMessage.isAcceptableOrUnknown(
          data['custom_failure_message']!,
          _customFailureMessageMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('goal_value')) {
      context.handle(
        _goalValueMeta,
        goalValue.isAcceptableOrUnknown(data['goal_value']!, _goalValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      trackingType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tracking_type'],
      )!,
      displayMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_mode'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency'],
      )!,
      customDays: $HabitsTable.$convertercustomDays.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}custom_days'],
        )!,
      ),
      targetFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_frequency'],
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit'],
      )!,
      customUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_unit'],
      ),
      pauseStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pause_start_date'],
      ),
      pauseEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pause_end_date'],
      ),
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      customSuccessMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_success_message'],
      ),
      customFailureMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_failure_message'],
      ),
      weekendDays: $HabitsTable.$converterweekendDaysn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}weekend_days'],
        ),
      ),
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      ),
      goalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_value'],
      ),
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $convertercustomDays =
      const IntListConverter();
  static JsonTypeConverter2<WeekendDays, int, int> $converterweekendDays =
      const EnumIndexConverter<WeekendDays>(WeekendDays.values);
  static JsonTypeConverter2<WeekendDays?, int?, int?> $converterweekendDaysn =
      JsonTypeConverter2.asNullable($converterweekendDays);
}

class HabitData extends DataClass implements Insertable<HabitData> {
  final String id;
  final String name;
  final int type;
  final int trackingType;
  final int displayMode;
  final int? icon;
  final int? color;
  final bool isArchived;
  final String? notes;
  final int? category;
  final int frequency;
  final List<int> customDays;
  final int? targetFrequency;
  final double? targetValue;
  final int unit;
  final String? customUnit;
  final DateTime? pauseStartDate;
  final DateTime? pauseEndDate;
  final bool isPaused;
  final String? customSuccessMessage;
  final String? customFailureMessage;
  final WeekendDays? weekendDays;
  final String? goalType;
  final double? goalValue;
  const HabitData({
    required this.id,
    required this.name,
    required this.type,
    required this.trackingType,
    required this.displayMode,
    this.icon,
    this.color,
    required this.isArchived,
    this.notes,
    this.category,
    required this.frequency,
    required this.customDays,
    this.targetFrequency,
    this.targetValue,
    required this.unit,
    this.customUnit,
    this.pauseStartDate,
    this.pauseEndDate,
    required this.isPaused,
    this.customSuccessMessage,
    this.customFailureMessage,
    this.weekendDays,
    this.goalType,
    this.goalValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    map['tracking_type'] = Variable<int>(trackingType);
    map['display_mode'] = Variable<int>(displayMode);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<int>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(category);
    }
    map['frequency'] = Variable<int>(frequency);
    {
      map['custom_days'] = Variable<String>(
        $HabitsTable.$convertercustomDays.toSql(customDays),
      );
    }
    if (!nullToAbsent || targetFrequency != null) {
      map['target_frequency'] = Variable<int>(targetFrequency);
    }
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<double>(targetValue);
    }
    map['unit'] = Variable<int>(unit);
    if (!nullToAbsent || customUnit != null) {
      map['custom_unit'] = Variable<String>(customUnit);
    }
    if (!nullToAbsent || pauseStartDate != null) {
      map['pause_start_date'] = Variable<DateTime>(pauseStartDate);
    }
    if (!nullToAbsent || pauseEndDate != null) {
      map['pause_end_date'] = Variable<DateTime>(pauseEndDate);
    }
    map['is_paused'] = Variable<bool>(isPaused);
    if (!nullToAbsent || customSuccessMessage != null) {
      map['custom_success_message'] = Variable<String>(customSuccessMessage);
    }
    if (!nullToAbsent || customFailureMessage != null) {
      map['custom_failure_message'] = Variable<String>(customFailureMessage);
    }
    if (!nullToAbsent || weekendDays != null) {
      map['weekend_days'] = Variable<int>(
        $HabitsTable.$converterweekendDaysn.toSql(weekendDays),
      );
    }
    if (!nullToAbsent || goalType != null) {
      map['goal_type'] = Variable<String>(goalType);
    }
    if (!nullToAbsent || goalValue != null) {
      map['goal_value'] = Variable<double>(goalValue);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      trackingType: Value(trackingType),
      displayMode: Value(displayMode),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      isArchived: Value(isArchived),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      frequency: Value(frequency),
      customDays: Value(customDays),
      targetFrequency: targetFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFrequency),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      unit: Value(unit),
      customUnit: customUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(customUnit),
      pauseStartDate: pauseStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseStartDate),
      pauseEndDate: pauseEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseEndDate),
      isPaused: Value(isPaused),
      customSuccessMessage: customSuccessMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(customSuccessMessage),
      customFailureMessage: customFailureMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(customFailureMessage),
      weekendDays: weekendDays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekendDays),
      goalType: goalType == null && nullToAbsent
          ? const Value.absent()
          : Value(goalType),
      goalValue: goalValue == null && nullToAbsent
          ? const Value.absent()
          : Value(goalValue),
    );
  }

  factory HabitData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      trackingType: serializer.fromJson<int>(json['trackingType']),
      displayMode: serializer.fromJson<int>(json['displayMode']),
      icon: serializer.fromJson<int?>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      notes: serializer.fromJson<String?>(json['notes']),
      category: serializer.fromJson<int?>(json['category']),
      frequency: serializer.fromJson<int>(json['frequency']),
      customDays: serializer.fromJson<List<int>>(json['customDays']),
      targetFrequency: serializer.fromJson<int?>(json['targetFrequency']),
      targetValue: serializer.fromJson<double?>(json['targetValue']),
      unit: serializer.fromJson<int>(json['unit']),
      customUnit: serializer.fromJson<String?>(json['customUnit']),
      pauseStartDate: serializer.fromJson<DateTime?>(json['pauseStartDate']),
      pauseEndDate: serializer.fromJson<DateTime?>(json['pauseEndDate']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      customSuccessMessage: serializer.fromJson<String?>(
        json['customSuccessMessage'],
      ),
      customFailureMessage: serializer.fromJson<String?>(
        json['customFailureMessage'],
      ),
      weekendDays: $HabitsTable.$converterweekendDaysn.fromJson(
        serializer.fromJson<int?>(json['weekendDays']),
      ),
      goalType: serializer.fromJson<String?>(json['goalType']),
      goalValue: serializer.fromJson<double?>(json['goalValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'trackingType': serializer.toJson<int>(trackingType),
      'displayMode': serializer.toJson<int>(displayMode),
      'icon': serializer.toJson<int?>(icon),
      'color': serializer.toJson<int?>(color),
      'isArchived': serializer.toJson<bool>(isArchived),
      'notes': serializer.toJson<String?>(notes),
      'category': serializer.toJson<int?>(category),
      'frequency': serializer.toJson<int>(frequency),
      'customDays': serializer.toJson<List<int>>(customDays),
      'targetFrequency': serializer.toJson<int?>(targetFrequency),
      'targetValue': serializer.toJson<double?>(targetValue),
      'unit': serializer.toJson<int>(unit),
      'customUnit': serializer.toJson<String?>(customUnit),
      'pauseStartDate': serializer.toJson<DateTime?>(pauseStartDate),
      'pauseEndDate': serializer.toJson<DateTime?>(pauseEndDate),
      'isPaused': serializer.toJson<bool>(isPaused),
      'customSuccessMessage': serializer.toJson<String?>(customSuccessMessage),
      'customFailureMessage': serializer.toJson<String?>(customFailureMessage),
      'weekendDays': serializer.toJson<int?>(
        $HabitsTable.$converterweekendDaysn.toJson(weekendDays),
      ),
      'goalType': serializer.toJson<String?>(goalType),
      'goalValue': serializer.toJson<double?>(goalValue),
    };
  }

  HabitData copyWith({
    String? id,
    String? name,
    int? type,
    int? trackingType,
    int? displayMode,
    Value<int?> icon = const Value.absent(),
    Value<int?> color = const Value.absent(),
    bool? isArchived,
    Value<String?> notes = const Value.absent(),
    Value<int?> category = const Value.absent(),
    int? frequency,
    List<int>? customDays,
    Value<int?> targetFrequency = const Value.absent(),
    Value<double?> targetValue = const Value.absent(),
    int? unit,
    Value<String?> customUnit = const Value.absent(),
    Value<DateTime?> pauseStartDate = const Value.absent(),
    Value<DateTime?> pauseEndDate = const Value.absent(),
    bool? isPaused,
    Value<String?> customSuccessMessage = const Value.absent(),
    Value<String?> customFailureMessage = const Value.absent(),
    Value<WeekendDays?> weekendDays = const Value.absent(),
    Value<String?> goalType = const Value.absent(),
    Value<double?> goalValue = const Value.absent(),
  }) => HabitData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    trackingType: trackingType ?? this.trackingType,
    displayMode: displayMode ?? this.displayMode,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    isArchived: isArchived ?? this.isArchived,
    notes: notes.present ? notes.value : this.notes,
    category: category.present ? category.value : this.category,
    frequency: frequency ?? this.frequency,
    customDays: customDays ?? this.customDays,
    targetFrequency: targetFrequency.present
        ? targetFrequency.value
        : this.targetFrequency,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    unit: unit ?? this.unit,
    customUnit: customUnit.present ? customUnit.value : this.customUnit,
    pauseStartDate: pauseStartDate.present
        ? pauseStartDate.value
        : this.pauseStartDate,
    pauseEndDate: pauseEndDate.present ? pauseEndDate.value : this.pauseEndDate,
    isPaused: isPaused ?? this.isPaused,
    customSuccessMessage: customSuccessMessage.present
        ? customSuccessMessage.value
        : this.customSuccessMessage,
    customFailureMessage: customFailureMessage.present
        ? customFailureMessage.value
        : this.customFailureMessage,
    weekendDays: weekendDays.present ? weekendDays.value : this.weekendDays,
    goalType: goalType.present ? goalType.value : this.goalType,
    goalValue: goalValue.present ? goalValue.value : this.goalValue,
  );
  HabitData copyWithCompanion(HabitsCompanion data) {
    return HabitData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      trackingType: data.trackingType.present
          ? data.trackingType.value
          : this.trackingType,
      displayMode: data.displayMode.present
          ? data.displayMode.value
          : this.displayMode,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      notes: data.notes.present ? data.notes.value : this.notes,
      category: data.category.present ? data.category.value : this.category,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      customDays: data.customDays.present
          ? data.customDays.value
          : this.customDays,
      targetFrequency: data.targetFrequency.present
          ? data.targetFrequency.value
          : this.targetFrequency,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      customUnit: data.customUnit.present
          ? data.customUnit.value
          : this.customUnit,
      pauseStartDate: data.pauseStartDate.present
          ? data.pauseStartDate.value
          : this.pauseStartDate,
      pauseEndDate: data.pauseEndDate.present
          ? data.pauseEndDate.value
          : this.pauseEndDate,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      customSuccessMessage: data.customSuccessMessage.present
          ? data.customSuccessMessage.value
          : this.customSuccessMessage,
      customFailureMessage: data.customFailureMessage.present
          ? data.customFailureMessage.value
          : this.customFailureMessage,
      weekendDays: data.weekendDays.present
          ? data.weekendDays.value
          : this.weekendDays,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      goalValue: data.goalValue.present ? data.goalValue.value : this.goalValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('trackingType: $trackingType, ')
          ..write('displayMode: $displayMode, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isArchived: $isArchived, ')
          ..write('notes: $notes, ')
          ..write('category: $category, ')
          ..write('frequency: $frequency, ')
          ..write('customDays: $customDays, ')
          ..write('targetFrequency: $targetFrequency, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('customUnit: $customUnit, ')
          ..write('pauseStartDate: $pauseStartDate, ')
          ..write('pauseEndDate: $pauseEndDate, ')
          ..write('isPaused: $isPaused, ')
          ..write('customSuccessMessage: $customSuccessMessage, ')
          ..write('customFailureMessage: $customFailureMessage, ')
          ..write('weekendDays: $weekendDays, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    type,
    trackingType,
    displayMode,
    icon,
    color,
    isArchived,
    notes,
    category,
    frequency,
    customDays,
    targetFrequency,
    targetValue,
    unit,
    customUnit,
    pauseStartDate,
    pauseEndDate,
    isPaused,
    customSuccessMessage,
    customFailureMessage,
    weekendDays,
    goalType,
    goalValue,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.trackingType == this.trackingType &&
          other.displayMode == this.displayMode &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isArchived == this.isArchived &&
          other.notes == this.notes &&
          other.category == this.category &&
          other.frequency == this.frequency &&
          other.customDays == this.customDays &&
          other.targetFrequency == this.targetFrequency &&
          other.targetValue == this.targetValue &&
          other.unit == this.unit &&
          other.customUnit == this.customUnit &&
          other.pauseStartDate == this.pauseStartDate &&
          other.pauseEndDate == this.pauseEndDate &&
          other.isPaused == this.isPaused &&
          other.customSuccessMessage == this.customSuccessMessage &&
          other.customFailureMessage == this.customFailureMessage &&
          other.weekendDays == this.weekendDays &&
          other.goalType == this.goalType &&
          other.goalValue == this.goalValue);
}

class HabitsCompanion extends UpdateCompanion<HabitData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> type;
  final Value<int> trackingType;
  final Value<int> displayMode;
  final Value<int?> icon;
  final Value<int?> color;
  final Value<bool> isArchived;
  final Value<String?> notes;
  final Value<int?> category;
  final Value<int> frequency;
  final Value<List<int>> customDays;
  final Value<int?> targetFrequency;
  final Value<double?> targetValue;
  final Value<int> unit;
  final Value<String?> customUnit;
  final Value<DateTime?> pauseStartDate;
  final Value<DateTime?> pauseEndDate;
  final Value<bool> isPaused;
  final Value<String?> customSuccessMessage;
  final Value<String?> customFailureMessage;
  final Value<WeekendDays?> weekendDays;
  final Value<String?> goalType;
  final Value<double?> goalValue;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.trackingType = const Value.absent(),
    this.displayMode = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.notes = const Value.absent(),
    this.category = const Value.absent(),
    this.frequency = const Value.absent(),
    this.customDays = const Value.absent(),
    this.targetFrequency = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.customUnit = const Value.absent(),
    this.pauseStartDate = const Value.absent(),
    this.pauseEndDate = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.customSuccessMessage = const Value.absent(),
    this.customFailureMessage = const Value.absent(),
    this.weekendDays = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    required int type,
    required int trackingType,
    required int displayMode,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required bool isArchived,
    this.notes = const Value.absent(),
    this.category = const Value.absent(),
    required int frequency,
    required List<int> customDays,
    this.targetFrequency = const Value.absent(),
    this.targetValue = const Value.absent(),
    required int unit,
    this.customUnit = const Value.absent(),
    this.pauseStartDate = const Value.absent(),
    this.pauseEndDate = const Value.absent(),
    required bool isPaused,
    this.customSuccessMessage = const Value.absent(),
    this.customFailureMessage = const Value.absent(),
    this.weekendDays = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       trackingType = Value(trackingType),
       displayMode = Value(displayMode),
       isArchived = Value(isArchived),
       frequency = Value(frequency),
       customDays = Value(customDays),
       unit = Value(unit),
       isPaused = Value(isPaused);
  static Insertable<HabitData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? trackingType,
    Expression<int>? displayMode,
    Expression<int>? icon,
    Expression<int>? color,
    Expression<bool>? isArchived,
    Expression<String>? notes,
    Expression<int>? category,
    Expression<int>? frequency,
    Expression<String>? customDays,
    Expression<int>? targetFrequency,
    Expression<double>? targetValue,
    Expression<int>? unit,
    Expression<String>? customUnit,
    Expression<DateTime>? pauseStartDate,
    Expression<DateTime>? pauseEndDate,
    Expression<bool>? isPaused,
    Expression<String>? customSuccessMessage,
    Expression<String>? customFailureMessage,
    Expression<int>? weekendDays,
    Expression<String>? goalType,
    Expression<double>? goalValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (trackingType != null) 'tracking_type': trackingType,
      if (displayMode != null) 'display_mode': displayMode,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isArchived != null) 'is_archived': isArchived,
      if (notes != null) 'notes': notes,
      if (category != null) 'category': category,
      if (frequency != null) 'frequency': frequency,
      if (customDays != null) 'custom_days': customDays,
      if (targetFrequency != null) 'target_frequency': targetFrequency,
      if (targetValue != null) 'target_value': targetValue,
      if (unit != null) 'unit': unit,
      if (customUnit != null) 'custom_unit': customUnit,
      if (pauseStartDate != null) 'pause_start_date': pauseStartDate,
      if (pauseEndDate != null) 'pause_end_date': pauseEndDate,
      if (isPaused != null) 'is_paused': isPaused,
      if (customSuccessMessage != null)
        'custom_success_message': customSuccessMessage,
      if (customFailureMessage != null)
        'custom_failure_message': customFailureMessage,
      if (weekendDays != null) 'weekend_days': weekendDays,
      if (goalType != null) 'goal_type': goalType,
      if (goalValue != null) 'goal_value': goalValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? type,
    Value<int>? trackingType,
    Value<int>? displayMode,
    Value<int?>? icon,
    Value<int?>? color,
    Value<bool>? isArchived,
    Value<String?>? notes,
    Value<int?>? category,
    Value<int>? frequency,
    Value<List<int>>? customDays,
    Value<int?>? targetFrequency,
    Value<double?>? targetValue,
    Value<int>? unit,
    Value<String?>? customUnit,
    Value<DateTime?>? pauseStartDate,
    Value<DateTime?>? pauseEndDate,
    Value<bool>? isPaused,
    Value<String?>? customSuccessMessage,
    Value<String?>? customFailureMessage,
    Value<WeekendDays?>? weekendDays,
    Value<String?>? goalType,
    Value<double?>? goalValue,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      trackingType: trackingType ?? this.trackingType,
      displayMode: displayMode ?? this.displayMode,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isArchived: isArchived ?? this.isArchived,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      customUnit: customUnit ?? this.customUnit,
      pauseStartDate: pauseStartDate ?? this.pauseStartDate,
      pauseEndDate: pauseEndDate ?? this.pauseEndDate,
      isPaused: isPaused ?? this.isPaused,
      customSuccessMessage: customSuccessMessage ?? this.customSuccessMessage,
      customFailureMessage: customFailureMessage ?? this.customFailureMessage,
      weekendDays: weekendDays ?? this.weekendDays,
      goalType: goalType ?? this.goalType,
      goalValue: goalValue ?? this.goalValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (trackingType.present) {
      map['tracking_type'] = Variable<int>(trackingType.value);
    }
    if (displayMode.present) {
      map['display_mode'] = Variable<int>(displayMode.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (customDays.present) {
      map['custom_days'] = Variable<String>(
        $HabitsTable.$convertercustomDays.toSql(customDays.value),
      );
    }
    if (targetFrequency.present) {
      map['target_frequency'] = Variable<int>(targetFrequency.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    if (customUnit.present) {
      map['custom_unit'] = Variable<String>(customUnit.value);
    }
    if (pauseStartDate.present) {
      map['pause_start_date'] = Variable<DateTime>(pauseStartDate.value);
    }
    if (pauseEndDate.present) {
      map['pause_end_date'] = Variable<DateTime>(pauseEndDate.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (customSuccessMessage.present) {
      map['custom_success_message'] = Variable<String>(
        customSuccessMessage.value,
      );
    }
    if (customFailureMessage.present) {
      map['custom_failure_message'] = Variable<String>(
        customFailureMessage.value,
      );
    }
    if (weekendDays.present) {
      map['weekend_days'] = Variable<int>(
        $HabitsTable.$converterweekendDaysn.toSql(weekendDays.value),
      );
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (goalValue.present) {
      map['goal_value'] = Variable<double>(goalValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('trackingType: $trackingType, ')
          ..write('displayMode: $displayMode, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isArchived: $isArchived, ')
          ..write('notes: $notes, ')
          ..write('category: $category, ')
          ..write('frequency: $frequency, ')
          ..write('customDays: $customDays, ')
          ..write('targetFrequency: $targetFrequency, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('customUnit: $customUnit, ')
          ..write('pauseStartDate: $pauseStartDate, ')
          ..write('pauseEndDate: $pauseEndDate, ')
          ..write('isPaused: $isPaused, ')
          ..write('customSuccessMessage: $customSuccessMessage, ')
          ..write('customFailureMessage: $customFailureMessage, ')
          ..write('weekendDays: $weekendDays, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTable extends HabitEntries
    with TableInfo<$HabitEntriesTable, HabitEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    date,
    count,
    value,
    unit,
    notes,
    isSkipped,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
      );
    } else if (isInserting) {
      context.missing(_isSkippedMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $HabitEntriesTable createAlias(String alias) {
    return $HabitEntriesTable(attachedDatabase, alias);
  }
}

class HabitEntryData extends DataClass implements Insertable<HabitEntryData> {
  final int id;
  final String habitId;
  final DateTime date;
  final int count;
  final double? value;
  final String? unit;
  final String? notes;
  final bool isSkipped;
  final bool isArchived;
  const HabitEntryData({
    required this.id,
    required this.habitId,
    required this.date,
    required this.count,
    this.value,
    this.unit,
    this.notes,
    required this.isSkipped,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<DateTime>(date);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_skipped'] = Variable<bool>(isSkipped);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  HabitEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      count: Value(count),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSkipped: Value(isSkipped),
      isArchived: Value(isArchived),
    );
  }

  factory HabitEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntryData(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      value: serializer.fromJson<double?>(json['value']),
      unit: serializer.fromJson<String?>(json['unit']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'count': serializer.toJson<int>(count),
      'value': serializer.toJson<double?>(value),
      'unit': serializer.toJson<String?>(unit),
      'notes': serializer.toJson<String?>(notes),
      'isSkipped': serializer.toJson<bool>(isSkipped),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  HabitEntryData copyWith({
    int? id,
    String? habitId,
    DateTime? date,
    int? count,
    Value<double?> value = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isSkipped,
    bool? isArchived,
  }) => HabitEntryData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    count: count ?? this.count,
    value: value.present ? value.value : this.value,
    unit: unit.present ? unit.value : this.unit,
    notes: notes.present ? notes.value : this.notes,
    isSkipped: isSkipped ?? this.isSkipped,
    isArchived: isArchived ?? this.isArchived,
  );
  HabitEntryData copyWithCompanion(HabitEntriesCompanion data) {
    return HabitEntryData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntryData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    date,
    count,
    value,
    unit,
    notes,
    isSkipped,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntryData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.count == this.count &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.notes == this.notes &&
          other.isSkipped == this.isSkipped &&
          other.isArchived == this.isArchived);
}

class HabitEntriesCompanion extends UpdateCompanion<HabitEntryData> {
  final Value<int> id;
  final Value<String> habitId;
  final Value<DateTime> date;
  final Value<int> count;
  final Value<double?> value;
  final Value<String?> unit;
  final Value<String?> notes;
  final Value<bool> isSkipped;
  final Value<bool> isArchived;
  const HabitEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  HabitEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String habitId,
    required DateTime date,
    required int count,
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    required bool isSkipped,
    this.isArchived = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       count = Value(count),
       isSkipped = Value(isSkipped);
  static Insertable<HabitEntryData> custom({
    Expression<int>? id,
    Expression<String>? habitId,
    Expression<DateTime>? date,
    Expression<int>? count,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? notes,
    Expression<bool>? isSkipped,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
      if (isSkipped != null) 'is_skipped': isSkipped,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  HabitEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? habitId,
    Value<DateTime>? date,
    Value<int>? count,
    Value<double?>? value,
    Value<String?>? unit,
    Value<String?>? notes,
    Value<bool>? isSkipped,
    Value<bool>? isArchived,
  }) {
    return HabitEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      count: count ?? this.count,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      isSkipped: isSkipped ?? this.isSkipped,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final int? color;
  final int? icon;
  const CategoryData({
    required this.id,
    required this.name,
    this.color,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<int>(icon);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory CategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
      icon: serializer.fromJson<int?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
      'icon': serializer.toJson<int?>(icon),
    };
  }

  CategoryData copyWith({
    int? id,
    String? name,
    Value<int?> color = const Value.absent(),
    Value<int?> icon = const Value.absent(),
  }) => CategoryData(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
  );
  CategoryData copyWithCompanion(CategoriesCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon);
}

class CategoriesCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> color;
  final Value<int?> icon;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? color,
    Value<int?>? icon,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitEntriesTable habitEntries = $HabitEntriesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    habitEntries,
    categories,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String name,
      required int type,
      required int trackingType,
      required int displayMode,
      Value<int?> icon,
      Value<int?> color,
      required bool isArchived,
      Value<String?> notes,
      Value<int?> category,
      required int frequency,
      required List<int> customDays,
      Value<int?> targetFrequency,
      Value<double?> targetValue,
      required int unit,
      Value<String?> customUnit,
      Value<DateTime?> pauseStartDate,
      Value<DateTime?> pauseEndDate,
      required bool isPaused,
      Value<String?> customSuccessMessage,
      Value<String?> customFailureMessage,
      Value<WeekendDays?> weekendDays,
      Value<String?> goalType,
      Value<double?> goalValue,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> type,
      Value<int> trackingType,
      Value<int> displayMode,
      Value<int?> icon,
      Value<int?> color,
      Value<bool> isArchived,
      Value<String?> notes,
      Value<int?> category,
      Value<int> frequency,
      Value<List<int>> customDays,
      Value<int?> targetFrequency,
      Value<double?> targetValue,
      Value<int> unit,
      Value<String?> customUnit,
      Value<DateTime?> pauseStartDate,
      Value<DateTime?> pauseEndDate,
      Value<bool> isPaused,
      Value<String?> customSuccessMessage,
      Value<String?> customFailureMessage,
      Value<WeekendDays?> weekendDays,
      Value<String?> goalType,
      Value<double?> goalValue,
      Value<int> rowid,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitData> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitEntriesTable, List<HabitEntryData>>
  _habitEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitEntries,
    aliasName: 'habits__id__habit_entries__habit_id',
  );

  $$HabitEntriesTableProcessedTableManager get habitEntriesRefs {
    final manager = $$HabitEntriesTableTableManager(
      $_db,
      $_db.habitEntries,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get customDays =>
      $composableBuilder(
        column: $table.customDays,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get targetFrequency => $composableBuilder(
    column: $table.targetFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pauseStartDate => $composableBuilder(
    column: $table.pauseStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pauseEndDate => $composableBuilder(
    column: $table.pauseEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customSuccessMessage => $composableBuilder(
    column: $table.customSuccessMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFailureMessage => $composableBuilder(
    column: $table.customFailureMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeekendDays?, WeekendDays, int>
  get weekendDays => $composableBuilder(
    column: $table.weekendDays,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitEntriesRefs(
    Expression<bool> Function($$HabitEntriesTableFilterComposer f) f,
  ) {
    final $$HabitEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitEntriesTableFilterComposer(
            $db: $db,
            $table: $db.habitEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customDays => $composableBuilder(
    column: $table.customDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetFrequency => $composableBuilder(
    column: $table.targetFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pauseStartDate => $composableBuilder(
    column: $table.pauseStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pauseEndDate => $composableBuilder(
    column: $table.pauseEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customSuccessMessage => $composableBuilder(
    column: $table.customSuccessMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFailureMessage => $composableBuilder(
    column: $table.customFailureMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekendDays => $composableBuilder(
    column: $table.weekendDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get customDays =>
      $composableBuilder(
        column: $table.customDays,
        builder: (column) => column,
      );

  GeneratedColumn<int> get targetFrequency => $composableBuilder(
    column: $table.targetFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pauseStartDate => $composableBuilder(
    column: $table.pauseStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pauseEndDate => $composableBuilder(
    column: $table.pauseEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<String> get customSuccessMessage => $composableBuilder(
    column: $table.customSuccessMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFailureMessage => $composableBuilder(
    column: $table.customFailureMessage,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeekendDays?, int> get weekendDays =>
      $composableBuilder(
        column: $table.weekendDays,
        builder: (column) => column,
      );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<double> get goalValue =>
      $composableBuilder(column: $table.goalValue, builder: (column) => column);

  Expression<T> habitEntriesRefs<T extends Object>(
    Expression<T> Function($$HabitEntriesTableAnnotationComposer a) f,
  ) {
    final $$HabitEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.habitEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitData,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitData, $$HabitsTableReferences),
          HabitData,
          PrefetchHooks Function({bool habitEntriesRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> trackingType = const Value.absent(),
                Value<int> displayMode = const Value.absent(),
                Value<int?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> category = const Value.absent(),
                Value<int> frequency = const Value.absent(),
                Value<List<int>> customDays = const Value.absent(),
                Value<int?> targetFrequency = const Value.absent(),
                Value<double?> targetValue = const Value.absent(),
                Value<int> unit = const Value.absent(),
                Value<String?> customUnit = const Value.absent(),
                Value<DateTime?> pauseStartDate = const Value.absent(),
                Value<DateTime?> pauseEndDate = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<String?> customSuccessMessage = const Value.absent(),
                Value<String?> customFailureMessage = const Value.absent(),
                Value<WeekendDays?> weekendDays = const Value.absent(),
                Value<String?> goalType = const Value.absent(),
                Value<double?> goalValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                type: type,
                trackingType: trackingType,
                displayMode: displayMode,
                icon: icon,
                color: color,
                isArchived: isArchived,
                notes: notes,
                category: category,
                frequency: frequency,
                customDays: customDays,
                targetFrequency: targetFrequency,
                targetValue: targetValue,
                unit: unit,
                customUnit: customUnit,
                pauseStartDate: pauseStartDate,
                pauseEndDate: pauseEndDate,
                isPaused: isPaused,
                customSuccessMessage: customSuccessMessage,
                customFailureMessage: customFailureMessage,
                weekendDays: weekendDays,
                goalType: goalType,
                goalValue: goalValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int type,
                required int trackingType,
                required int displayMode,
                Value<int?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                required bool isArchived,
                Value<String?> notes = const Value.absent(),
                Value<int?> category = const Value.absent(),
                required int frequency,
                required List<int> customDays,
                Value<int?> targetFrequency = const Value.absent(),
                Value<double?> targetValue = const Value.absent(),
                required int unit,
                Value<String?> customUnit = const Value.absent(),
                Value<DateTime?> pauseStartDate = const Value.absent(),
                Value<DateTime?> pauseEndDate = const Value.absent(),
                required bool isPaused,
                Value<String?> customSuccessMessage = const Value.absent(),
                Value<String?> customFailureMessage = const Value.absent(),
                Value<WeekendDays?> weekendDays = const Value.absent(),
                Value<String?> goalType = const Value.absent(),
                Value<double?> goalValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                type: type,
                trackingType: trackingType,
                displayMode: displayMode,
                icon: icon,
                color: color,
                isArchived: isArchived,
                notes: notes,
                category: category,
                frequency: frequency,
                customDays: customDays,
                targetFrequency: targetFrequency,
                targetValue: targetValue,
                unit: unit,
                customUnit: customUnit,
                pauseStartDate: pauseStartDate,
                pauseEndDate: pauseEndDate,
                isPaused: isPaused,
                customSuccessMessage: customSuccessMessage,
                customFailureMessage: customFailureMessage,
                weekendDays: weekendDays,
                goalType: goalType,
                goalValue: goalValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitEntriesRefs) db.habitEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitEntriesRefs)
                    await $_getPrefetchedData<
                      HabitData,
                      $HabitsTable,
                      HabitEntryData
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).habitEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitData,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitData, $$HabitsTableReferences),
      HabitData,
      PrefetchHooks Function({bool habitEntriesRefs})
    >;
typedef $$HabitEntriesTableCreateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      required String habitId,
      required DateTime date,
      required int count,
      Value<double?> value,
      Value<String?> unit,
      Value<String?> notes,
      required bool isSkipped,
      Value<bool> isArchived,
    });
typedef $$HabitEntriesTableUpdateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      Value<String> habitId,
      Value<DateTime> date,
      Value<int> count,
      Value<double?> value,
      Value<String?> unit,
      Value<String?> notes,
      Value<bool> isSkipped,
      Value<bool> isArchived,
    });

final class $$HabitEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitEntryData> {
  $$HabitEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_entries__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitEntriesTable,
          HabitEntryData,
          $$HabitEntriesTableFilterComposer,
          $$HabitEntriesTableOrderingComposer,
          $$HabitEntriesTableAnnotationComposer,
          $$HabitEntriesTableCreateCompanionBuilder,
          $$HabitEntriesTableUpdateCompanionBuilder,
          (HabitEntryData, $$HabitEntriesTableReferences),
          HabitEntryData,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitEntriesTableTableManager(_$AppDatabase db, $HabitEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => HabitEntriesCompanion(
                id: id,
                habitId: habitId,
                date: date,
                count: count,
                value: value,
                unit: unit,
                notes: notes,
                isSkipped: isSkipped,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String habitId,
                required DateTime date,
                required int count,
                Value<double?> value = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required bool isSkipped,
                Value<bool> isArchived = const Value.absent(),
              }) => HabitEntriesCompanion.insert(
                id: id,
                habitId: habitId,
                date: date,
                count: count,
                value: value,
                unit: unit,
                notes: notes,
                isSkipped: isSkipped,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$HabitEntriesTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$HabitEntriesTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitEntriesTable,
      HabitEntryData,
      $$HabitEntriesTableFilterComposer,
      $$HabitEntriesTableOrderingComposer,
      $$HabitEntriesTableAnnotationComposer,
      $$HabitEntriesTableCreateCompanionBuilder,
      $$HabitEntriesTableUpdateCompanionBuilder,
      (HabitEntryData, $$HabitEntriesTableReferences),
      HabitEntryData,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> color,
      Value<int?> icon,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> color,
      Value<int?> icon,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryData,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryData,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryData>,
          ),
          CategoryData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<int?> icon = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                color: color,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> color = const Value.absent(),
                Value<int?> icon = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                color: color,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryData,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryData,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryData>,
      ),
      CategoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db, _db.habitEntries);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
}
