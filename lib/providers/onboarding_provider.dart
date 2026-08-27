import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:collection/collection.dart';
import 'package:flux/data/index.dart';
import 'package:flux/onboard/steps/areas_step.dart';
import 'habits_provider.dart';
import 'settings_provider.dart';

class OnboardingState {
  final int currentStep;
  final String userName;
  final String occupation;
  final String intent; // 'break', 'create', 'both'
  final List<FocusArea> selectedAreas;
  final String timeAvailability; // '5 min', '10 min', '20 min', '30+ min'
  final String experienceLevel; // 'never', 'little', 'regular'
  final String biggestObstacle; // 'forget', 'motivation', 'time', 'too_many', 'quit'
  final List<Habit> suggestedHabits;
  final List<Habit> selectedHabits;
  final String commit30Days; // 'yes', 'try', 'not_sure'
  final String reminderPeriod; // 'morning', 'afternoon', 'evening', 'night'
  final bool wantsReminders;
  final bool showSuccessRate; // preference: false means streak focused, true means percentage focused

  OnboardingState({
    required this.currentStep,
    required this.userName,
    required this.occupation,
    required this.intent,
    required this.selectedAreas,
    required this.timeAvailability,
    required this.experienceLevel,
    required this.biggestObstacle,
    required this.suggestedHabits,
    required this.selectedHabits,
    required this.commit30Days,
    required this.reminderPeriod,
    required this.wantsReminders,
    required this.showSuccessRate,
  });

