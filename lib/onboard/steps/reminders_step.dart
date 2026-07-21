import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

class RemindersStep implements OnboardStep {
  @override
  String get stepName => 'Routine & Commitment';

  @override
  String? get title => 'Alignment & Commitment';

  @override
  String? get subtitle => 'Reminders and dedication form the building blocks of consistency.';

  @override
  bool canProceed(WidgetRef ref) {
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final commitmentOptions = [
      {'value': 'yes', 'label': 'Yes, absolutely!'},
      {'value': 'try', 'label': 'I will try my best'},
      {'value': 'not_sure', 'label': 'I\'m not sure yet'},
    ];

    final reminderTimes = [
      {'value': 'morning', 'label': '🌅 Morning (8:00 AM)'},
      {'value': 'afternoon', 'label': '☀️ Afternoon (1:00 PM)'},
      {'value': 'evening', 'label': '🌇 Evening (7:00 PM)'},
      {'value': 'night', 'label': '🌃 Night (9:30 PM)'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When are you MOST likely to complete your habits?',
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
            children: reminderTimes.map((time) {
              final isSelected = state.reminderPeriod == time['value'];
              return ChoiceChip(
                label: Text(
                  time['label']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    notifier.setReminderPeriod(time['value']!);
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
            'Can you honestly commit to this for the next 30 days?',
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
            children: commitmentOptions.map((opt) {
              final isSelected = state.commit30Days == opt['value'];
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
                    notifier.setCommit30Days(opt['value']!);
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
