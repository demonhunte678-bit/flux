import 'package:flutter/material.dart' show Color, IconData;
import 'package:flux/index.dart';

class HabitMapper {
  static Habit toDomain(HabitData row, List<HabitEntryData> entryRows) {
    final entries = entryRows.map(HabitEntryMapper.toDomain).toList();
    return Habit(
      id: row.id,
      name: row.name,
      type: HabitType.values[row.type],
      displayMode: ReportDisplay.values[row.displayMode],
      icon: row.icon != null
          ? HabitsIcon.fromCodePoint(row.icon)
          : null,
      color: row.color != null ? Color(row.color!) : null,
      isArchived: row.isArchived,
      notes: row.notes,
      category: row.category,
      frequency: HabitFrequency.values[row.frequency],
      customDays: row.customDays,
      targetFrequency: row.targetFrequency,
      targetValue: row.targetValue,
      unit: HabitUnit.values[row.unit],
      customUnit: row.customUnit,
      pauseStartDate: row.pauseStartDate,
      pauseEndDate: row.pauseEndDate,
      isPaused: row.isPaused,
      entries: entries,
      motivationalMessages: row.motivationalMessages,
      customSuccessMessage: row.customSuccessMessage,
      customFailureMessage: row.customFailureMessage,
    );
  }

  static HabitData toDb(Habit habit) {
    return HabitData(
      id: habit.id,
      name: habit.name,
      type: habit.type.index,
      displayMode: habit.displayMode.index,
      icon: habit.icon?.codePoint,
      color: habit.color?.value,
      isArchived: habit.isArchived,
      notes: habit.notes,
      category: habit.category,
      frequency: habit.frequency.index,
      customDays: habit.customDays,
      targetFrequency: habit.targetFrequency,
      targetValue: habit.targetValue,
      unit: habit.unit.index,
      customUnit: habit.customUnit,
      pauseStartDate: habit.pauseStartDate,
      pauseEndDate: habit.pauseEndDate,
      isPaused: habit.isPaused,
      motivationalMessages: habit.motivationalMessages,
      customSuccessMessage: habit.customSuccessMessage,
      customFailureMessage: habit.customFailureMessage,
    );
  }
}
