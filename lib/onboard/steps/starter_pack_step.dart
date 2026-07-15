import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/data/index.dart';
import '../onboard_step.dart';

class StarterPackStep implements OnboardStep {
  @override
  String get stepName => 'Starter Pack';

  @override
  String? get title => 'Your Starter Pack';

  @override
  String? get subtitle => 'We recommend starting with these habits';

  @override
  bool canProceed(WidgetRef ref) => true;

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    if (state.suggestedHabits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.auto_awesome, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Generating recommendations...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: state.suggestedHabits.map((habit) {
        final isSelected = state.selectedHabits.any((h) => h.name == habit.name);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => notifier.toggleSuggestedHabit(habit),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: stepColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      habit.icon ?? Icons.star,
                      color: stepColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? stepColor : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getHabitSummary(habit),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => notifier.toggleSuggestedHabit(habit),
                    activeColor: stepColor,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getHabitSummary(Habit habit) {
    final typeText = habit.type == HabitType.FailBased ? 'Avoid' : 'Track';
    final targetText = '${habit.targetValue} ${habit.unit.name.toLowerCase()}';
    return '$typeText • $targetText • ${habit.frequency.name}';
  }
}
