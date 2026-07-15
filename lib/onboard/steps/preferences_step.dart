import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

enum TrackingPreference {
  simple,
  goal,
  avoid;

  String get label {
    switch (this) {
      case TrackingPreference.simple:
        return '✅ Simple yes/no tracking';
      case TrackingPreference.goal:
        return '📈 Goal-based with targets';
      case TrackingPreference.avoid:
        return '📉 Avoiding bad behaviors';
    }
  }

  String get value => name;
}

enum StartingApproach {
  single,
  multiple;

  String get label {
    switch (this) {
      case StartingApproach.single:
        return '🎯 Focus on one habit';
      case StartingApproach.multiple:
        return '🤹 Start multiple habits';
    }
  }

  String get value => name;
}

class PreferencesStep implements OnboardStep {
  @override
  String get stepName => 'Preferences';

  @override
  String? get title => 'Your Preferences';

  @override
  String? get subtitle => 'How do you like to track your progress?';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.trackingPreference != null && state.startingApproach != null;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: [
        _buildPreferenceQuestion(
          'I prefer habits that are:',
          TrackingPreference.values,
          state.trackingPreference,
          (value) => notifier.setHabitPreference(value),
          stepColor,
        ),
        const SizedBox(height: 24),
        _buildPreferenceQuestion(
          'When starting, I prefer to:',
          StartingApproach.values,
          state.startingApproach,
          (value) => notifier.setStartingApproach(value),
          stepColor,
        ),
      ],
    );
  }

  Widget _buildPreferenceQuestion<T>(
    String question,
    List<T> options,
    T? selectedValue,
    ValueChanged<T> onChanged,
    Color stepColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = opt == selectedValue;
            String text = '';
            if (opt is TrackingPreference) text = opt.label;
            if (opt is StartingApproach) text = opt.label;

            return ChoiceChip(
              label: Text(text),
              selected: isSelected,
              onSelected: (_) => onChanged(opt),
              selectedColor: stepColor.withValues(alpha: 0.2),
              checkmarkColor: stepColor,
              labelStyle: TextStyle(
                color: isSelected ? stepColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
