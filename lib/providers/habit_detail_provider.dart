import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flux/data/index.dart';
import 'habits_provider.dart';

final habitDetailProvider = Provider.family<Habit?, String>((ref, habitId) {
  final habitsAsync = ref.watch(habitsProvider);
  return habitsAsync.maybeWhen(
    data: (habits) => habits.firstWhereOrNull((h) => h.id == habitId),
    orElse: () => null,
  );
});

final exportHabitCsvProvider = Provider<String Function(Habit)>((ref) {
  final repository = ref.watch(habitsRepositoryProvider);
  return (Habit habit) => repository.exportHabitToCsv(habit);
});
