import 'package:flutter/material.dart' show Color, IconData;
import 'package:flux/index.dart';

class HabitMapper {
  static Habit toDomain(HabitData row, List<HabitEntryData> entryRows) {
    final entries = entryRows.map(HabitEntryMapper.toDomain).toList();
    return Habit(
      id: row.id,
      name: row.name,
      type: HabitType.values[row.type],
      trackingType: TrackingType.values[row.trackingType],
      displayMode: ReportDisplay.values[row.displayMode],
      symbol: HabitsIcon.getSymbol(row.icon),
      color: row.color != null ? Color(row.color!) : null,
      isArchived: row.isArchived,
      notes: row.notes,
      category: _resolveCategory(row.category),
      frequency: HabitFrequency.values[row.frequency],
      customDays: row.customDays,
      targetFrequency: row.targetFrequency,
      targetValue: row.targetValue,
      unit: HabitUnit.values[row.unit],
      customUnit: row.customUnit,
      pauseStartDate: row.pauseStartDate,
      pauseEndDate: row.pauseEndDate,
      isPaused: row.isPaused,
      weekendDays: row.weekendDays,
      goalType: row.goalType != null ? GoalType.values.firstWhere((e) => e.name == row.goalType, orElse: () => GoalType.streak) : null,
      goalValue: row.goalValue,
      entries: entries,
      customSuccessMessage: row.customSuccessMessage,
      customFailureMessage: row.customFailureMessage,
    );
  }

  static HabitData toDb(Habit habit) {
    return HabitData(
      id: habit.id,
      name: habit.name,
      type: habit.type.index,
      trackingType: habit.trackingType.index,
      displayMode: habit.displayMode.index,
      icon: HabitsIcon.getSymbolId(habit.symbol),
      color: habit.color?.value,
      isArchived: habit.isArchived,
      notes: habit.notes,
      category: habit.category?.id,
      frequency: habit.frequency.index,
      customDays: habit.customDays,
      targetFrequency: habit.targetFrequency,
      targetValue: habit.targetValue,
      unit: habit.unit.index,
      customUnit: habit.customUnit,
      pauseStartDate: habit.pauseStartDate,
      pauseEndDate: habit.pauseEndDate,
      isPaused: habit.isPaused,
      weekendDays: habit.weekendDays,
      goalType: habit.goalType?.name,
      goalValue: habit.goalValue,
      customSuccessMessage: habit.customSuccessMessage,
      customFailureMessage: habit.customFailureMessage,
    );
  }

  static Category? _resolveCategory(int? id) {
    if (id == null) return null;
    if (id < 0) {
      final name = _getBuiltInCategoryName(id);
      return Category(id: id, name: name);
    } else {
      return Category.customCategories[id] ?? Category(id: id, name: 'Category $id');
    }
  }

  static String _getBuiltInCategoryName(int id) {
    switch (id) {
      case -1: return 'health';
      case -2: return 'mental';
      case -3: return 'growth';
      case -4: return 'finances';
      case -5: return 'home';
      case -6: return 'sleep';
      case -7: return 'relationships';
      default: return 'unknown';
    }
  }
}
