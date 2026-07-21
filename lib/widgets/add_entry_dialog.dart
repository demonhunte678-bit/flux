import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flux/index.dart';

class AddEntryDialog extends StatefulWidget {
  final Habit habit;
  final DateTime? selectedDate;
  final bool showDateSelector;
  final String? weekendDaysSetting;
  final Function(HabitEntry) onSave;

  const AddEntryDialog({
    super.key,
    required this.habit,
    this.selectedDate,
    this.showDateSelector = false,
    this.weekendDaysSetting,
    required this.onSave,
  });

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog>
    with TickerProviderStateMixin {
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _skipReasonController = TextEditingController();

  bool _isDone = false;
  bool _isSkipped = false;
  int _sliderValue = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late DateTime _selectedDate;

  bool _hasEntryForDate(DateTime date) {
    return widget.habit.entries.any(
      (e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day,
    );
  }

  DateTime _getDefaultDate() {
    final weekendDaysSetting = widget.weekendDaysSetting ?? widget.habit.weekendDays;

    if (widget.habit.entries.isEmpty) {
      var date = DateTime.now();
      while (!widget.habit.isDueOnDate(date, weekendDaysSetting: weekendDaysSetting)) {
        date = date.subtract(const Duration(days: 1));
      }
      return date;
    }

    DateTime? latestDate;
    for (final entry in widget.habit.entries) {
      if (latestDate == null || entry.date.isAfter(latestDate)) {
        latestDate = entry.date;
      }
    }

    if (latestDate != null) {
      var nextDay = latestDate.add(const Duration(days: 1));
      while (!widget.habit.isDueOnDate(nextDay, weekendDaysSetting: weekendDaysSetting)) {
        nextDay = nextDay.add(const Duration(days: 1));
      }
      return nextDay;
    }

    var date = DateTime.now();
    while (_hasEntryForDate(date) || !widget.habit.isDueOnDate(date, weekendDaysSetting: weekendDaysSetting)) {
      date = date.subtract(const Duration(days: 1));
    }
    return date;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? _getDefaultDate();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Initialize with target value if available
    if (widget.habit.targetValue != null) {
      _valueController.text = widget.habit.targetValue!.toString();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countController.dispose();
    _valueController.dispose();
    _notesController.dispose();
    _skipReasonController.dispose();
    super.dispose();
  }

  String get _getMainTitle {
    final dateStr = DateFormat('EEE, MMM d').format(_selectedDate);
    if (_isSkipped) return 'Skipping $dateStr';

    if (widget.habit.unit != HabitUnit.Count &&
        widget.habit.targetValue != null) {
      switch (widget.habit.type) {
        case HabitType.FailBased:
          return 'Track Failure';
        case HabitType.SuccessBased:
          return 'Track Progress';
        case HabitType.DoneBased:
          return 'Mark as Done';
      }
    } else {
      switch (widget.habit.type) {
        case HabitType.FailBased:
          return 'Track Failure';
        case HabitType.SuccessBased:
          return 'Track Success';
        case HabitType.DoneBased:
          return 'Mark Completion';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = widget.habit.color;
    final baseTheme = Theme.of(context);
    final themeData = habitColor != null
        ? (() {
            final colorScheme = ColorScheme.fromSeed(
              seedColor: habitColor,
              brightness: baseTheme.brightness,
            );
            return baseTheme.copyWith(
              primaryColor: habitColor,
              scaffoldBackgroundColor: colorScheme.surface,
              colorScheme: colorScheme,
            );
          })()
        : baseTheme;

    return Theme(
      data: themeData,
      child: Builder(
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.showDateSelector) ...[
                          _buildDateSelectorSection(context),
                          const SizedBox(height: 16),
                        ],
                        if (!_isSkipped) ...[
                          _buildMainContent(context),
                          if (widget.habit.targetValue != null &&
                              !_isSkipped) ...[
                            const SizedBox(height: 16),
                            _buildTargetProgressIndicator(),
                          ],
                          const SizedBox(height: 16),
                          _buildNotesSection(context),
                        ] else ...[
                          _buildSkipReasonSection(),
                        ],
                        const SizedBox(height: 16),
                        _buildSkipSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                    child: _buildActionButtons(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              widget.habit.icon ?? Icons.star,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.habit.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getMainTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectorSection(BuildContext context) {
    final entryExists = _hasEntryForDate(_selectedDate);
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entryExists
              ? Colors.red.withValues(alpha: 0.3)
              : Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: entryExists
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                selectableDayPredicate: (date) {
                  return widget.habit.isDueOnDate(date,
                      weekendDaysSetting:
                          widget.weekendDaysSetting ?? widget.habit.weekendDays);
                },
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: entryExists ? Colors.red : null,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: entryExists
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (entryExists) ...[
            const SizedBox(height: 8),
            const Text(
              'An entry already exists for this day.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkipSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isSkipped
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSkipped
              ? Colors.orange.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isSkipped ? Icons.skip_next : Icons.schedule,
            color: _isSkipped ? Colors.orange : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skip this day?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isSkipped ? Colors.orange : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Won't break your streak or affect statistics",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: _isSkipped,
            onChanged: (value) {
              setState(() {
                _isSkipped = value;
                if (value) {
                  _isDone = false;
                  _countController.clear();
                  _valueController.clear();
                  _notesController.clear();
                }
              });
            },
            activeThumbColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (widget.habit.type == HabitType.DoneBased &&
        widget.habit.unit == HabitUnit.Count) {
      return _buildDoneTypeInput(context);
    } else {
      return _buildValueInput(context);
    }
  }

  Widget _buildDoneTypeInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Did you complete this habit today?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Switch(
                value: _isDone,
                onChanged: (value) {
                  setState(() {
                    _isDone = value;
                  });
                },
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isDone
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDone ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isDone ? Icons.check_circle : Icons.cancel,
                    color: _isDone ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isDone ? 'Completed ✓' : 'Not Completed ✗',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isDone ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueInput(BuildContext context) {
    final hasTargetValue = widget.habit.targetValue != null;
    final unitName = widget.habit.getUnitDisplayName();

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTargetValue) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.track_changes,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target Goal',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.habit.targetValue} $unitName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (widget.habit.unit == HabitUnit.Count) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final currentValue =
                                int.tryParse(_countController.text) ?? 0;
                            if (currentValue > 0) {
                              final newValue = currentValue - 1;
                              _countController.text = newValue.toString();
                              setState(() {
                                _sliderValue = newValue;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.remove,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          iconSize: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: _countController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              suffixText: unitName,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final intValue = int.tryParse(value) ?? 0;
                              setState(() {
                                _sliderValue = intValue.clamp(0, 50);
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final currentValue =
                                int.tryParse(_countController.text) ?? 0;
                            final newValue = currentValue + 1;
                            _countController.text = newValue.toString();
                            setState(() {
                              _sliderValue = newValue;
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickButton(context, '+1', 1),
                        const SizedBox(width: 8),
                        _buildQuickButton(context, '+5', 5),
                        const SizedBox(width: 8),
                        _buildQuickButton(context, '+10', 10),
                        const SizedBox(width: 8),
                        _buildQuickButton(context, 'Reset', -1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Text(
              'Enter ${unitName.isNotEmpty ? "${unitName[0].toUpperCase()}${unitName.substring(1)}" : "Amount"}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: unitName.isNotEmpty
                    ? '${unitName[0].toUpperCase()}${unitName.substring(1)}'
                    : 'Amount',
                hintText: '0.0',
                suffixText: unitName,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetProgressIndicator() {
    final targetValue = widget.habit.targetValue!;
    final currentValue = widget.habit.unit == HabitUnit.Count
        ? (int.tryParse(_countController.text) ?? 0).toDouble()
        : (double.tryParse(_valueController.text) ?? 0.0);

    final progress = (currentValue / targetValue).clamp(0.0, 1.0);
    final isOnTrack = widget.habit.type == HabitType.FailBased
        ? currentValue <= targetValue
        : currentValue >= targetValue;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnTrack
              ? [
                  Colors.green.withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.05),
                ]
              : [
                  Colors.orange.withValues(alpha: 0.1),
                  Colors.orange.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnTrack
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isOnTrack ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isOnTrack ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getProgressText(isOnTrack, currentValue, targetValue),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOnTrack ? Colors.green : Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOnTrack ? Colors.green : Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentValue.toStringAsFixed(1)} / ${targetValue.toStringAsFixed(1)} ${widget.habit.getUnitDisplayName()}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_add,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Notes (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: widget.habit.type == HabitType.FailBased
                  ? 'What triggered this? Any insights...'
                  : 'How did it go? Any thoughts...',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  Widget _buildSkipReasonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Why are you skipping today?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _skipReasonController,
            decoration: InputDecoration(
              hintText: 'e.g., sick, traveling, planned rest day...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final entryExists =
        widget.showDateSelector && _hasEntryForDate(_selectedDate);

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: entryExists ? null : _saveEntry,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSkipped
                  ? Colors.orange
                  : Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              _isSkipped ? 'Skip Day' : 'Save Entry',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  String _getProgressText(bool isOnTrack, double current, double target) {
    switch (widget.habit.type) {
      case HabitType.FailBased:
        if (current <= target) {
          return 'Within limit ✓';
        } else {
          return 'Over limit by ${(current - target).toStringAsFixed(1)}';
        }
      case HabitType.SuccessBased:
        if (current >= target) {
          return 'Target reached! ✓';
        } else {
          return 'Need ${(target - current).toStringAsFixed(1)} more';
        }
      case HabitType.DoneBased:
        if (current >= target) {
          return 'Goal achieved! ✓';
        } else {
          return 'Progress towards goal';
        }
    }
  }

  Widget _buildQuickButton(BuildContext context, String label, int value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 70),
      child: ElevatedButton(
        onPressed: () {
          if (value == -1) {
            _countController.text = '0';
            setState(() {
              _sliderValue = 0;
            });
          } else {
            final currentValue = int.tryParse(_countController.text) ?? 0;
            final newValue = currentValue + value;
            _countController.text = newValue.toString();
            setState(() {
              _sliderValue = newValue.clamp(0, 50);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: value == -1
              ? Colors.grey
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          foregroundColor: value == -1
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          minimumSize: const Size(70, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _saveEntry() {
    if (_isSkipped) {
      final entry = HabitEntry(
        date: _selectedDate,
        value: 0.0,
        isSkipped: true,
        notes: _skipReasonController.text.trim().isNotEmpty
            ? 'Skip reason: ${_skipReasonController.text.trim()}'
            : 'Skipped day',
      );
      widget.onSave(entry);
      return;
    }

    double value = 0.0;

    if (widget.habit.type == HabitType.DoneBased &&
        widget.habit.unit == HabitUnit.Count) {
      value = _isDone ? 1.0 : 0.0;
    } else if (widget.habit.unit == HabitUnit.Count) {
      value = (double.tryParse(_countController.text) ?? _sliderValue.toDouble());
    } else {
      value = double.tryParse(_valueController.text) ?? 0.0;
    }

    final entry = HabitEntry(
      date: _selectedDate,
      value: value,
      unit: widget.habit.unit != HabitUnit.Count
          ? widget.habit.getUnitDisplayName()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      isSkipped: false,
    );

    widget.onSave(entry);
  }
}
