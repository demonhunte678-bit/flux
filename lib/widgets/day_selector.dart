import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flux/l10n/index.dart';

class DaySelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DaySelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerToday();
      Future.delayed(const Duration(milliseconds: 150), () {
        _centerToday();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _centerToday() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        30 * 63.0 - (MediaQuery.of(context).size.width / 2) + 31,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return SizedBox(
      height: 90,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 365,
        itemBuilder: (context, index) {
          final date = today.subtract(Duration(days: 30 - index));
          final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
          final isToday = DateUtils.isSameDay(date, today);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : isToday
                        ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
                        : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : isToday
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getLocalizedDayName(context, date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d', Localizations.localeOf(context).toString()).format(date).toLatinNumbers(),
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getLocalizedDayName(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    final dayStr = DateFormat('E', locale).format(date);
    if (locale.startsWith('ar')) {
      String cleanStr = dayStr;
      if (cleanStr.startsWith('ال')) {
        cleanStr = cleanStr.substring(2);
      }
      return cleanStr.length >= 2 ? cleanStr.substring(0, 2) : cleanStr;
    }
    return dayStr.length >= 2 ? dayStr.substring(0, 2) : dayStr;
  }
}
