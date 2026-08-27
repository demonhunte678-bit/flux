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
    final frequencyText = habit.getFrequencyDisplayText(
      weekendSetting: habit.weekendDays,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Type', _getHabitTypeText(habit.type)),
                _buildStatItem(context, 'Frequency', frequencyText),
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
      case HabitType.bad:
        return 'Bad Habit (Avoid)';
      case HabitType.good:
        return 'Good Habit (Build)';
    }
  }
}
