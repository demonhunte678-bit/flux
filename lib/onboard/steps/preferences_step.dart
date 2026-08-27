import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import '../../l10n/localizations_extension.dart';
import '../onboard_step.dart';
import 'package:flux/l10n/localized_string.dart';

class PreferencesStep implements OnboardStep {
  @override
  LocalizedString get stepName => LocalizedString((l) => l.preferencesStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.preferencesTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.preferencesSubtitle);

  @override
  bool canProceed(WidgetRef ref) {
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final levels = [
      {'value': 'never', 'label': context.l10n.never},
      {'value': 'little', 'label': context.l10n.aLittle},
      {'value': 'regular', 'label': context.l10n.regularly},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.trackedBeforePrompt,
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
            children: levels.map((opt) {
              final isSelected = state.experienceLevel == opt['value'];
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
                    notifier.setExperienceLevel(opt['value']!);
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
            context.l10n.measureProgressPrompt,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => notifier.setShowSuccessRate(false), // Streak focused
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: !state.showSuccessRate
                    ? stepColor.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !state.showSuccessRate
                      ? stepColor
                      : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department, color: !state.showSuccessRate ? stepColor : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.streaksFocus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !state.showSuccessRate ? stepColor : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.streaksFocusDesc,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => notifier.setShowSuccessRate(true), // Success rate focused
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: state.showSuccessRate
                    ? stepColor.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.showSuccessRate
                      ? stepColor
                      : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: state.showSuccessRate ? stepColor : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.percentagesFocus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.showSuccessRate ? stepColor : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.percentagesFocusDesc,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
