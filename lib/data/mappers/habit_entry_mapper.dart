import 'package:drift/drift.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';

class HabitEntryMapper {
  static HabitEntry toDomain(HabitEntryData row) {
    return HabitEntry(
      date: row.date,
      count: row.count,
      value: row.value,
      unit: row.unit,
      notes: row.notes,
      isSkipped: row.isSkipped,
    );
  }

  static HabitEntriesCompanion toCompanion(String habitId, HabitEntry entry) {
    return HabitEntriesCompanion.insert(
      habitId: habitId,
      date: entry.date,
      count: entry.count,
      value: Value(entry.value),
      unit: Value(entry.unit),
      notes: Value(entry.notes),
      isSkipped: entry.isSkipped,
    );
  }
}
