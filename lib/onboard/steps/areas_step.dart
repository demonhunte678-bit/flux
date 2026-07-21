import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';

enum FocusArea {
  health,
  growth,
  finances,
  mental,
  home,
  sleep,
  relationships;

  String get label {
    switch (this) {
      case FocusArea.health:
        return 'Fitness & Health';
      case FocusArea.growth:
        return 'Learning & Productivity';
      case FocusArea.finances:
        return 'Finances';
      case FocusArea.mental:
        return 'Mindfulness & Mental Health';
      case FocusArea.home:
        return 'Routines & Organization';
      case FocusArea.sleep:
        return 'Sleep';
      case FocusArea.relationships:
        return 'Relationships';
    }
  }

  IconData get icon {
    switch (this) {
      case FocusArea.health:
        return Icons.fitness_center;
      case FocusArea.growth:
        return Icons.menu_book;
      case FocusArea.finances:
        return Icons.payments_outlined;
      case FocusArea.mental:
        return Icons.spa_outlined;
      case FocusArea.home:
        return Icons.cleaning_services;
      case FocusArea.sleep:
        return Icons.bedtime_outlined;
      case FocusArea.relationships:
        return Icons.favorite_border;
    }
  }

  String get value => name;
}

class AreasStep implements OnboardStep {
  @override
  String get stepName => 'Focus Areas';

  @override
  String? get title => 'What are you trying to change in your life?';

  @override
  String? get subtitle => 'Choose the focus areas that matter to you right now.';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.selectedAreas.isNotEmpty;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: FocusArea.values.map((area) {
        final isSelected = state.selectedAreas.contains(area);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => notifier.toggleArea(area),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? stepColor.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? stepColor
                      : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    area.icon,
                    size: 28,
                    color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      area.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? stepColor : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
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
