import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class HabitsNotifier extends StateNotifier<AsyncValue<List<Habit>>> {
  HabitsNotifier() : super(const AsyncValue.loading()) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    state = const AsyncValue.loading();
    try {
      final habits = await HabitsRepository.instance.loadAllHabits();
      state = AsyncValue.data(habits);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addHabit(Habit habit) async {
    try {
      await HabitsRepository.instance.saveHabit(habit);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await HabitsRepository.instance.saveHabit(habit);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await HabitsRepository.instance.deleteHabit(id);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addEntry(Habit habit, HabitEntry entry) async {
    try {
      habit.entries.add(entry);
      await HabitsRepository.instance.saveHabit(habit);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateEntry(
    Habit habit,
    HabitEntry oldEntry,
    HabitEntry newEntry,
  ) async {
    try {
      await HabitsRepository.instance.updateEntry(habit, oldEntry, newEntry);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteEntry(Habit habit, HabitEntry entry) async {
    try {
      await HabitsRepository.instance.deleteEntry(habit, entry);
      await loadHabits();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final habitsProvider =
    StateNotifierProvider<HabitsNotifier, AsyncValue<List<Habit>>>((ref) {
      return HabitsNotifier();
    });

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository.instance;
});

