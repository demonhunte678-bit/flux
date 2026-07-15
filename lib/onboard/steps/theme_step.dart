import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';

enum ThemePreference {
  light,
  dark,
  system;

  String get label {
    switch (this) {
      case ThemePreference.light:
        return '☀️ Light Mode';
      case ThemePreference.dark:
        return '🌑 Dark Mode';
      case ThemePreference.system:
        return '⚙️ System Default';
    }
  }

  String get value => name;
}

class ThemeStep implements OnboardStep {
  @override
  String get stepName => 'Theme';

  @override
  String? get title => 'Choose Your Style';

  @override
  String? get subtitle => 'Pick a theme that feels right for you';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    return state.selectedTheme != null;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: ThemePreference.values.map((theme) {
        final isSelected = state.selectedTheme == theme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => notifier.selectTheme(theme),
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
                      theme.label,
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
