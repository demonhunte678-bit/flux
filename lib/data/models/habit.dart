import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
import 'package:flux/index.dart';

class Habit {
  String id;
  String name;
  HabitType type;
  TrackingType trackingType;
  ReportDisplay displayMode;
  HabitSymbol symbol;
  List<HabitEntry> entries;
  Color? color;
  bool isArchived;
  String? notes;

  // Enhanced functionality fields
  Category? category;
  HabitFrequency frequency;
  List<int> customDays;
  int? targetFrequency;
  double? targetValue;
  HabitUnit unit;
  String? customUnit;
  DateTime? pauseStartDate;
  DateTime? pauseEndDate;
  bool isPaused;

  WeekendDays? weekendDays;
  GoalType? goalType;
  double? goalValue;

  // Custom motivational messages
  String? customSuccessMessage;
  String? customFailureMessage;

  Habit({
    String? id,
    required this.name,
    this.type = HabitType.good,
    this.trackingType = TrackingType.check,
    this.displayMode = ReportDisplay.rate,
    HabitSymbol? symbol,
    this.color,
    this.isArchived = false,
    this.notes,
    this.category,
    this.frequency = HabitFrequency.daily,
    this.customDays = const [],
    this.targetFrequency,
    this.targetValue,
    this.unit = HabitUnit.count,
    this.customUnit,
    this.pauseStartDate,
    this.pauseEndDate,
    this.isPaused = false,
    this.weekendDays = WeekendDays.saturdaySunday,
    this.goalType,
    this.goalValue,
    List<HabitEntry>? entries,
    this.customSuccessMessage,
    this.customFailureMessage,
  }) : id = id ?? const Uuid().v4(),
       symbol = symbol ?? HabitsIcon.getSymbol(null),
       entries = entries ?? [];

  bool isPositiveDay(HabitEntry entry) {
    if (entry.isSkipped) return true;

    if (type == HabitType.good) {
      if (trackingType == TrackingType.check) {
        return entry.value > 0;
      } else {
        final target = targetValue ?? 0.0;
        return target > 0 ? entry.value >= target : entry.value > 0;
      }
    } else {
      final limit = targetValue ?? 0.0;
      return entry.value <= limit;
    }
  }

  bool isDueOnDate(DateTime date, {WeekendDays? weekendDaysSetting}) {
    if (isPaused) {
      if (pauseStartDate != null && date.isAfter(pauseStartDate!.subtract(const Duration(days: 1)))) {
        if (pauseEndDate == null || date.isBefore(pauseEndDate!.add(const Duration(days: 1)))) {
          return false;
        }
      }
    }

    final targetDate = DateTime(date.year, date.month, date.day);
    final weekendSetting = weekendDaysSetting ?? this.weekendDays ?? WeekendDays.saturdaySunday;

    final List<int> weekendDays;
    if (weekendSetting == WeekendDays.fridaySaturday) {
      weekendDays = [5, 6];
    } else if (weekendSetting == WeekendDays.thursdayFriday) {
      weekendDays = [4, 5];
    } else {
      weekendDays = [6, 7];
    }

    switch (frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekdays:
        return !weekendDays.contains(date.weekday);
      case HabitFrequency.weekends:
        return weekendDays.contains(date.weekday);
      case HabitFrequency.customDays:
        final todayIndex = date.weekday % 7;
        return customDays.contains(todayIndex);
      case HabitFrequency.xTimesPerWeek:
      case HabitFrequency.xTimesPerMonth:
        return _checkFrequencyTarget(targetDate);
    }
  }

  bool isDueToday({WeekendDays? weekendDaysSetting}) {
    return isDueOnDate(DateTime.now(), weekendDaysSetting: weekendDaysSetting);
  }

