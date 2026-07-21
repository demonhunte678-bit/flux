import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

class LifestyleStep implements OnboardStep {
  @override
  String get stepName => 'Lifestyle & Obstacles';

  @override
  String? get title => 'Your Constraints & Obstacles';

  @override
  String? get subtitle => 'Understanding your limits helps us suggest realistic habits.';

  @override
  bool canProceed(WidgetRef ref) {
    // Both variables have defaults in state, so user can always proceed.
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final obstacles = [
      {'value': 'forget', 'label': 'I forget to log/do them'},
      {'value': 'motivation', 'label': 'I lose motivation quickly'},
      {'value': 'time', 'label': 'I don\'t have enough time'},
      {'value': 'too_many', 'label': 'I start too many habits at once'},
      {'value': 'quit', 'label': 'I quit after a few days of failure'},
    ];

    final timeSlots = [
      '5 min',
      '10 min',
      '20 min',
      '30+ min',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What usually gets in your way of building habits?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: obstacles.map((opt) {
              final isSelected = state.biggestObstacle == opt['value'];
              return ChoiceChip(
                label: Text(
                  opt['label']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    notifier.setBiggestObstacle(opt['value']!);
                  }
                },
                selectedColor: stepColor,
                backgroundColor: Theme.of(context).colorScheme.surface,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'How much time can you realistically spend every day?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeSlots.map((time) {
              final isSelected = state.timeAvailability == time;
              return ChoiceChip(
                label: Text(
                  time,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    notifier.setTimeAvailability(time);
                  }
                },
                selectedColor: stepColor,
                backgroundColor: Theme.of(context).colorScheme.surface,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
