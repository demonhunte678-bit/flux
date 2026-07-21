import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/data/index.dart';

class DashboardPage extends ConsumerWidget {
  final ScrollController scrollController;

  const DashboardPage({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error loading habits: $err'))),
      data: (allHabits) {
        final activeHabits = allHabits.where((h) => !h.isArchived).toList();

        int totalPositive = 0;
        int totalNegative = 0;
        int bestStreak = 0;
        String bestStreakHabit = '';

        for (var habit in activeHabits) {
          totalPositive += habit.positiveCount;
          totalNegative += habit.negativeCount;

          if (habit.currentStreak > bestStreak) {
            bestStreak = habit.currentStreak;
            bestStreakHabit = habit.name;
          }
        }

        int totalDays = totalPositive + totalNegative;
        final overallSuccessRate = totalDays > 0 ? (totalPositive / totalDays) * 100 : 0.0;

        return Scaffold(
          body: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Success Rate',
                      '${overallSuccessRate.toStringAsFixed(0)}%',
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      'Best Streak',
                      '$bestStreak Days',
                      Icons.flash_on,
                      Colors.orange,
                      subtitle: bestStreakHabit.isNotEmpty ? 'on $bestStreakHabit' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Success Rate History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getLineChartSpots(activeHabits),
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<FlSpot> _getLineChartSpots(List<Habit> habits) {
    final spots = <FlSpot>[];
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      int totalDue = 0;
      int doneCount = 0;
      for (var habit in habits) {
        if (habit.isDueOnDate(date, weekendDaysSetting: habit.weekendDays)) {
          totalDue++;
          final entry = habit.entries.firstWhereOrNull(
            (e) => DateUtils.isSameDay(e.date, date),
          );
          if (entry != null && habit.isPositiveDay(entry)) {
            doneCount++;
          }
        }
      }
      final rate = totalDue > 0 ? (doneCount / totalDue) * 100 : 0.0;
      spots.add(FlSpot(i.toDouble(), rate));
    }
    return spots;
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
