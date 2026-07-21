import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class HabitListItem extends ConsumerWidget {
  final Habit habit;
  final VoidCallback onTap;
  final DateTime? selectedDate;
  final VoidCallback? onCompletionTap;

  const HabitListItem({
    super.key,
    required this.habit,
    required this.onTap,
    this.selectedDate,
    this.onCompletionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    const showIcons = true;
    final showSuccessRate = settingsState.showSuccessRate;
    final showCurrentStreak = settingsState.showCurrentStreak;
    const isCompact = false;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  if (showIcons) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            habit.color?.withValues(alpha: 0.1) ??
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        habit.icon ?? Icons.star,
                        color:
                            habit.color ??
                            Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                habit.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (habit.isDueToday(weekendDaysSetting: habit.weekendDays)) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Due',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (habit.category != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            habit.category!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (habit.type == HabitType.FailBased &&
                          habit.hasEntries) ...[
                        Text(
                          habit.getTimeSinceLastFailure(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color:
                                    habit.color ??
                                    Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ] else if (showSuccessRate) ...[
                        Text(
                          '${habit.successRate.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color:
                                    habit.color ??
                                    Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                      if (showCurrentStreak) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.currentStreak} day${habit.currentStreak != 1 ? 's' : ''}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  if (selectedDate != null) ...[
                    const SizedBox(width: 12),
                    _buildCompletionButton(context, isCompact),
                  ],
                ],
              ),
              if (habit.notes != null && habit.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    habit.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (!isCompact) ...[
                const SizedBox(height: 8),
                Text(
                  _getHabitStatusText(habit),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionButton(BuildContext context, bool isCompact) {
    final entry = _getEntryForSelectedDate();
    final themeColor = habit.color ?? Theme.of(context).colorScheme.primary;

    Color buttonBgColor = Colors.transparent;
    Color buttonBorderColor = themeColor;
    Widget buttonIcon = Icon(
      Icons.add,
      color: themeColor.withValues(alpha: 0.6),
      size: 20,
    );

    if (entry != null) {
      if (entry.isSkipped) {
        buttonBgColor = Colors.orange;
        buttonBorderColor = Colors.orange;
        buttonIcon = const Icon(Icons.skip_next, color: Colors.white, size: 20);
      } else {
        final isPositive = habit.isPositiveDay(entry);
        if (isPositive) {
          buttonBgColor = themeColor;
          buttonBorderColor = themeColor;
          buttonIcon = const Icon(Icons.check, color: Colors.white, size: 20);
        } else {
          buttonBgColor = Colors.red;
          buttonBorderColor = Colors.red;
          buttonIcon = const Icon(Icons.close, color: Colors.white, size: 20);
        }
      }
    }

    return GestureDetector(
      onTap: onCompletionTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: buttonBgColor,
          shape: BoxShape.circle,
          border: Border.all(color: buttonBorderColor, width: 2),
          boxShadow: entry != null
              ? [
                  BoxShadow(
                    color: buttonBgColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(child: buttonIcon),
      ),
    );
  }

  HabitEntry? _getEntryForSelectedDate() {
    if (selectedDate == null) return null;
    final date = selectedDate!;
    for (var entry in habit.entries) {
      if (entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day) {
        return entry;
      }
    }
    return null;
  }

  String _getHabitStatusText(Habit habit) {
    String formatValue(double val) {
      if (val == val.toInt()) {
        return val.toInt().toString();
      }
      return val.toStringAsFixed(1);
    }

    switch (habit.type) {
      case HabitType.FailBased:
        final total = habit.entries.fold(
          0.0,
          (sum, e) => sum + e.value,
        );
        return 'Failures: ${formatValue(total)} ${habit.getUnitDisplayName()}';
      case HabitType.SuccessBased:
        final total = habit.entries.fold(
          0.0,
          (sum, e) => sum + e.value,
        );
        return 'Successes: ${formatValue(total)} ${habit.getUnitDisplayName()}';
      case HabitType.DoneBased:
        final total = habit.entries.fold(
          0.0,
          (sum, e) => sum + e.value,
        );
        final totalInt = total.toInt();
        return 'Completed $totalInt time${totalInt != 1 ? 's' : ''}';
    }
  }
}
