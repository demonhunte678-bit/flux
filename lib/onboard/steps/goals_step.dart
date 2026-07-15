import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'areas_step.dart';

class GoalsStep implements OnboardStep {
  @override
  String get stepName => 'Specific Goals';

  @override
  String? get title => 'Set Specific Goals';

  @override
  String? get subtitle => 'Choose focus actions for your selected areas';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.selectedGoals.isNotEmpty &&
        state.selectedGoals.values.any((list) => list.isNotEmpty);
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.selectedAreas.map((area) {
        final goalOptions = _getGoalOptions(area);
        final selectedForArea = state.selectedGoals[area] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                area.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: stepColor,
                ),
              ),
            ),
            ...goalOptions.map((goal) {
              final isSelected = selectedForArea.contains(goal);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text(goal),
                  value: isSelected,
                  onChanged: (_) => notifier.toggleGoal(area, goal),
                  activeColor: stepColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
            const Divider(height: 32),
          ],
        );
      }).toList(),
    );
  }

  List<String> _getGoalOptions(FocusArea area) {
    switch (area) {
      case FocusArea.health:
        return [
          '💧 Drink More Water',
          '🍎 Eat Healthier Meals',
          '🏋️ Exercise Regularly',
          '😴 Improve Sleep Quality',
          '🚶‍♀️ Walk More Steps',
        ];
      case FocusArea.growth:
        return [
          '📖 Read More Books/Articles',
          '🗣️ Learn a New Language',
          '🎨 Practice a Creative Hobby',
          '🧘 Meditate or Practice Mindfulness',
          '✍️ Journal Regularly',
        ];
      case FocusArea.career:
        return [
          '📚 Learn New Skills',
          '🎯 Set Daily Goals',
          '📝 Organize Tasks',
          '🤝 Network More',
          '💡 Practice Creativity',
        ];
      case FocusArea.finances:
        return [
          '💰 Track Expenses',
          '🏦 Save Money Daily',
          '📊 Review Budget',
          '💳 Reduce Spending',
          '📈 Learn About Investing',
        ];
      case FocusArea.mental:
        return [
          '🧘 Meditate Daily',
          '📝 Practice Gratitude',
          '🌱 Positive Affirmations',
          '🎵 Listen to Calming Music',
          '🌳 Spend Time in Nature',
        ];
      case FocusArea.home:
        return [
          '🧹 Clean/Tidy Up Room',
          '🧺 Do Laundry Weekly',
          '🪴 Water Plants Regularly',
          '🍳 Cook at Home',
          '🛏️ Make Bed Daily',
        ];
    }
  }
}
