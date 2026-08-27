import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flux/core/enums/weekend_days.dart';

@DataClassName('HabitData')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => integer()();
  IntColumn get trackingType => integer()();
  IntColumn get displayMode => integer()();
  IntColumn get icon => integer().nullable()();
  IntColumn get color => integer().nullable()();
  BoolColumn get isArchived => boolean()();
  TextColumn get notes => text().nullable()();

  // New fields
  IntColumn get category => integer().nullable()();
  IntColumn get frequency => integer()();
  TextColumn get customDays => text().map(const IntListConverter())();
  IntColumn get targetFrequency => integer().nullable()();
  RealColumn get targetValue => real().nullable()();
  IntColumn get unit => integer()();
  TextColumn get customUnit => text().nullable()();
  DateTimeColumn get pauseStartDate => dateTime().nullable()();
  DateTimeColumn get pauseEndDate => dateTime().nullable()();
  BoolColumn get isPaused => boolean()();

  TextColumn get customSuccessMessage => text().nullable()();
  TextColumn get customFailureMessage => text().nullable()();

  IntColumn get weekendDays => intEnum<WeekendDays>().nullable()();
  TextColumn get goalType => text().nullable()();
  RealColumn get goalValue => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    try {
      return List<int>.from(json.decode(fromDb));
    } catch (_) {
      return [];
    }
  }

  @override
  String toSql(List<int> value) {
    return json.encode(value);
  }
}
