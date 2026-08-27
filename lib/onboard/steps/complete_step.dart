import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import '../onboard_step.dart';

class CompleteStep implements OnboardStep {
  @override
  LocalizedString get stepName => LocalizedString((l) => l.completeStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.completeTitle);

  @override
  LocalizedString? get subtitle => null;

  @override
  bool canProceed(WidgetRef ref) => true;

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: stepColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.home_outlined,
              size: 50,
              color: stepColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
             context.l10n.completeSubtitle ?? '',
             style: TextStyle(
               color: Theme.of(context).colorScheme.onSurface,
               fontSize: 20,
               fontWeight: FontWeight.bold,
               height: 1.4,
             ),
             textAlign: TextAlign.center,
           ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.completeRoadmap,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: stepColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (state.userName.trim().isNotEmpty) ...[
                  Text(context.l10n.completeName(state.userName), style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                ],
                if (state.occupation.trim().isNotEmpty) ...[
                  Text(context.l10n.completeOccupation(state.occupation), style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                ],
                Text(context.l10n.completeFocusAreas(state.selectedAreas.map((a) => a.label(context)).join(", ")), style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text(context.l10n.completeSeeding(state.selectedHabits.length.toString()), style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
