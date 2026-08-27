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
              DateFormat('MMMM d, yyyy', Localizations.localeOf(context).toString()).format(entry.date).toLatinNumbers(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE', Localizations.localeOf(context).toString()).format(entry.date),
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

    String formatValue(double val) {
      if (val == val.toInt()) {
        return val.toInt().toString();
      }
      return val.toString();
    }

    String description;
    final unit = entry.unit ?? habit.getUnitDisplayName();
    final valueStr = formatValue(entry.value);

    if (habit.type == HabitType.bad) {
      description = entry.value == 0
          ? 'Success (0 failures)'
          : '$valueStr failure(s)';
    } else {
      if (habit.trackingType == TrackingType.quantity) {
        description = entry.value > 0
            ? '$valueStr / $unit'
            : 'Failed (0 successes)';
      } else {
        description = entry.value > 0
            ? (habit.unit == HabitUnit.count ? 'Completed' : 'Completed ($valueStr $unit)')
            : 'Not completed';
      }
    }

    if (entry.notes != null && entry.notes!.isNotEmpty) {
      description += '\nNote: ${entry.notes}';
    }

    return description;
  }
}
