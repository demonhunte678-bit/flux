import 'package:csv/csv.dart';
import 'package:flutter/material.dart' show Color;
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:flux/index.dart';






class HabitsRepository {
  final AppDatabase _db;

  HabitsRepository(this._db);

  static final HabitsRepository instance = HabitsRepository(
    AppDatabase.instance,
  );

  Future<void> loadCustomCategories() async {
    final rows = await _db.select(_db.categories).get();
    Category.customCategories.clear();
    for (final row in rows) {
      Category.customCategories[row.id] = Category(
        id: row.id,
        name: row.name,
        color: row.color != null ? Color(row.color!) : null,
        iconSymbol: row.icon != null ? HabitsIcon.getSymbol(row.icon) : null,
      );
    }
  }

  Future<void> saveCategory(Category category) async {
    final companion = CategoryData(
      id: category.id,
      name: category.name,
      color: category.color?.value,
      icon: category.iconSymbol != null ? HabitsIcon.getSymbolId(category.iconSymbol!) : null,
    );
    await _db.into(_db.categories).insertOnConflictUpdate(companion);
    Category.customCategories[category.id] = category;
  }

  Future<List<Habit>> loadAllHabits() async {
    await loadCustomCategories();
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

  Future<void> saveEntry(Habit habit, HabitEntry entry) async {
    await _db.transaction(() async {
      final companion = HabitEntryMapper.toCompanion(habit.id, entry);
      await _db.into(_db.habitEntries).insertOnConflictUpdate(companion);

      // Update in-memory list
      final index = habit.entries.indexWhere(
        (e) => _isSameDay(e.date, entry.date),
      );
      if (index != -1) {
        habit.entries[index] = entry;
      } else {
        habit.entries.add(entry);
      }
    });
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
          isArchived: Value(newEntry.isArchived),
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

  Future<void> archivePastEntries(Habit habit, DateTime cutOffDate) async {
    await _db.transaction(() async {
      final query = _db.update(_db.habitEntries)
        ..where((tbl) => tbl.habitId.equals(habit.id))
        ..where((tbl) => tbl.date.isSmallerThanValue(cutOffDate));

      await query.write(
        const HabitEntriesCompanion(
          isArchived: Value(true),
        ),
      );

      // Update in-memory list
      for (var entry in habit.entries) {
        if (entry.date.isBefore(cutOffDate)) {
          entry.isArchived = true;
        }
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

  String exportHabitToCsv(Habit habit) {
    final List<List<dynamic>> rows = [];

    // Header metadata block for AI friendly consumption
    rows.add(['# HABIT SUMMARY REPORT']);
    rows.add(['Habit Name', habit.name]);
    rows.add(['Category', habit.category?.name ?? 'Uncategorized']);
    rows.add(['Habit Type', habit.type.name]);
    rows.add(['Frequency', habit.getFrequencyDisplayText()]);
    rows.add(['Unit', habit.getUnitDisplayName()]);
    if (habit.targetValue != null) {
      rows.add(['Target / Limit Value', habit.targetValue]);
    }
    if (habit.goalType != null && habit.goalValue != null) {
      rows.add(['Goal Type', habit.goalType]);
      rows.add(['Goal Target', habit.goalValue]);
    }
    rows.add(['Current Streak', habit.currentStreak]);
    rows.add(['Best Streak', habit.bestStreak]);
    rows.add(['Success Rate (%)', habit.successRate.toStringAsFixed(1)]);
    rows.add(['Total Entries', habit.entries.length]);
    if (habit.notes != null && habit.notes!.isNotEmpty) {
      rows.add(['Habit Description / Notes', habit.notes]);
    }
    rows.add([]); // Blank line separator

    // Log table header
    rows.add([
      'Date',
      'Day of Week',
      'Value',
      'Unit',
      'Status',
      'Is Skipped',
      'Notes',
    ]);

    final sortedEntries = [...habit.entries]..sort((a, b) => b.date.compareTo(a.date));
    final DateFormat dateFmt = DateFormat('yyyy-MM-dd');
    final DateFormat dayFmt = DateFormat('EEEE');

    for (final entry in sortedEntries) {
      final isPositive = habit.isPositiveDay(entry);
      final status = entry.isSkipped
          ? 'Skipped'
          : (isPositive ? 'Success/Met' : 'Missed/Exceeded');

      rows.add([
        dateFmt.format(entry.date),
        dayFmt.format(entry.date),
        entry.value,
        entry.unit ?? habit.getUnitDisplayName(),
        status,
        entry.isSkipped ? 'Yes' : 'No',
        entry.notes ?? '',
      ]);
    }

    return ListToCsvConverter().convert(rows);
  }
}

