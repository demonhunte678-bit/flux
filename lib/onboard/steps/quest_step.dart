import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import '../../l10n/localizations_extension.dart';
import '../onboard_step.dart';
import 'package:flux/l10n/localized_string.dart';

class QuestStep implements OnboardStep {
  @override
  LocalizedString get stepName => LocalizedString((l) => l.questStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.questTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.questSubtitle);

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
        'title': context.l10n.breakHabits,
        'desc': context.l10n.breakHabitsDesc,
        'icon': Icons.block,
      },
      {
        'value': 'create',
        'title': context.l10n.createHabits,
        'desc': context.l10n.createHabitsDesc,
        'icon': Icons.add_task,
      },
      {
        'value': 'both',
        'title': context.l10n.bothHabits,
        'desc': context.l10n.bothHabitsDesc,
        'icon': Icons.alt_route,
      },
    ];

    return Column(
      children: options.map((opt) {
        final isSelected = state.intent == opt['value'];
        final iconData = opt['icon'] as IconData;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => notifier.setIntent(opt['value'] as String),
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
                  Icon(
                    iconData,
                    size: 28,
                    color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt['title'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt['desc'] as String,
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
