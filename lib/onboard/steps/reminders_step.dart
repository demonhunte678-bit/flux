import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import '../onboard_step.dart';
import 'package:flux/index.dart';

enum ReminderPeriod {
  morning,
  afternoon,
  evening;

  String get label {
    switch (this) {
      case ReminderPeriod.morning:
        return '🌅 Morning (8-9 AM)';
      case ReminderPeriod.afternoon:
        return '☀️ Afternoon (1-2 PM)';
      case ReminderPeriod.evening:
        return '🌙 Evening (7-8 PM)';
    }
  }

  String get value => name;
}

class RemindersStep implements OnboardStep {
  @override
  String get stepName => 'Reminders';

  @override
  String? get title => 'Stay on Track';

  @override
  String? get subtitle => 'Reminders help you stay consistent, especially in the first 21 days';

  @override
  bool canProceed(WidgetRef ref) {
    final state = ref.read(onboardingProvider);
    if (state.wantsReminders) {
      return state.reminderTime != null;
    }
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: [
        SwitchListTile(
          title: const Text(
            'Enable Reminders',
            style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            state.wantsReminders ? '🔔 Yes, keep me motivated!' : '🔕 No, I\'ll remember myself',
            style: TextStyle(color: Colors.grey[600]),
          ),
          value: state.wantsReminders,
          onChanged: (value) => notifier.toggleReminders(value),
          activeColor: stepColor,
        ),
        if (state.wantsReminders) ...[
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'When would you like to be reminded?',
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: ReminderPeriod.values.map((time) {
              final isSelected = state.reminderTime == time;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => notifier.setReminderTime(time),
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
                            time.label,
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
          ),
        ],
      ],
    );
  }
}
