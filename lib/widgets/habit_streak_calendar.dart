import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flux/index.dart';
import 'add_entry_dialog.dart';

class HabitStreakCalendar extends StatefulWidget {
  final Habit habit;
  final Function() onModified;

  const HabitStreakCalendar({
    super.key,
    required this.habit,
    required this.onModified,
  });

  @override
  State<HabitStreakCalendar> createState() => _HabitStreakCalendarState();
}

class _HabitStreakCalendarState extends State<HabitStreakCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  bool _isSuccess(DateTime date) {
    if (!widget.habit.isDueOnDate(date, weekendDaysSetting: widget.habit.weekendDays)) {
      return false;
    }
    final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, date));
    return entry != null && !entry.isSkipped && widget.habit.isPositiveDay(entry);
  }

  Color _getRingColor(DateTime day, HabitEntry? entry) {
    if (entry == null || entry.isSkipped) {
      if (entry != null && entry.isSkipped) return Colors.orange;
      return Colors.transparent;
    }
    final isSuccess = widget.habit.isPositiveDay(entry);
    if (widget.habit.trackingType == TrackingType.check) {
      return isSuccess ? Colors.green : Colors.red;
    }

    final double target = widget.habit.targetValue ?? 1.0;
    final double value = entry.value;

    if (widget.habit.type == HabitType.good) {
      if (isSuccess) {
        return Colors.green;
      } else {
        final ratio = (value / target).clamp(0.1, 1.0);
        return Color.lerp(Colors.green.shade100, Colors.green.shade700, ratio) ?? Colors.green;
      }
    } else {
      if (isSuccess) {
        return Colors.green;
      } else {
        final excess = value - target;
        final ratio = (excess / (target == 0 ? 1 : target)).clamp(0.1, 2.0) / 2.0;
        return Color.lerp(Colors.red.shade200, Colors.red.shade900, ratio) ?? Colors.red;
      }
    }
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstDayOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7; // Sunday = 0

    final monthName = _getMonthName(_focusedMonth.month);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Month Header Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  '$monthName ${_focusedMonth.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Days of the week row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _DayNameCell('S'),
                _DayNameCell('M'),
                _DayNameCell('T'),
                _DayNameCell('W'),
                _DayNameCell('T'),
                _DayNameCell('F'),
                _DayNameCell('S'),
              ],
            ),
            const SizedBox(height: 8),

            // Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 0,
              ),
              itemCount: daysInMonth + firstDayOffset,
              itemBuilder: (context, index) {
                if (index < firstDayOffset) {
                  return const SizedBox();
                }

                final dayNumber = index - firstDayOffset + 1;
                final day = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
                return _buildCalendarCell(day, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCell(DateTime day, BuildContext context) {
    final theme = Theme.of(context);
    final isDue = widget.habit.isDueOnDate(day, weekendDaysSetting: widget.habit.weekendDays);
    final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));

    final isSuccess = entry != null && !entry.isSkipped && widget.habit.isPositiveDay(entry);
    final isFail = entry != null && !entry.isSkipped && !widget.habit.isPositiveDay(entry);
    final isSkipped = entry != null && entry.isSkipped;

    final isToday = DateUtils.isSameDay(day, DateTime.now());

    // Connection checks for consecutive streaks (connects across rows!)
    final hasPrev = isSuccess && _isSuccess(day.subtract(const Duration(days: 1)));
    final hasNext = isSuccess && _isSuccess(day.add(const Duration(days: 1)));

    BoxDecoration? pipeDecoration;
    if (isSuccess) {
      if (hasPrev || hasNext) {
        final double leftRadius = hasPrev ? 0 : 20;
        final double rightRadius = hasNext ? 0 : 20;
        pipeDecoration = BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(leftRadius),
            bottomLeft: Radius.circular(leftRadius),
            topRight: Radius.circular(rightRadius),
            bottomRight: Radius.circular(rightRadius),
          ),
        );
      }
    }

    final Color ringColor;
    final Color bgColor;
    final Color textColor;

    if (isSuccess) {
      final Color color = _getRingColor(day, entry);
      ringColor = color;
      bgColor = color.withValues(alpha: 0.12);
      textColor = theme.colorScheme.onSurface;
    } else if (isFail) {
      final Color color = _getRingColor(day, entry);
      ringColor = color;
      bgColor = color.withValues(alpha: 0.12);
      textColor = theme.colorScheme.onSurface;
    } else if (isSkipped) {
      ringColor = Colors.orange;
      bgColor = Colors.orange.withValues(alpha: 0.12);
      textColor = theme.colorScheme.onSurface;
    } else if (isToday) {
      ringColor = theme.colorScheme.primary;
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
      textColor = theme.colorScheme.primary;
    } else {
      ringColor = Colors.transparent;
      bgColor = Colors.transparent;
      textColor = !isDue
          ? Colors.grey.withValues(alpha: 0.4)
          : theme.colorScheme.onSurface;
    }

    final Border? cellBorder;
    if (ringColor != Colors.transparent) {
      cellBorder = Border.all(color: ringColor, width: 2.0);
    } else if (isDue && entry == null && day.isBefore(DateTime.now())) {
      cellBorder = Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1.0);
    } else {
      cellBorder = null;
    }

    return GestureDetector(
      onTap: () => _handleDayTap(day, entry),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Connecting streak pipe background
          if (pipeDecoration != null)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: pipeDecoration,
              ),
            ),

          // Day circle indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: cellBorder,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: (isToday || isSuccess || isFail || isSkipped) ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDayTap(DateTime day, HabitEntry? entry) {
    if (day.isAfter(DateTime.now())) return; // Cannot log in the future

    if (entry == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => AddEntryDialog(
          habit: widget.habit,
          selectedDate: day,
          onSave: (newEntry) async {
            await HabitsRepository.instance.saveEntry(widget.habit, newEntry);
            widget.onModified();
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Entry'),
                onTap: () {
                  Navigator.pop(ctx);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (c) => AddEntryDialog(
                      habit: widget.habit,
                      selectedDate: day,
                      onSave: (updatedEntry) async {
                        await HabitsRepository.instance.saveEntry(widget.habit, updatedEntry);
                        widget.onModified();
                        if (c.mounted) Navigator.of(c).pop();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Entry'),
                onTap: () async {
                  await HabitsRepository.instance.deleteEntry(widget.habit, entry);
                  widget.onModified();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class _DayNameCell extends StatelessWidget {
  final String label;
  const _DayNameCell(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}
