import 'package:flutter/material.dart';
import 'package:flux/index.dart';
import 'package:intl/intl.dart';
import 'package:flux/data/index.dart';

class EntriesHistoryList extends StatelessWidget {
  final Habit habit;
  final Function(HabitEntry) onDeleteEntry;

  const EntriesHistoryList({
    super.key,
    required this.habit,
    required this.onDeleteEntry,
  });

  @override
  Widget build(BuildContext context) {
    final entries = habit.entries;
    final sortedEntries = [...entries]..sort((a, b) => b.date.compareTo(a.date));

    if (sortedEntries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No entries logged yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Column(
      children: sortedEntries.map((entry) {
        final isPositive = habit.isPositiveDay(entry);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            leading: CircleAvatar(
              backgroundColor: entry.isSkipped
                  ? Colors.orange.withValues(alpha: 0.2)
                  : isPositive
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
              foregroundColor: entry.isSkipped
                  ? Colors.orange
                  : isPositive
                      ? Colors.green
                      : Colors.red,
              child: Icon(
                entry.isSkipped
                    ? Icons.skip_next
                    : isPositive
                        ? Icons.check
                        : Icons.close,
              ),
            ),
            title: Text(
              DateFormat('MMMM d, yyyy').format(entry.date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(entry.date),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(_getEntryDescription(habit, entry)),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onDeleteEntry(entry),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getEntryDescription(Habit habit, HabitEntry entry) {
    if (entry.isSkipped) {
      return 'Skipped day';
    }

    String description;
    switch (habit.type) {
      case HabitType.FailBased:
        if (entry.value != null) {
          description = entry.count == 0
              ? 'Success (0 ${habit.getUnitDisplayName()})'
              : '${entry.value} ${entry.unit ?? habit.getUnitDisplayName()}';
        } else {
          description = entry.count == 0
              ? 'Success (0 failures)'
              : '${entry.count} failure(s)';
        }
        break;
      case HabitType.SuccessBased:
        if (entry.value != null) {
          description = entry.count > 0
              ? '${entry.value} ${entry.unit ?? habit.getUnitDisplayName()}'
              : 'Failed (0 ${habit.getUnitDisplayName()})';
        } else {
          description = entry.count > 0
              ? '${entry.count} success(es)'
              : 'Failed (0 successes)';
        }
        break;
      case HabitType.DoneBased:
        if (entry.value != null) {
          description = entry.count > 0
              ? 'Completed (${entry.value} ${entry.unit ?? habit.getUnitDisplayName()})'
              : 'Not completed';
        } else {
          description = entry.count > 0 ? 'Completed' : 'Not completed';
        }
        break;
      default:
        description = '';
    }

    if (entry.notes != null && entry.notes!.isNotEmpty) {
      description += '\nNote: ${entry.notes}';
    }

    return description;
  }
}
