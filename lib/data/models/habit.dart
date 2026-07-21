import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flux/index.dart';

class Habit {
  String id;
  String name;
  HabitType type;
  ReportDisplay displayMode;
  IconData? icon;
  List<HabitEntry> entries;
  Color? color;
  bool isArchived;
  String? notes;

  // Enhanced functionality fields
  String? category;
  HabitFrequency frequency;
  List<int> customDays;
  int? targetFrequency;
  double? targetValue;
  HabitUnit unit;
  String? customUnit;
  DateTime? pauseStartDate;
  DateTime? pauseEndDate;
  bool isPaused;

  String? weekendDays;
  String? goalType;
  double? goalValue;

  // Custom motivational messages
  List<String> motivationalMessages;
  String? customSuccessMessage;
  String? customFailureMessage;

  Habit({
    String? id,
    required this.name,
    this.type = HabitType.DoneBased,
    this.displayMode = ReportDisplay.Rate,
    this.icon,
    this.color,
    this.isArchived = false,
    this.notes,
    this.category,
    this.frequency = HabitFrequency.Daily,
    this.customDays = const [],
    this.targetFrequency,
    this.targetValue,
    this.unit = HabitUnit.Count,
    this.customUnit,
    this.pauseStartDate,
    this.pauseEndDate,
    this.isPaused = false,
    this.weekendDays = 'Saturday & Sunday',
    this.goalType,
    this.goalValue,
    List<HabitEntry>? entries,
    List<String>? motivationalMessages,
    this.customSuccessMessage,
    this.customFailureMessage,
  }) : id = id ?? const Uuid().v4(),
       entries = entries ?? [],
       motivationalMessages =
           motivationalMessages ??
           [
             "You've got this! 💪",
             "Every day is a new opportunity! ✨",
             "Small steps lead to big changes! 🚀",
             "Consistency is key! 🔑",
             "Believe in yourself! 🌟",
           ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.index,
    'displayMode': displayMode.index,
    'icon': icon?.codePoint,
    'color': color?.toARGB32(),
    'isArchived': isArchived,
    'notes': notes,
    'category': category,
    'frequency': frequency.index,
    'customDays': customDays,
    'targetFrequency': targetFrequency,
    'targetValue': targetValue,
    'unit': unit.index,
    'customUnit': customUnit,
    'pauseStartDate': pauseStartDate?.toIso8601String(),
    'pauseEndDate': pauseEndDate?.toIso8601String(),
    'isPaused': isPaused,
    'weekendDays': weekendDays,
    'goalType': goalType,
    'goalValue': goalValue,
    'entries': entries.map((e) => e.toJson()).toList(),
    'motivationalMessages': motivationalMessages,
    'customSuccessMessage': customSuccessMessage,
    'customFailureMessage': customFailureMessage,
  };

