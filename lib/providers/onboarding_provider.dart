import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:flux/data/index.dart';
import 'package:flux/onboard/steps/quest_step.dart';
import 'package:flux/onboard/steps/areas_step.dart';
import 'package:flux/onboard/steps/lifestyle_step.dart';
import 'package:flux/onboard/steps/preferences_step.dart';
import 'package:flux/onboard/steps/reminders_step.dart';
import 'package:flux/onboard/steps/theme_step.dart';
import 'habits_provider.dart';

class OnboardingState {
  final int currentStep;
  final OnboardingQuest? selectedQuest;
  final List<FocusArea> selectedAreas;
  final Map<FocusArea, List<String>> selectedGoals;
  final EnergyLevel? energyLevel;
  final TimePreference? timePreference;
  final TimeAvailability? timeAvailability;
  final TrackingPreference? trackingPreference;
  final StartingApproach? startingApproach;
  final List<Habit> suggestedHabits;
  final List<Habit> selectedHabits;
  final bool wantsReminders;
  final ReminderPeriod? reminderTime;
  final ThemePreference? selectedTheme;

  OnboardingState({
    required this.currentStep,
    this.selectedQuest,
    required this.selectedAreas,
    required this.selectedGoals,
    this.energyLevel,
    this.timePreference,
    this.timeAvailability,
    this.trackingPreference,
    this.startingApproach,
    required this.suggestedHabits,
    required this.selectedHabits,
    required this.wantsReminders,
    this.reminderTime,
    this.selectedTheme,
  });

