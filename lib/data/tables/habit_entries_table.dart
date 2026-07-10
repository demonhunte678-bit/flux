import 'package:drift/drift.dart';
import 'habits_table.dart';

@DataClassName('HabitEntryData')
class HabitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get count => integer()();
  RealColumn get value => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSkipped => boolean()();
}
