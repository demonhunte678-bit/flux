import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';

class CompleteStep implements OnboardStep {
  @override
  String get stepName => 'Complete';

  @override
  String? get title => 'Your Journey Begins';

  @override
  String? get subtitle => null;

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
            "Imagine opening Flux 100 days from now and seeing every single promise you've kept.",
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
                  'Your Personalized Roadmap:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: stepColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text('👤 Name: ${state.userName}', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text('💼 Occupation: ${state.occupation}', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text('🎯 Focus areas: ${state.selectedAreas.map((a) => a.label).join(", ")}', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text('⚡ Seeding: ${state.selectedHabits.length} starter habits', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Gamified / Retro RPG mode toggle
          InkWell(
            onTap: () => notifier.setGamifiedMode(!state.gamifiedMode),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: state.gamifiedMode
                    ? stepColor.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: state.gamifiedMode
                      ? stepColor
                      : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sports_esports_outlined,
                    size: 32,
                    color: state.gamifiedMode ? stepColor : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎮 Gamified RPG Mode',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: state.gamifiedMode ? stepColor : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enables retro pixel styling for titles and levels, RPG experience badges, and XP tags.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.gamifiedMode,
                    onChanged: (val) => notifier.setGamifiedMode(val),
                    activeColor: stepColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
