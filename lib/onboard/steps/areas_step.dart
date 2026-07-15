import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';

enum FocusArea {
  health,
  career,
  growth,
  finances,
  mental,
  home;

  String get label {
    switch (this) {
      case FocusArea.health:
        return '🏃 Health & Fitness';
      case FocusArea.career:
        return '💼 Career & Work';
      case FocusArea.growth:
        return '📚 Personal Growth';
      case FocusArea.finances:
        return '💰 Finances';
      case FocusArea.mental:
        return '😊 Mental Well-being';
      case FocusArea.home:
        return '🏡 Home & Organization';
    }
  }

  IconData get icon {
    switch (this) {
      case FocusArea.health:
        return Icons.fitness_center;
      case FocusArea.career:
        return Icons.work_outline;
      case FocusArea.growth:
        return Icons.menu_book;
      case FocusArea.finances:
        return Icons.payments_outlined;
      case FocusArea.mental:
        return Icons.spa_outlined;
      case FocusArea.home:
        return Icons.home_work_outlined;
    }
  }

  String get value => name;
}

class AreasStep implements OnboardStep {
  @override
  String get stepName => 'Areas of Focus';

  @override
  String? get title => 'Areas of Focus';

  @override
  String? get subtitle => 'Select up to 3 areas you want to prioritize';

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
                color: isSelected ? stepColor.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? stepColor : Colors.grey.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    area.icon,
                    size: 28,
                    color: isSelected ? stepColor : Colors.grey[600],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      area.label,
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
