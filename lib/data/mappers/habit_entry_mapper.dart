import 'package:drift/drift.dart';
import 'package:flux/index.dart';

class HabitEntryMapper {
  static HabitEntry toDomain(HabitEntryData row) {
    return HabitEntry(
      date: row.date,
      value: row.value ?? row.count.toDouble(),
      unit: row.unit,
      notes: row.notes,
      isSkipped: row.isSkipped,
      isArchived: row.isArchived,
    );
  }

  static HabitEntriesCompanion toCompanion(String habitId, HabitEntry entry) {
    return HabitEntriesCompanion.insert(
      habitId: habitId,
      date: entry.date,
      count: entry.value.toInt(),
      value: Value(entry.value),
      unit: Value(entry.unit),
      notes: Value(entry.notes),
      isSkipped: entry.isSkipped,
      isArchived: Value(entry.isArchived),
    );
  }
}
