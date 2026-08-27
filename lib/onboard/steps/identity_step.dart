import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import '../../l10n/localizations_extension.dart';
import '../onboard_step.dart';
import 'package:flux/l10n/localized_string.dart';

class IdentityStep implements OnboardStep {
  @override
  LocalizedString get stepName => LocalizedString((l) => l.identityStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.welcomeTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.welcomeSubtitle);

  @override
  bool canProceed(WidgetRef ref) {
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final occupations = [
      'Student',
      'Working',
      'Shift Worker',
      'Parent',
      'Retired',
      'Other'
    ];

    String getOccupationLabel(String occ) {
      switch (occ) {
        case 'Student':
          return context.l10n.occStudent;
        case 'Working':
          return context.l10n.occWorking;
        case 'Shift Worker':
          return context.l10n.occShiftWorker;
        case 'Parent':
          return context.l10n.occParent;
        case 'Retired':
          return context.l10n.occRetired;
        case 'Other':
          return context.l10n.occOther;
        default:
          return occ;
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            context.l10n.namePrompt,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.userName,
            decoration: InputDecoration(
              hintText: context.l10n.nameHint,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: stepColor, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (val) => notifier.setUserName(val),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.occupationPrompt,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: occupations.map((occ) {
              final isSelected = state.occupation == occ;
              return ChoiceChip(
                label: Text(
                  getOccupationLabel(occ),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    notifier.setOccupation(occ);
                  } else {
                    notifier.setOccupation('');
                  }
                },
                selectedColor: stepColor,
                backgroundColor: Theme.of(context).colorScheme.surface,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
