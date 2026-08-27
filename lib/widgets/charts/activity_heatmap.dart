import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux/index.dart';
import 'package:intl/intl.dart';
import 'package:flux/l10n/index.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<Habit> habits;

  const ActivityHeatmap({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    // Find the earliest entry date
    DateTime startDay = todayMidnight.subtract(const Duration(days: 90));
    DateTime? earliestEntry;
    for (var habit in habits) {
      for (var entry in habit.entries) {
        if (earliestEntry == null || entry.date.isBefore(earliestEntry)) {
          earliestEntry = entry.date;
        }
      }
    }

    if (earliestEntry != null) {
      final earliestMidnight = DateTime(earliestEntry.year, earliestEntry.month, earliestEntry.day);
      final threeMonthsAgo = todayMidnight.subtract(const Duration(days: 90));
      if (earliestMidnight.isBefore(threeMonthsAgo)) {
        startDay = threeMonthsAgo;
      } else {
        startDay = earliestMidnight;
      }
    }

    // Align starting date to Monday of that week
    final daysToMonday = startDay.weekday - 1;
    final alignedStartDate = startDay.subtract(Duration(days: daysToMonday));

    final totalDays = todayMidnight.difference(alignedStartDate).inDays + 1;
    final days = List.generate(
      totalDays,
      (index) => alignedStartDate.add(Duration(days: index)),
    );

    final List<List<DateTime>> weeks = [];
    List<DateTime> currentWeek = [];

    for (var day in days) {
      currentWeek.add(day);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    final primaryColor = Theme.of(context).colorScheme.primary;
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat.E(locale);
    final mondayChar = format.format(DateTime(2023, 1, 2)).substring(0, 1);
    final wednesdayChar = format.format(DateTime(2023, 1, 4)).substring(0, 1);
    final fridayChar = format.format(DateTime(2023, 1, 6)).substring(0, 1);
    final sundayChar = format.format(DateTime(2023, 1, 8)).substring(0, 1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habits.length == 1 ? context.l10n.activityHeatmap : context.l10n.aggregateActivityHeatmap,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          mondayChar,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          wednesdayChar,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          fridayChar,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          sundayChar,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: weeks.map((week) {
                      return Column(
                        children: week.map((date) {
                          final isFuture = date.isAfter(todayMidnight);

                          if (isFuture) {
                            return const SizedBox(
                              width: 14,
                              height: 14,
                              child: Padding(padding: EdgeInsets.all(2)),
                            );
                          }

                          Color squareColor = Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3);
                          String tooltipMsg =
                              '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.noEntries}';

                          if (habits.length == 1) {
                            final habit = habits[0];
                            final entry = habit.entries.firstWhereOrNull(
                              (e) =>
                                  e.date.year == date.year &&
                                  e.date.month == date.month &&
                                  e.date.day == date.day,
                            );

                            if (entry != null) {
                              if (entry.isSkipped) {
                                squareColor = Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.3);
                                tooltipMsg =
                                    '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.skippedDay}';
                              } else {
                                final isFailBased = habit.type == HabitType.bad;
                                final limit = habit.targetValue ?? 0.0;
                                final actual = entry.value;

                                if (isFailBased) {
                                  if (actual <= limit) {
                                    double opacity = 1.0;
                                    if (limit > 0) {
                                      opacity = (1.0 - (actual / limit) * 0.6).clamp(0.4, 1.0);
                                    }
                                    squareColor = primaryColor.withValues(alpha: opacity);
                                    tooltipMsg =
                                        '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.succeededFailures(actual.toStringAsFixed(0), limit.toStringAsFixed(0))}';
                                  } else {
                                    final excess = actual - limit;
                                    double opacity = 0.4;
                                    if (excess > 1) opacity = 0.7;
                                    if (excess >= 4) opacity = 1.0;

                                    squareColor = Colors.red.withValues(alpha: opacity);
                                    tooltipMsg =
                                        '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.failedFailures(actual.toStringAsFixed(0), limit.toStringAsFixed(0))}';
                                  }
                                } else {
                                  final target = habit.targetValue ?? 1.0;
                                  final ratio = target > 0 ? (actual / target) : 1.0;

                                  if (ratio >= 1.0) {
                                    squareColor = primaryColor;
                                  } else if (ratio >= 0.8) {
                                    squareColor = primaryColor.withValues(alpha: 0.8);
                                  } else if (ratio >= 0.5) {
                                    squareColor = primaryColor.withValues(alpha: 0.5);
                                  } else if (ratio >= 0.3) {
                                    squareColor = primaryColor.withValues(alpha: 0.35);
                                  } else if (ratio > 0.0) {
                                    squareColor = primaryColor.withValues(alpha: 0.2);
                                  } else {
                                    squareColor = Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3);
                                  }
                                  tooltipMsg =
                                      '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.completedUnit(actual.toStringAsFixed(0), target.toStringAsFixed(0), habit.getUnitDisplayName())}';
                                }
                              }
                            }
                          } else {
                            int successes = 0;
                            int failures = 0;
                            int totalActive = 0;

                            for (var habit in habits) {
                              final entry = habit.entries.firstWhereOrNull(
                                (e) =>
                                    e.date.year == date.year &&
                                    e.date.month == date.month &&
                                    e.date.day == date.day,
                              );
                              if (entry != null && !entry.isSkipped) {
                                totalActive++;
                                if (habit.isPositiveDay(entry)) {
                                  successes++;
                                } else {
                                  failures++;
                                }
                              }
                            }

                            if (totalActive > 0) {
                              if (successes >= failures) {
                                final successRate = successes / totalActive;
                                double opacity = 0.25;
                                if (successRate >= 0.8) {
                                  opacity = 1.0;
                                } else if (successRate >= 0.5) opacity = 0.7;
                                else if (successRate >= 0.3) opacity = 0.4;

                                squareColor = primaryColor.withValues(alpha: opacity);
                              } else {
                                final failureRate = failures / totalActive;
                                double opacity = 0.4;
                                if (failureRate >= 0.8) {
                                  opacity = 1.0;
                                } else if (failureRate >= 0.5) opacity = 0.7;

                                squareColor = Colors.red.withValues(alpha: opacity);
                              }
                              tooltipMsg =
                                  '${DateFormat('MMM d, yyyy', locale).format(date)}: ${context.l10n.habitsCompleted(successes.toString(), totalActive.toString())}';
                            }
                          }

                          return Tooltip(
                            message: tooltipMsg,
                            child: Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: squareColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Less ',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const Text(
                  ' More',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