  String getFrequencyDisplayText({WeekendDays? weekendSetting}) {
    final weekend = weekendSetting ?? this.weekendDays ?? WeekendDays.saturdaySunday;

    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekdays:
        if (weekend == WeekendDays.fridaySaturday) return 'Weekdays (Sun-Thu)';
        if (weekend == WeekendDays.thursdayFriday) return 'Weekdays (Sat-Wed)';
        return 'Weekdays (Mon-Fri)';
      case HabitFrequency.weekends:
        if (weekend == WeekendDays.fridaySaturday) return 'Weekends (Fri-Sat)';
        if (weekend == WeekendDays.thursdayFriday) return 'Weekends (Thu-Fri)';
        return 'Weekends (Sat-Sun)';
      case HabitFrequency.customDays:
        final dayNames = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        final selectedDays = customDays.map((i) => dayNames[i]).join(', ');
        return 'Custom Days ($selectedDays)';
      case HabitFrequency.xTimesPerWeek:
        return '$targetFrequency times per week';
      case HabitFrequency.xTimesPerMonth:
        return '$targetFrequency times per month';
    }
  }

  bool _checkFrequencyTarget(DateTime today) {
    if (targetFrequency == null) return true;

    if (frequency == HabitFrequency.xTimesPerWeek) {
      final weekStart = today.subtract(Duration(days: today.weekday % 7));
      final weekEnd = weekStart.add(Duration(days: 6));
      final weekEntries = entries
          .where(
            (e) =>
                e.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
                e.date.isBefore(weekEnd.add(Duration(days: 1))) &&
                isPositiveDay(e),
          )
          .length;
      return weekEntries < targetFrequency!;
    } else if (frequency == HabitFrequency.xTimesPerMonth) {
      final monthStart = DateTime(today.year, today.month, 1);
      final monthEnd = DateTime(today.year, today.month + 1, 0);
      final monthEntries = entries
          .where(
            (e) =>
                e.date.isAfter(monthStart.subtract(Duration(days: 1))) &&
                e.date.isBefore(monthEnd.add(Duration(days: 1))) &&
                isPositiveDay(e),
          )
          .length;
      return monthEntries < targetFrequency!;
    }

    return true;
  }

  String getTimeSinceLastFailure() {
    if (type != HabitType.bad || entries.isEmpty) return "No data";

    final failureEntries = entries
        .where((e) => !isPositiveDay(e) && !e.isSkipped)
        .toList();
    if (failureEntries.isEmpty) {
      final firstEntry = entries.first;
      final duration = DateTime.now().difference(firstEntry.date);
      return _formatDuration(duration);
    }

    failureEntries.sort((a, b) => b.date.compareTo(a.date));
    final lastFailure = failureEntries.first;
    final duration = DateTime.now().difference(lastFailure.date);
    return _formatDuration(duration);
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return "${duration.inDays}d clean";
    } else if (duration.inHours > 0) {
      return "${duration.inHours}h clean";
    } else {
      return "${duration.inMinutes}m clean";
    }
  }

  List<HabitEntry> get activeEntries => entries.where((e) => !e.isArchived).toList();

  int get positiveCount => activeEntries.where((e) => isPositiveDay(e)).length;
  int get negativeCount => activeEntries.length - positiveCount;
  double get successRate {
    final active = activeEntries;
    if (active.isEmpty) return 0;

    double totalPoints = 0;
    for (var entry in active) {
      if (entry.isSkipped) {
        totalPoints += 1.0;
        continue;
      }

      if (type == HabitType.bad) {
        final limit = targetValue ?? 0.0;
        final actual = entry.value;
        if (actual <= limit) {
          totalPoints += 1.0;
        } else {
          final excess = actual - limit;
          final dayScore = 0.0 - (excess * 0.25);
          totalPoints += dayScore.clamp(-1.0, 1.0);
        }
      } else {
        totalPoints += isPositiveDay(entry) ? 1.0 : 0.0;
      }
    }

    final rawRate = (totalPoints / active.length) * 100;
    return rawRate.clamp(0.0, 100.0);
  }

  int get currentStreak {
    final active = activeEntries;
    if (active.isEmpty) return 0;

    int streak = 0;
    var checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    while (true) {
      final isDue = isDueOnDate(checkDate, weekendDaysSetting: weekendDays);
      if (isDue) {
        final entry = active.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, checkDate));
        final isSuccess = entry != null && !entry.isSkipped && isPositiveDay(entry);

        if (isSuccess) {
          streak++;
        } else {
          // If it is today and they haven't completed it yet, don't break the streak just yet
          if (DateUtils.isSameDay(checkDate, DateTime.now())) {
            // Keep going to look at previous days
          } else {
            break;
          }
        }
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
      
      if (streak > active.length + 30 || checkDate.isBefore(DateTime.now().subtract(const Duration(days: 365)))) {
        break;
      }
    }
    return streak;
  }

  int get bestStreak {
    final active = activeEntries;
    if (active.isEmpty) return 0;

    var earliestDate = active.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
    earliestDate = DateTime(earliestDate.year, earliestDate.month, earliestDate.day);
    
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    int currentBest = 0;
    int current = 0;

    var checkDate = earliestDate;
    while (!checkDate.isAfter(today)) {
      final isDue = isDueOnDate(checkDate, weekendDaysSetting: weekendDays);
      if (isDue) {
        final entry = active.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, checkDate));
        final isSuccess = entry != null && !entry.isSkipped && isPositiveDay(entry);

        if (isSuccess) {
          current++;
          if (current > currentBest) {
            currentBest = current;
          }
        } else {
          if (!DateUtils.isSameDay(checkDate, today)) {
            current = 0;
          }
        }
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }

    return currentBest;
  }

  bool get hasEntries => activeEntries.isNotEmpty;

  double getTotalValue() {
    return activeEntries.fold(0.0, (sum, e) => sum + e.value);
  }

  double getAverageValue() {
    final active = activeEntries;
    if (active.isEmpty) return 0.0;
    return getTotalValue() / active.length;
  }

  String getUnitDisplayName() {
    switch (unit) {
      case HabitUnit.count:
        return 'times';
      case HabitUnit.minutes:
        return 'min';
      case HabitUnit.hours:
        return 'hrs';
      case HabitUnit.pages:
        return 'pages';
      case HabitUnit.kilometers:
        return 'km';
      case HabitUnit.miles:
        return 'miles';
      case HabitUnit.grams:
        return 'g';
      case HabitUnit.pounds:
        return 'lbs';
      case HabitUnit.dollars:
        return '\$';
      case HabitUnit.custom:
        return customUnit ?? 'units';
    }
  }

  int get longestNegativeStreak {
    if (entries.isEmpty) return 0;

    int currentNegative = 0;
    int maxNegative = 0;

    var sortedEntries = [...entries]..sort((a, b) => a.date.compareTo(b.date));

    for (var entry in sortedEntries) {
      if (!isPositiveDay(entry)) {
        currentNegative++;
        if (currentNegative > maxNegative) {
          maxNegative = currentNegative;
        }
      } else {
        currentNegative = 0;
      }
    }

    return maxNegative;
  }

  bool isStreakMilestone() {
    final milestones = [7, 14, 21, 30, 50, 75, 100, 150, 200, 365];
    return milestones.contains(currentStreak);
  }
}
