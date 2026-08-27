import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../../l10n/localizations_extension.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';
import 'package:flux/l10n/localized_string.dart';

enum FocusArea {
  health,
  growth,
  finances,
  mental,
  home,
  sleep,
  relationships;

  String label(BuildContext context) {
    switch (this) {
      case FocusArea.health:
        return context.l10n.areaHealth;
      case FocusArea.growth:
        return context.l10n.areaGrowth;
      case FocusArea.finances:
        return context.l10n.areaFinances;
      case FocusArea.mental:
        return context.l10n.areaMental;
      case FocusArea.home:
        return context.l10n.areaHome;
      case FocusArea.sleep:
        return context.l10n.areaSleep;
      case FocusArea.relationships:
        return context.l10n.areaRelationships;
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
  LocalizedString get stepName => LocalizedString((l) => l.areasStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.areasTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.areasSubtitle);

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
                      area.label(context),
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
