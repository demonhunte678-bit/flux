import 'package:drift/drift.dart';
import 'package:flux/index.dart';

class HabitsRepository {
  final AppDatabase _db;

  HabitsRepository(this._db);

  static final HabitsRepository instance = HabitsRepository(
    AppDatabase.instance,
  );

  Future<List<Habit>> loadAllHabits() async {
    final habitRows = await _db.select(_db.habits).get();
    final entryRows = await _db.select(_db.habitEntries).get();

    // Group entries by habit ID
    final entriesByHabit = <String, List<HabitEntryData>>{};
    for (final row in entryRows) {
      entriesByHabit.putIfAbsent(row.habitId, () => []).add(row);
    }

    return habitRows.map((row) {
      final entriesForHabit = entriesByHabit[row.id] ?? [];
      return HabitMapper.toDomain(row, entriesForHabit);
    }).toList();
  }

  Future<void> saveHabit(Habit habit) async {
    await _db.transaction(() async {
      final dbHabit = HabitMapper.toDb(habit);
      await _db.into(_db.habits).insertOnConflictUpdate(dbHabit);

      // Remove existing entries and replace
      await (_db.delete(
        _db.habitEntries,
      )..where((tbl) => tbl.habitId.equals(habit.id))).go();

      for (final entry in habit.entries) {
        final companion = HabitEntryMapper.toCompanion(habit.id, entry);
        await _db.into(_db.habitEntries).insert(companion);
      }
    });
  }

  Future<void> deleteHabit(String habitId) async {
    await (_db.delete(_db.habits)..where((tbl) => tbl.id.equals(habitId))).go();
  }

  Future<void> updateEntry(
    Habit habit,
    HabitEntry oldEntry,
    HabitEntry newEntry,
  ) async {
    await _db.transaction(() async {
      // Find the entry that matches habitId and date
      final query = _db.update(_db.habitEntries)
        ..where((tbl) => tbl.habitId.equals(habit.id))
        ..where((tbl) => tbl.date.equals(oldEntry.date));

      await query.write(
        HabitEntriesCompanion(
          date: Value(newEntry.date),
          count: Value(newEntry.value.toInt()),
          value: Value(newEntry.value),
          unit: Value(newEntry.unit),
          notes: Value(newEntry.notes),
          isSkipped: Value(newEntry.isSkipped),
        ),
      );

      // Update in-memory list
      final index = habit.entries.indexWhere(
        (e) => _isSameDay(e.date, oldEntry.date),
      );
      if (index != -1) {
        habit.entries[index] = newEntry;
      }
    });
  }

  Future<void> deleteEntry(Habit habit, HabitEntry entry) async {
    await (_db.delete(_db.habitEntries)
          ..where((tbl) => tbl.habitId.equals(habit.id))
          ..where((tbl) => tbl.date.equals(entry.date)))
        .go();
    habit.entries.removeWhere((e) => _isSameDay(e.date, entry.date));
  }

  Future<void> migrateFromJson(List<Habit> habitsList) async {
    for (final habit in habitsList) {
      await saveHabit(habit);
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
