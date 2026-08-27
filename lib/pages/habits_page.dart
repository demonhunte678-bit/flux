import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flux/pages/index.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

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
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text('Error loading habits: $err'),
        ),
      ),
      data: (list) {
        final activeHabits = list.where((h) => !h.isArchived).toList();
        if (activeHabits.isEmpty) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 72,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Start Your Habit Journey',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No habits created yet. Build a custom habit from scratch or explore our hand-picked templates to start tracking today.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: onAddHabit,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Custom Habit'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => _showTemplatesSheet(context, ref),
                        icon: const Icon(Icons.explore_outlined),
                        label: const Text('Explore Templates'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final selectedDate = pageState.selectedDate;
        final dueHabits = pageState.filteredHabits.where((h) => h.isDueOnDate(selectedDate, weekendDaysSetting: h.weekendDays)).toList();
        final completedHabits = dueHabits.where((h) {
          final entry = h.entries.firstWhereOrNull(
            (e) => DateUtils.isSameDay(e.date, selectedDate),
          );
          return entry != null && !entry.isSkipped && h.isPositiveDay(entry);
        }).toList();

        final completedCount = completedHabits.length;
        final totalCount = dueHabits.length;

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
                onExploreTap: () => _showTemplatesSheet(context, ref),
              ),
              SuccessRateCard(
                completedCount: completedCount,
                totalCount: totalCount,
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
      },
    );
  }

  void _showTemplatesSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HabitTemplatesSheet(
        onSave: (h) async {
          if (h.name.isEmpty) return;
          await ref.read(habitsProvider.notifier).addHabit(h);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
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
                title: Text(L10n.of(context)!.editEntryNotesValue),
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
                title: Text(L10n.of(context)!.deleteEntry),
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
