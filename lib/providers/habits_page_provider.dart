import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/data/index.dart';
import 'habits_provider.dart';

class HabitsPageState {
  final String? selectedCategory;
  final DateTime selectedDate;
  final List<Habit> habits;

  HabitsPageState({
    this.selectedCategory,
    required this.selectedDate,
    required this.habits,
  });

  List<Habit> get activeHabits => habits.where((h) => !h.isArchived).toList();

  List<Habit> get filteredHabits {
    final active = activeHabits;
    if (selectedCategory == null) return active;
    return active.where((h) => h.category == selectedCategory).toList();
  }

  List<String> get categories {
    return activeHabits
        .where((h) => h.category != null)
        .map((h) => h.category!)
        .toSet()
        .toList()
      ..sort();
  }

  double get overallSuccessRate {
    final list = filteredHabits;
    int totalPositive = 0;
    int totalNegative = 0;
    for (var habit in list) {
      totalPositive += habit.positiveCount;
      totalNegative += habit.negativeCount;
    }
    int totalDays = totalPositive + totalNegative;
    return totalDays > 0 ? (totalPositive / totalDays) * 100 : 0.0;
  }

  HabitsPageState copyWith({
    String? Function()? selectedCategory,
    DateTime? selectedDate,
    List<Habit>? habits,
  }) {
    return HabitsPageState(
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      habits: habits ?? this.habits,
    );
  }
}

class HabitsPageNotifier extends StateNotifier<HabitsPageState> {
  final Ref _ref;

  HabitsPageNotifier(this._ref)
      : super(
          HabitsPageState(
            selectedDate: DateTime.now(),
            habits: const [],
          ),
        ) {
    _ref.listen<AsyncValue<List<Habit>>>(
      habitsProvider,
      (previous, next) {
        final habits = next.maybeWhen(
          data: (h) => h,
          orElse: () => <Habit>[],
        );
        state = state.copyWith(habits: habits);
      },
      fireImmediately: true,
    );
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final habitsPageProvider =
    StateNotifierProvider<HabitsPageNotifier, HabitsPageState>((ref) {
  return HabitsPageNotifier(ref);
});
