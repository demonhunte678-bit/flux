import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

enum EnergyLevel {
  low,
  steady,
  bright;

  String get label {
    switch (this) {
      case EnergyLevel.low:
        return '🔋 Low Spark';
      case EnergyLevel.steady:
        return '⚡ Steady Glow';
      case EnergyLevel.bright:
        return '🔥 Bright Flame';
    }
  }

  String get value => name;
}

enum TimePreference {
  morning,
  night;

  String get label {
    switch (this) {
      case TimePreference.morning:
        return '☀️ Morning Person';
      case TimePreference.night:
        return '🦉 Night Owl';
    }
  }

  String get value => name;
}

enum TimeAvailability {
  under15,
  between15And30,
  between30And60,
  flexible;

  String get label {
    switch (this) {
      case TimeAvailability.under15:
        return '⏳ Just a few minutes (<15)';
      case TimeAvailability.between15And30:
        return '⏱️ A good moment (15-30)';
      case TimeAvailability.between30And60:
        return '🕰️ A dedicated slot (30-60)';
      case TimeAvailability.flexible:
        return '🗓️ It\'s flexible!';
    }
  }

  String get value => name;
}

class LifestyleStep implements OnboardStep {
  @override
  String get stepName => 'Lifestyle';

  @override
  String? get title => 'About Your Lifestyle';

  @override
  String? get subtitle => 'Help us understand your daily rhythm';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.energyLevel != null &&
        state.timePreference != null &&
        state.timeAvailability != null;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: [
        _buildLifestyleQuestion(
          'My typical daily energy is like:',
          EnergyLevel.values,
          state.energyLevel,
          (value) => notifier.setEnergyLevel(value),
          stepColor,
        ),
        const SizedBox(height: 24),
        _buildLifestyleQuestion(
          "I'm more of a:",
          TimePreference.values,
          state.timePreference,
          (value) => notifier.setTimePreference(value),
          stepColor,
        ),
        const SizedBox(height: 24),
        _buildLifestyleQuestion(
          'Daily time for new habits:',
          TimeAvailability.values,
          state.timeAvailability,
          (value) => notifier.setTimeAvailability(value),
          stepColor,
        ),
      ],
    );
  }

  Widget _buildLifestyleQuestion<T>(
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
            if (opt is EnergyLevel) text = opt.label;
            if (opt is TimePreference) text = opt.label;
            if (opt is TimeAvailability) text = opt.label;

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
