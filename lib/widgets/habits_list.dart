import 'package:flutter/material.dart';
import 'package:flux/data/index.dart';
import 'habit_list_item.dart';
import 'package:flux/l10n/index.dart';

class HabitsList extends StatelessWidget {
  final List<Habit> filteredHabits;
  final ScrollController scrollController;
  final DateTime selectedDate;
  final ValueChanged<Habit> onTap;
  final ValueChanged<Habit> onCompletionTap;

  const HabitsList({
    super.key,
    required this.filteredHabits,
    required this.scrollController,
    required this.selectedDate,
    required this.onTap,
    required this.onCompletionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredHabits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.noHabitsForToday,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.createHabitToGetStarted,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: filteredHabits.length,
      itemBuilder: (context, index) {
        final habit = filteredHabits[index];
        return HabitListItem(
          habit: habit,
          selectedDate: selectedDate,
          onTap: () => onTap(habit),
          onCompletionTap: () => onCompletionTap(habit),
        );
      },
    );
  }
}