  static Habit fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    name: json['name'],
    type: HabitType.values[json['type'] ?? 1],
    displayMode: ReportDisplay.values[json['displayMode'] ?? 0],
    icon: json['icon'] != null
        ? IconData(json['icon'], fontFamily: 'MaterialIcons')
        : null,
    color: json['color'] != null ? Color(json['color']) : null,
    isArchived: json['isArchived'] ?? false,
    notes: json['notes'],
    category: json['category'],
    frequency: HabitFrequency.values[json['frequency'] ?? 0],
    customDays: List<int>.from(json['customDays'] ?? []),
    targetFrequency: json['targetFrequency'],
    targetValue: json['targetValue']?.toDouble(),
    unit: HabitUnit.values[json['unit'] ?? 0],
    customUnit: json['customUnit'],
    pauseStartDate: json['pauseStartDate'] != null
        ? DateTime.parse(json['pauseStartDate'])
        : null,
    pauseEndDate: json['pauseEndDate'] != null
        ? DateTime.parse(json['pauseEndDate'])
        : null,
    isPaused: json['isPaused'] ?? false,
    weekendDays: json['weekendDays'] ?? 'Saturday & Sunday',
    goalType: json['goalType'],
    goalValue: json['goalValue']?.toDouble(),
    entries:
        (json['entries'] as List?)
            ?.map((e) => HabitEntry.fromJson(e))
            .toList() ??
        [],
    motivationalMessages: List<String>.from(
      json['motivationalMessages'] ??
          [
            "You've got this! 💪",
            "Every day is a new opportunity! ✨",
            "Small steps lead to big changes! 🚀",
            "Consistency is key! 🔑",
            "Believe in yourself! 🌟",
          ],
    ),
    customSuccessMessage: json['customSuccessMessage'],
    customFailureMessage: json['customFailureMessage'],
  );

  bool isPositiveDay(HabitEntry entry) {
    if (entry.isSkipped) return true;

    switch (type) {
      case HabitType.FailBased:
        final limit = targetValue ?? 0.0;
        return entry.value <= limit;
      case HabitType.SuccessBased:
        final target = targetValue ?? 0.0;
        return target > 0 ? entry.value >= target : entry.value > 0;
      case HabitType.DoneBased:
        return entry.value > 0;
    }
  }

  bool isDueOnDate(DateTime date, {String? weekendDaysSetting}) {
    if (isPaused) {
      if (pauseStartDate != null && date.isAfter(pauseStartDate!.subtract(const Duration(days: 1)))) {
        if (pauseEndDate == null || date.isBefore(pauseEndDate!.add(const Duration(days: 1)))) {
          return false;
        }
      }
    }

    final targetDate = DateTime(date.year, date.month, date.day);
    final weekendSetting = weekendDaysSetting ?? this.weekendDays ?? 'Saturday & Sunday';

    final List<int> weekendDays;
    if (weekendSetting == 'Friday & Saturday') {
      weekendDays = [5, 6];
    } else if (weekendSetting == 'Thursday & Friday') {
      weekendDays = [4, 5];
    } else {
      weekendDays = [6, 7];
    }

    switch (frequency) {
      case HabitFrequency.Daily:
        return true;
      case HabitFrequency.Weekdays:
        return !weekendDays.contains(date.weekday);
      case HabitFrequency.Weekends:
        return weekendDays.contains(date.weekday);
      case HabitFrequency.CustomDays:
        final todayIndex = date.weekday % 7;
        return customDays.contains(todayIndex);
      case HabitFrequency.XTimesPerWeek:
      case HabitFrequency.XTimesPerMonth:
        return _checkFrequencyTarget(targetDate);
    }
  }

  bool isDueToday({String? weekendDaysSetting}) {
    return isDueOnDate(DateTime.now(), weekendDaysSetting: weekendDaysSetting);
  }

  String getFrequencyDisplayText({String? weekendSetting}) {
    final weekend = weekendSetting ?? 'Saturday & Sunday';

    switch (frequency) {
      case HabitFrequency.Daily:
        return 'Daily';
      case HabitFrequency.Weekdays:
        if (weekend == 'Friday & Saturday') return 'Weekdays (Sun-Thu)';
        if (weekend == 'Thursday & Friday') return 'Weekdays (Sat-Wed)';
        return 'Weekdays (Mon-Fri)';
      case HabitFrequency.Weekends:
        if (weekend == 'Friday & Saturday') return 'Weekends (Fri-Sat)';
        if (weekend == 'Thursday & Friday') return 'Weekends (Thu-Fri)';
        return 'Weekends (Sat-Sun)';
      case HabitFrequency.CustomDays:
        final dayNames = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        final selectedDays = customDays.map((i) => dayNames[i]).join(', ');
        return 'Custom Days ($selectedDays)';
      case HabitFrequency.XTimesPerWeek:
        return '$targetFrequency times per week';
      case HabitFrequency.XTimesPerMonth:
        return '$targetFrequency times per month';
    }
  }

  bool _checkFrequencyTarget(DateTime today) {
    if (targetFrequency == null) return true;

    if (frequency == HabitFrequency.XTimesPerWeek) {
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
    } else if (frequency == HabitFrequency.XTimesPerMonth) {
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
    if (type != HabitType.FailBased || entries.isEmpty) return "No data";

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

  int get positiveCount => entries.where((e) => isPositiveDay(e)).length;
  int get negativeCount => entries.length - positiveCount;
  double get successRate {
    if (entries.isEmpty) return 0;

    double totalPoints = 0;
    for (var entry in entries) {
      if (entry.isSkipped) {
        totalPoints += 1.0;
        continue;
      }

      if (type == HabitType.FailBased) {
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

    final rawRate = (totalPoints / entries.length) * 100;
    return rawRate.clamp(0.0, 100.0);
  }

  int get currentStreak {
    int streak = 0;
    if (entries.isEmpty) return 0;

    var sortedEntries = [...entries]..sort((a, b) => b.date.compareTo(a.date));

    if (frequency != HabitFrequency.Daily) {
      return _calculateFrequencyStreak(sortedEntries);
    }

    for (var entry in sortedEntries) {
      if (isPositiveDay(entry)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateFrequencyStreak(List<HabitEntry> sortedEntries) {
    int streak = 0;
    for (var entry in sortedEntries) {
      if (isPositiveDay(entry)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int get bestStreak {
    if (entries.isEmpty) return 0;

    int currentBest = 0;
    int current = 0;

    var sortedEntries = [...entries]..sort((a, b) => a.date.compareTo(b.date));

    for (var entry in sortedEntries) {
      if (isPositiveDay(entry)) {
        current++;
        if (current > currentBest) {
          currentBest = current;
        }
      } else {
        current = 0;
      }
    }

    return currentBest;
  }

  bool get hasEntries => entries.isNotEmpty;

  double getTotalValue() {
    return entries.fold(0.0, (sum, e) => sum + e.value);
  }

  double getAverageValue() {
    if (entries.isEmpty) return 0.0;
    return getTotalValue() / entries.length;
  }

  String getUnitDisplayName() {
    switch (unit) {
      case HabitUnit.Count:
        return 'times';
      case HabitUnit.Minutes:
        return 'min';
      case HabitUnit.Hours:
        return 'hrs';
      case HabitUnit.Pages:
        return 'pages';
      case HabitUnit.Kilometers:
        return 'km';
      case HabitUnit.Miles:
        return 'miles';
      case HabitUnit.Grams:
        return 'g';
      case HabitUnit.Pounds:
        return 'lbs';
      case HabitUnit.Dollars:
        return '\$';
      case HabitUnit.Custom:
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

  String getRandomMotivationalMessage() {
    if (motivationalMessages.isEmpty) return "Keep going! 💪";
    motivationalMessages.shuffle();
    return motivationalMessages.first;
  }

  bool isStreakMilestone() {
    final milestones = [7, 14, 21, 30, 50, 75, 100, 150, 200, 365];
    return milestones.contains(currentStreak);
  }

  String getMilestoneMessage() {
    switch (currentStreak) {
      case 7:
        return "🔥 One week strong! You're building momentum!";
      case 14:
        return "⚡ Two weeks of excellence! You're unstoppable!";
      case 21:
        return "💎 Three weeks! This is becoming a real habit!";
      case 30:
        return "🏆 One month champion! You've proven your dedication!";
      case 50:
        return "🚀 Fifty days! You're in the elite zone now!";
      case 75:
        return "👑 Seventy-five days! You're absolutely crushing it!";
      case 100:
        return "🎖️ ONE HUNDRED DAYS! You're a true habit master!";
      case 150:
        return "🌟 150 days! Your consistency is inspirational!";
      case 200:
        return "🔥 200 days! You've transcended ordinary limits!";
      case 365:
        return "🏅 ONE FULL YEAR! You are a legend!";
      default:
        return "🎉 Amazing streak! Keep the momentum going!";
    }
  }
}
