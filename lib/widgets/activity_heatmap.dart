import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux/index.dart';
import 'package:intl/intl.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<Habit> habits;

  const ActivityHeatmap({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    // Calculate starting date: 26 weeks ago, aligned to Monday
    final startDay = todayMidnight.subtract(const Duration(days: 182));
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aggregate Activity Heatmap (Last 6 Months)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 14, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'M',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'W',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'F',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'S',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: weeks.map((week) {
                      return Column(
                        children: week.map((date) {
                          final isFuture = date.isAfter(todayMidnight);

                          int positiveCount = 0;
                          for (var habit in habits) {
                            final entry = habit.entries.firstWhereOrNull(
                              (e) =>
                                  e.date.year == date.year &&
                                  e.date.month == date.month &&
                                  e.date.day == date.day,
                            );
                            if (entry != null && habit.isPositiveDay(entry)) {
                              positiveCount++;
                            }
                          }

                          Color squareColor = Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3);
                          String tooltipMsg =
                              '${DateFormat('MMM d, yyyy').format(date)}: No habits completed';

                          if (isFuture) {
                            squareColor = Colors.transparent;
                            tooltipMsg = '';
                          } else if (positiveCount > 0) {
                            double opacity = 0.25;
                            if (positiveCount == 2) {
                              opacity = 0.5;
                            } else if (positiveCount == 3)
                              opacity = 0.75;
                            else if (positiveCount >= 4)
                              opacity = 1.0;

                            squareColor = primaryColor.withValues(
                              alpha: opacity,
                            );
                            tooltipMsg =
                                '${DateFormat('MMM d, yyyy').format(date)}: $positiveCount habit${positiveCount != 1 ? 's' : ''} completed';
                          }

                          if (isFuture) {
                            return const SizedBox(
                              width: 14,
                              height: 14,
                              child: Padding(padding: EdgeInsets.all(2)),
                            );
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
