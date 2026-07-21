import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

class QuestStep implements OnboardStep {
  @override
  String get stepName => 'Change Goal';

  @override
  String? get title => 'What are you trying to change?';

  @override
  String? get subtitle => 'This determines your recommendation style.';

  @override
  bool canProceed(WidgetRef ref) {
    // Intent has a default of 'both', so user can always proceed.
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final options = [
      {
        'value': 'break',
        'title': '🚫 Break Bad Habits',
        'desc': 'I want to avoid triggers, limit distractions, or stop bad routines.',
      },
      {
        'value': 'create',
        'title': '✨ Creating Habits',
        'desc': 'I want to establish new daily activities, positive routines, or targets.',
      },
      {
        'value': 'both',
        'title': '🧭 Don\'t Know / Both',
        'desc': 'I want to build a mix of positive additions and avoid slips.',
      },
    ];

    return Column(
      children: options.map((opt) {
        final isSelected = state.intent == opt['value'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => notifier.setIntent(opt['value']!),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt['desc']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (isSelected)
                    Icon(Icons.check_circle, color: stepColor)
                  else
                    Icon(Icons.circle_outlined, color: Theme.of(context).dividerColor),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
