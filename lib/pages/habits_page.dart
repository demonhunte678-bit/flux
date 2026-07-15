import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flux/pages/index.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';

class HabitsPage extends ConsumerWidget {
  final ScrollController scrollController;
  final VoidCallback onAddHabit;

  const HabitsPage({
    super.key,
    required this.scrollController,
    required this.onAddHabit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(habitsPageProvider);
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: onAddHabit,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          HabitsHeader(
            overallSuccessRate: pageState.overallSuccessRate,
            hasHabits: pageState.filteredHabits.isNotEmpty,
          ),
          SuccessRateCard(
            overallSuccessRate: pageState.overallSuccessRate,
            show: settingsState.showSuccessRate,
          ),
          DaySelector(
            selectedDate: pageState.selectedDate,
            onDateSelected: (date) {
              ref.read(habitsPageProvider.notifier).setSelectedDate(date);
            },
          ),
          CategoryFilterRow(
            categories: pageState.categories,
            selectedCategory: pageState.selectedCategory,
            onCategorySelected: (cat) {
              ref.read(habitsPageProvider.notifier).setSelectedCategory(cat);
            },
          ),
          Expanded(
            child: HabitsList(
              filteredHabits: pageState.filteredHabits,
              scrollController: scrollController,
              selectedDate: pageState.selectedDate,
              onTap: (habit) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitDetailPage(habit: habit),
                  ),
                );
              },
              onCompletionTap: (habit) => _toggleHabitCompletion(context, ref, habit, pageState.selectedDate),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleHabitCompletion(BuildContext context, WidgetRef ref, Habit habit, DateTime selectedDate) {
    final entry = habit.entries.firstWhereOrNull(
      (e) =>
          e.date.year == selectedDate.year &&
          e.date.month == selectedDate.month &&
          e.date.day == selectedDate.day,
    );

    if (entry == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddEntryDialog(
          habit: habit,
          selectedDate: selectedDate,
          onSave: (newEntry) async {
            await ref.read(habitsProvider.notifier).addEntry(habit, newEntry);
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Entry Notes/Value'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddEntryDialog(
                      habit: habit,
                      selectedDate: selectedDate,
                      onSave: (updatedEntry) async {
                        await ref
                            .read(habitsProvider.notifier)
                            .updateEntry(habit, entry, updatedEntry);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Entry'),
                onTap: () async {
                  await ref
                      .read(habitsProvider.notifier)
                      .deleteEntry(habit, entry);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