  OnboardingState copyWith({
    int? currentStep,
    OnboardingQuest? Function()? selectedQuest,
    List<FocusArea>? selectedAreas,
    Map<FocusArea, List<String>>? selectedGoals,
    EnergyLevel? Function()? energyLevel,
    TimePreference? Function()? timePreference,
    TimeAvailability? Function()? timeAvailability,
    TrackingPreference? Function()? trackingPreference,
    StartingApproach? Function()? startingApproach,
    List<Habit>? suggestedHabits,
    List<Habit>? selectedHabits,
    bool? wantsReminders,
    ReminderPeriod? Function()? reminderTime,
    ThemePreference? Function()? selectedTheme,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedQuest: selectedQuest != null ? selectedQuest() : this.selectedQuest,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      energyLevel: energyLevel != null ? energyLevel() : this.energyLevel,
      timePreference: timePreference != null ? timePreference() : this.timePreference,
      timeAvailability: timeAvailability != null ? timeAvailability() : this.timeAvailability,
      trackingPreference: trackingPreference != null ? trackingPreference() : this.trackingPreference,
      startingApproach: startingApproach != null ? startingApproach() : this.startingApproach,
      suggestedHabits: suggestedHabits ?? this.suggestedHabits,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      wantsReminders: wantsReminders ?? this.wantsReminders,
      reminderTime: reminderTime != null ? reminderTime() : this.reminderTime,
      selectedTheme: selectedTheme != null ? selectedTheme() : this.selectedTheme,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref)
      : super(
          OnboardingState(
            currentStep: 0,
            selectedAreas: const [],
            selectedGoals: const {},
            suggestedHabits: const [],
            selectedHabits: const [],
            wantsReminders: false,
            selectedTheme: ThemePreference.system,
          ),
        );

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void selectQuest(OnboardingQuest? quest) {
    state = state.copyWith(selectedQuest: () => quest);
  }

  void toggleArea(FocusArea area) {
    final list = [...state.selectedAreas];
    final map = Map<FocusArea, List<String>>.from(state.selectedGoals);
    if (list.contains(area)) {
      list.remove(area);
      map.remove(area);
    } else if (list.length < 3) {
      list.add(area);
    }
    state = state.copyWith(selectedAreas: list, selectedGoals: map);
    _generateSuggestedHabits();
  }

  void toggleGoal(FocusArea area, String goal) {
    final map = Map<FocusArea, List<String>>.from(state.selectedGoals);
    final list = [...(map[area] ?? [])];
    if (list.contains(goal)) {
      list.remove(goal);
    } else {
      list.add(goal);
    }
    map[area] = list;
    state = state.copyWith(selectedGoals: map);
  }

  void setEnergyLevel(EnergyLevel? energy) {
    state = state.copyWith(energyLevel: () => energy);
  }

  void setTimePreference(TimePreference? time) {
    state = state.copyWith(timePreference: () => time);
  }

  void setTimeAvailability(TimeAvailability? availability) {
    state = state.copyWith(timeAvailability: () => availability);
  }

  void setHabitPreference(TrackingPreference? pref) {
    state = state.copyWith(trackingPreference: () => pref);
  }

  void setStartingApproach(StartingApproach? approach) {
    state = state.copyWith(startingApproach: () => approach);
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

  void toggleReminders(bool wants) {
    state = state.copyWith(wantsReminders: wants);
  }

  void setReminderTime(ReminderPeriod? time) {
    state = state.copyWith(reminderTime: () => time);
  }

  void selectTheme(ThemePreference? theme) {
    state = state.copyWith(selectedTheme: () => theme);
  }

  void _generateSuggestedHabits() {
    final allSuggestions = [
      // Fitness & Workout
      Habit(
        name: 'Workout',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.fitness_center,
        targetValue: 30,
        unit: HabitUnit.Minutes,
      ),
      Habit(
        name: 'Go for a Run',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.directions_run,
        targetValue: 3,
        unit: HabitUnit.Kilometers,
      ),
      Habit(
        name: 'Morning Walk',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.directions_walk,
        targetValue: 20,
        unit: HabitUnit.Minutes,
      ),
      // Breaking Bad Habits
      Habit(
        name: 'No Smoking',
        type: HabitType.FailBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.smoke_free,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'No Junk Food',
        type: HabitType.FailBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.no_food,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'Limit Social Media',
        type: HabitType.FailBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.timer_off,
        targetValue: 30,
        unit: HabitUnit.Minutes,
      ),
      // Health & Wellness
      Habit(
        name: 'Drink Water',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.local_drink,
        targetValue: 8,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'Eat a Healthy Meal',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.restaurant,
        targetValue: 3,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'Get 8 Hours of Sleep',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.bedtime,
        targetValue: 8,
        unit: HabitUnit.Hours,
      ),
      // Mindfulness & Mental Health
      Habit(
        name: 'Meditate',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.spa,
        targetValue: 10,
        unit: HabitUnit.Minutes,
      ),
      Habit(
        name: 'Practice Gratitude',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.sentiment_satisfied_alt,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'Journal',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.edit_note,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      // Personal Growth
      Habit(
        name: 'Read Books',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.book,
        targetValue: 20,
        unit: HabitUnit.Minutes,
      ),
      Habit(
        name: 'Learn Coding',
        type: HabitType.SuccessBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.code,
        targetValue: 30,
        unit: HabitUnit.Minutes,
      ),
      // Finances
      Habit(
        name: 'Track Expenses',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.attach_money,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      Habit(
        name: 'Save Money',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.savings,
        targetValue: 1,
        unit: HabitUnit.Count,
      ),
      // Home & Organization
      Habit(
        name: 'Tidy Up',
        type: HabitType.DoneBased,
        frequency: HabitFrequency.Daily,
        icon: Icons.cleaning_services,
        targetValue: 15,
        unit: HabitUnit.Minutes,
      ),
    ];

    // Filter suggestions based on selected areas
    final Map<FocusArea, List<String>> areaKeywords = {
      FocusArea.health: ['workout', 'run', 'walk', 'water', 'meal', 'sleep'],
      FocusArea.growth: ['read', 'coding', 'meditate', 'gratitude', 'journal'],
      FocusArea.finances: ['expenses', 'save'],
      FocusArea.mental: ['meditate', 'gratitude', 'journal'],
      FocusArea.home: ['tidy'],
    };

    final filtered = allSuggestions.where((habit) {
      for (var area in state.selectedAreas) {
        final keywords = areaKeywords[area] ?? [];
        for (var keyword in keywords) {
          if (habit.name.toLowerCase().contains(keyword)) {
            return true;
          }
        }
      }
      return false;
    }).toList();

    state = state.copyWith(suggestedHabits: filtered.isEmpty ? allSuggestions.take(5).toList() : filtered);
  }

  Future<void> saveAndComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_quest', state.selectedQuest?.value ?? '');
    await prefs.setStringList('onboarding_areas', state.selectedAreas.map((e) => e.value).toList());
    
    // Save selected goals
    state.selectedGoals.forEach((area, goals) async {
      await prefs.setStringList('onboarding_goals_${area.value}', goals);
    });

    await prefs.setString('onboarding_energy_level', state.energyLevel?.value ?? '');
    await prefs.setString('onboarding_time_preference', state.timePreference?.value ?? '');
    await prefs.setString('onboarding_time_availability', state.timeAvailability?.value ?? '');
    await prefs.setString('onboarding_habit_preference', state.trackingPreference?.value ?? '');
    await prefs.setString('onboarding_starting_approach', state.startingApproach?.value ?? '');
    await prefs.setBool('onboarding_wants_reminders', state.wantsReminders);
    await prefs.setString('onboarding_reminder_time', state.reminderTime?.value ?? '');
    await prefs.setString('onboarding_selected_theme', state.selectedTheme?.value ?? 'system');

    // Add selected starter habits to database
    for (var habit in state.selectedHabits) {
      await _ref.read(habitsProvider.notifier).addHabit(habit);
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});
