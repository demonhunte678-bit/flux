import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/data/index.dart';
import '../onboard_step.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

class StarterPackStep implements OnboardStep {
  @override
  LocalizedString get stepName => LocalizedString((l) => l.starterPackStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.starterPackTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.starterPackSubtitle);

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.selectedHabits.isNotEmpty;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    if (state.suggestedHabits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.auto_awesome, size: 48, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                L10n.of(context)!.generatingSuggestions,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final tooManySelected = state.selectedHabits.length > 3;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (tooManySelected) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      L10n.of(context)!.starterHabitsWarn,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...state.suggestedHabits.map((habit) {
            final isSelected = state.selectedHabits.any((h) => h.name == habit.name);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => notifier.toggleSuggestedHabit(habit),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? stepColor.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? stepColor : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: stepColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: HabitIcon(
                          symbol: habit.symbol,
                          size: 24,
                          color: stepColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getHabitSummary(habit, context),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => notifier.toggleSuggestedHabit(habit),
                        activeColor: stepColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getHabitSummary(Habit habit, BuildContext context) {
    final typeText = habit.type == HabitType.bad ? L10n.of(context)!.avoid : L10n.of(context)!.achieve;
    // Helper to format values: if it ends in .0, don't show decimal
    String formatVal(double val) {
      if (val == val.toInt()) {
        return val.toInt().toString();
      }
      return val.toString();
    }

    String getUnitLabel(HabitUnit unit) {
      switch (unit) {
        case HabitUnit.count:
          return L10n.of(context)!.countTimes;
        case HabitUnit.minutes:
          return L10n.of(context)!.minutes;
        case HabitUnit.hours:
          return L10n.of(context)!.hours;
        case HabitUnit.pages:
          return L10n.of(context)!.pages;
        case HabitUnit.kilometers:
          return L10n.of(context)!.kilometers;
        case HabitUnit.miles:
          return L10n.of(context)!.miles;
        case HabitUnit.grams:
          return L10n.of(context)!.grams;
        case HabitUnit.pounds:
          return L10n.of(context)!.pounds;
        case HabitUnit.dollars:
          return L10n.of(context)!.dollars;
        case HabitUnit.custom:
          return L10n.of(context)!.custom;
      }
    }

    String getFrequencyLabel(HabitFrequency freq) {
      switch (freq) {
        case HabitFrequency.daily:
          return L10n.of(context)!.daily;
        case HabitFrequency.weekdays:
          return L10n.of(context)!.weekdays;
        case HabitFrequency.weekends:
          return L10n.of(context)!.weekends;
        case HabitFrequency.customDays:
          return L10n.of(context)!.customDays;
        case HabitFrequency.xTimesPerWeek:
          return L10n.of(context)!.xTimesPerWeek;
        case HabitFrequency.xTimesPerMonth:
          return L10n.of(context)!.xTimesPerMonth;
      }
    }

    final targetText = '${formatVal(habit.targetValue ?? 0)} ${getUnitLabel(habit.unit)}';
    return '$typeText: $targetText • ${getFrequencyLabel(habit.frequency)}';
  }
}