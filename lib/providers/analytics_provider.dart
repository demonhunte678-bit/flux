import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class AnalyticsState {
  final String selectedTimeRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Habit> habits;

  AnalyticsState({
    required this.selectedTimeRange,
    this.startDate,
    this.endDate,
    required this.habits,
  });

  List<Habit> get filteredHabits {
    if (startDate == null || endDate == null) return habits;

    return habits.map((habit) {
      final filteredEntries = habit.entries.where((entry) {
        return entry.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            entry.date.isBefore(endDate!.add(const Duration(days: 1)));
      }).toList();

      return Habit(
        id: habit.id,
        name: habit.name,
        type: habit.type,
        displayMode: habit.displayMode,
        icon: habit.icon,
        color: habit.color,
        isArchived: habit.isArchived,
        notes: habit.notes,
        category: habit.category,
        frequency: habit.frequency,
        customDays: habit.customDays,
        targetFrequency: habit.targetFrequency,
        targetValue: habit.targetValue,
        unit: habit.unit,
        customUnit: habit.customUnit,
        entries: filteredEntries,
      );
    }).toList();
  }

  AnalyticsState copyWith({
    String? selectedTimeRange,
    DateTime? startDate,
    DateTime? endDate,
    List<Habit>? habits,
  }) {
    return AnalyticsState(
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      habits: habits ?? this.habits,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final Ref _ref;

  AnalyticsNotifier(this._ref)
      : super(
          AnalyticsState(
            selectedTimeRange: 'Last 30 Days',
            startDate: DateTime.now().subtract(const Duration(days: 30)),
            endDate: DateTime.now(),
            habits: const [],
          ),
        ) {
    // Listen to habitsProvider to keep the state synced
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

  void setTimeRange(String range) {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;
    switch (range) {
      case 'Last 7 Days':
        start = now.subtract(const Duration(days: 7));
        end = now;
        break;
      case 'Last 30 Days':
        start = now.subtract(const Duration(days: 30));
        end = now;
        break;
      case 'Last 90 Days':
        start = now.subtract(const Duration(days: 90));
        end = now;
        break;
      case 'This Year':
        start = DateTime(now.year, 1, 1);
        end = now;
        break;
      case 'All Time':
        start = null;
        end = null;
        break;
      case 'Custom Range':
        start = state.startDate;
        end = state.endDate;
        break;
    }
    state = state.copyWith(
      selectedTimeRange: range,
      startDate: start,
      endDate: end,
    );
  }

  void setCustomRange(DateTime start, DateTime end) {
    state = state.copyWith(
      selectedTimeRange: 'Custom Range',
      startDate: start,
      endDate: end,
    );
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier(ref);
});
