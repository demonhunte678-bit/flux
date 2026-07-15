import 'package:flutter/material.dart';
import 'package:flux/data/index.dart';
import 'package:flux/index.dart';

class QuickStatsCard extends StatelessWidget {
  final Habit habit;
  final bool showSuccessRate;
  final bool showCurrentStreak;

  const QuickStatsCard({
    super.key,
    required this.habit,
    required this.showSuccessRate,
    required this.showCurrentStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Type', _getHabitTypeText(habit.type)),
                _buildStatItem(context, 'Frequency', _getFrequencyText(habit)),
              ],
            ),
            if (showSuccessRate || showCurrentStreak) ...[
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (showSuccessRate)
                    _buildStatItem(
                      context,
                      'Success Rate',
                      '${habit.successRate.toStringAsFixed(0)}%',
                    ),
                  if (showCurrentStreak)
                    _buildStatItem(
                      context,
                      'Current Streak',
                      '${habit.currentStreak} Days',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _getHabitTypeText(HabitType type) {
    switch (type) {
      case HabitType.FailBased:
        return 'Avoid (Failure-based)';
      case HabitType.SuccessBased:
        return 'Achieve (Success-based)';
      case HabitType.DoneBased:
        return 'Check (Done-based)';
      default:
        return '';
    }
  }

  String _getFrequencyText(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.Daily:
        return 'Daily';
      case HabitFrequency.Weekdays:
        return 'Weekdays (Mon-Fri)';
      case HabitFrequency.Weekends:
        return 'Weekends (Sat-Sun)';
      case HabitFrequency.CustomDays:
        final dayNames = const [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ];
        final selectedDays = habit.customDays
            .map((i) => dayNames[i])
            .join(', ');
        return 'Custom Days ($selectedDays)';
      case HabitFrequency.XTimesPerWeek:
        return '${habit.targetFrequency ?? 'X'} times per week';
      case HabitFrequency.XTimesPerMonth:
        return '${habit.targetFrequency ?? 'X'} times per month';
      default:
        return '';
    }
  }
}
