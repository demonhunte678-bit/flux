import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';

enum OnboardingQuest {
  health,
  mind,
  calm,
  productivity,
  routines,
  other;

  String get label {
    switch (this) {
      case OnboardingQuest.health:
        return '💪 Boost My Health & Energy';
      case OnboardingQuest.mind:
        return '🧠 Sharpen My Mind & Skills';
      case OnboardingQuest.calm:
        return '🧘 Find Calm & Reduce Stress';
      case OnboardingQuest.productivity:
        return '🚀 Increase My Productivity';
      case OnboardingQuest.routines:
        return '☀️ Build Positive Daily Routines';
      case OnboardingQuest.other:
        return '✨ Something Else';
    }
  }

  String get value => name;
}

class QuestStep implements OnboardStep {
  @override
  String get stepName => 'Quest Selection';

  @override
  String? get title => "What's Your Main Goal?";

  @override
  String? get subtitle => 'Choose what motivates you most right now';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.selectedQuest != null;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: OnboardingQuest.values.map((quest) {
        final isSelected = state.selectedQuest == quest;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => notifier.selectQuest(quest),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? stepColor.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? stepColor : Colors.grey.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      quest.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? stepColor : Colors.black87,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: stepColor)
                  else
                    const Icon(Icons.circle_outlined, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