  OnboardingState copyWith({
    int? currentStep,
    String? userName,
    String? occupation,
    String? intent,
    List<FocusArea>? selectedAreas,
    String? timeAvailability,
    String? experienceLevel,
    String? biggestObstacle,
    List<Habit>? suggestedHabits,
    List<Habit>? selectedHabits,
    String? commit30Days,
    String? reminderPeriod,
    bool? wantsReminders,
    bool? showSuccessRate,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      userName: userName ?? this.userName,
      occupation: occupation ?? this.occupation,
      intent: intent ?? this.intent,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      timeAvailability: timeAvailability ?? this.timeAvailability,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      biggestObstacle: biggestObstacle ?? this.biggestObstacle,
      suggestedHabits: suggestedHabits ?? this.suggestedHabits,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      commit30Days: commit30Days ?? this.commit30Days,
      reminderPeriod: reminderPeriod ?? this.reminderPeriod,
      wantsReminders: wantsReminders ?? this.wantsReminders,
      showSuccessRate: showSuccessRate ?? this.showSuccessRate,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref)
      : super(
          OnboardingState(
            currentStep: 0,
            userName: '',
            occupation: 'Working',
            intent: 'both',
            selectedAreas: const [],
            timeAvailability: '10 min',
            experienceLevel: 'never',
            biggestObstacle: 'forget',
            suggestedHabits: const [],
            selectedHabits: const [],
            commit30Days: 'yes',
            reminderPeriod: 'evening',
            wantsReminders: true,
            showSuccessRate: true,
          ),
        );

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setUserName(String name) {
    state = state.copyWith(userName: name);
  }

  void setOccupation(String value) {
    state = state.copyWith(occupation: value);
  }

  void setIntent(String value) {
    state = state.copyWith(intent: value);
    _generateSuggestedHabits();
  }

  void toggleArea(FocusArea area) {
    final list = [...state.selectedAreas];
    if (list.contains(area)) {
      list.remove(area);
    } else {
      list.add(area);
    }
    state = state.copyWith(selectedAreas: list);
    _generateSuggestedHabits();
  }

  void setTimeAvailability(String value) {
    state = state.copyWith(timeAvailability: value);
    _generateSuggestedHabits();
  }

  void setExperienceLevel(String value) {
    state = state.copyWith(experienceLevel: value);
  }

  void setBiggestObstacle(String value) {
    state = state.copyWith(biggestObstacle: value);
  }

  void setCommit30Days(String value) {
    state = state.copyWith(commit30Days: value);
  }

  void setReminderPeriod(String value) {
    state = state.copyWith(reminderPeriod: value);
  }

  void toggleReminders(bool wants) {
    state = state.copyWith(wantsReminders: wants);
  }

  void setShowSuccessRate(bool value) {
    state = state.copyWith(showSuccessRate: value);
  }

  void toggleSuggestedHabit(Habit habit) {
    final list = [...state.selectedHabits];
    final existing = list.firstWhereOrNull((h) => h.name == habit.name);
    if (existing != null) {
      list.remove(existing);
    } else {
      list.add(habit);
    }
    state = state.copyWith(selectedHabits: list);
  }

  void _generateSuggestedHabits() {
    double scale(double min5, double min10, double min20, double min30) {
      if (state.timeAvailability == '5 min') return min5;
      if (state.timeAvailability == '10 min') return min10;
      if (state.timeAvailability == '20 min') return min20;
      return min30;
    }

    final allSuggestions = [
      // Fitness & Health
      Habit(
        name: 'Workout',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.fitness_center.codePoint),
        targetValue: scale(5, 10, 15, 30),
        unit: HabitUnit.minutes,
        category: Category.health,
      ),
      Habit(
        name: 'Morning Walk',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.directions_walk.codePoint),
        targetValue: scale(5, 10, 15, 20),
        unit: HabitUnit.minutes,
        category: Category.health,
      ),
      Habit(
        name: 'Drink Water',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.local_drink.codePoint),
        targetValue: 8,
        unit: HabitUnit.count,
        category: Category.health,
      ),
      Habit(
        name: 'No Smoking',
        type: HabitType.bad,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.smoke_free.codePoint),
        targetValue: 0,
        unit: HabitUnit.count,
        category: Category.health,
      ),
      Habit(
        name: 'Limit Junk Food',
        type: HabitType.bad,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.no_food.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.health,
      ),

      // Mindfulness & Mental Health
      Habit(
        name: 'Meditate',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.spa.codePoint),
        targetValue: scale(5, 5, 10, 15),
        unit: HabitUnit.minutes,
        category: Category.mental,
      ),
      Habit(
        name: 'Practice Gratitude',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.sentiment_satisfied_alt.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.mental,
      ),
      Habit(
        name: 'Journal',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.edit_note.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.mental,
      ),
      Habit(
        name: 'Limit Social Media',
        type: HabitType.bad,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.timer_off.codePoint),
        targetValue: scale(15, 30, 45, 60),
        unit: HabitUnit.minutes,
        category: Category.mental,
      ),

      // Learning & Productivity
      Habit(
        name: 'Read Books',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.book.codePoint),
        targetValue: scale(5, 10, 15, 20),
        unit: HabitUnit.minutes,
        category: Category.growth,
      ),
      Habit(
        name: 'Learn Coding',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.code.codePoint),
        targetValue: scale(5, 10, 20, 30),
        unit: HabitUnit.minutes,
        category: Category.growth,
      ),
      Habit(
        name: 'No Procrastination',
        type: HabitType.bad,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.dangerous.codePoint),
        targetValue: 0,
        unit: HabitUnit.count,
        category: Category.growth,
      ),

      // Finances
      Habit(
        name: 'Track Expenses',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.attach_money.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.finances,
      ),
      Habit(
        name: 'Save Money',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.savings.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.finances,
      ),
      Habit(
        name: 'No Impulse Buying',
        type: HabitType.bad,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.money_off.codePoint),
        targetValue: 0,
        unit: HabitUnit.count,
        category: Category.finances,
      ),

      // Routines & Organization
      Habit(
        name: 'Tidy Up Room',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.cleaning_services.codePoint),
        targetValue: scale(5, 10, 15, 15),
        unit: HabitUnit.minutes,
        category: Category.home,
      ),
      Habit(
        name: 'Do Dishes',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.flatware.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.home,
      ),

      // Sleep
      Habit(
        name: 'Sleep 8 Hours',
        type: HabitType.good,
        trackingType: TrackingType.quantity,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.bedtime.codePoint),
        targetValue: 8,
        unit: HabitUnit.hours,
        category: Category.sleep,
      ),
      Habit(
        name: 'No Screen in Bed',
        type: HabitType.bad,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.phonelink_off.codePoint),
        targetValue: 0,
        unit: HabitUnit.count,
        category: Category.sleep,
      ),

      // Relationships
      Habit(
        name: 'Call a Loved One',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.phone_in_talk.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.relationships,
      ),
      Habit(
        name: 'Express Appreciation',
        type: HabitType.good,
        trackingType: TrackingType.check,
        frequency: HabitFrequency.daily,
        symbol: HabitsIcon.getSymbol(Icons.favorite.codePoint),
        targetValue: 1,
        unit: HabitUnit.count,
        category: Category.relationships,
      ),
    ];

    // Filter suggestions based on selected areas
    var filtered = allSuggestions.where((habit) {
      return state.selectedAreas.any((area) => area.name == habit.category?.name);
    }).toList();

    // Filter based on Quest type: 'break' (bad), 'create' (good), 'both' (both)
    if (state.intent == 'break') {
      filtered = filtered.where((h) => h.type == HabitType.bad).toList();
    } else if (state.intent == 'create') {
      filtered = filtered.where((h) => h.type == HabitType.good).toList();
    }

    state = state.copyWith(
      suggestedHabits: filtered.isEmpty
          ? allSuggestions.where((h) => state.intent == 'both' || (state.intent == 'break' ? h.type == HabitType.bad : h.type == HabitType.good)).take(5).toList()
          : filtered,
    );
  }

  Future<void> saveAndComplete() async {
    final settingsNotifier = _ref.read(settingsProvider.notifier);

    // Save personalized variables globally to SettingsService
    await settingsNotifier.setUserName(state.userName);
    await settingsNotifier.setOccupation(state.occupation);
    await settingsNotifier.setBiggestObstacle(state.biggestObstacle);
    await settingsNotifier.toggleShowSuccessRate(state.showSuccessRate);

    // Seed database with starter habits chosen
    for (var habit in state.selectedHabits) {
      await _ref.read(habitsProvider.notifier).addHabit(habit);
    }

    await SettingsService.setOnboardingCompleted(true);
    await SettingsService.setFirstLaunch(false);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});
