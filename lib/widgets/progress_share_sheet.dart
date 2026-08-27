import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flux/index.dart';

class ProgressShareSheet extends StatefulWidget {
  final Habit habit;

  const ProgressShareSheet({
    super.key,
    required this.habit,
  });

  @override
  State<ProgressShareSheet> createState() => _ProgressShareSheetState();
}

class _ProgressShareSheetState extends State<ProgressShareSheet> {
  final GlobalKey _boundaryKey = GlobalKey();
  String _timeframe = 'week'; // 'week', 'month', 'year'
  String _monthlyStyle = 'circle'; // 'circle', 'grid'
  String _yearlyStyle = 'bars'; // 'bars', 'grid'
  DateTime _referenceDate = DateTime.now();
  bool _isExporting = false;

  DateTime get _startOfWeek {
    final int weekday = _referenceDate.weekday;
    return DateTime(_referenceDate.year, _referenceDate.month, _referenceDate.day).subtract(Duration(days: weekday - 1));
  }

  DateTime get _startOfMonth {
    return DateTime(_referenceDate.year, _referenceDate.month, 1);
  }

  DateTime get _startOfYear {
    return DateTime(_referenceDate.year, 1, 1);
  }

  String _getDateRangeLabel() {
    if (_timeframe == 'week') {
      final start = _startOfWeek;
      final end = start.add(const Duration(days: 6));
      final fmt = DateFormat('MMM d');
      return '${fmt.format(start)} - ${fmt.format(end)}, ${start.year}';
    } else if (_timeframe == 'month') {
      return DateFormat('MMMM yyyy').format(_referenceDate);
    } else {
      return 'Year ${_referenceDate.year}';
    }
  }

  void _goPrevious() {
    setState(() {
      if (_timeframe == 'week') {
        _referenceDate = _referenceDate.subtract(const Duration(days: 7));
      } else if (_timeframe == 'month') {
        _referenceDate = DateTime(_referenceDate.year, _referenceDate.month - 1, 1);
      } else {
        _referenceDate = DateTime(_referenceDate.year - 1, 1, 1);
      }
    });
  }

  void _goNext() {
    setState(() {
      if (_timeframe == 'week') {
        _referenceDate = _referenceDate.add(const Duration(days: 7));
      } else if (_timeframe == 'month') {
        _referenceDate = DateTime(_referenceDate.year, _referenceDate.month + 1, 1);
      } else {
        _referenceDate = DateTime(_referenceDate.year + 1, 1, 1);
      }
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _referenceDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _referenceDate = picked;
      });
    }
  }

  Future<void> _shareImage(bool saveToGalleryOnly) async {
    setState(() => _isExporting = true);
    try {
      // Force UI repaint
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("Repaint boundary not found");

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      if (Platform.isWindows && saveToGalleryOnly) {
        // Show Native Windows Save File Dialog
        final safeName = widget.habit.name.replaceAll(RegExp(r'[^\w\s\-]'), '_');
        final defaultFileName = 'flux_progress_${safeName}_${_timeframe}_${DateTime.now().millisecondsSinceEpoch}.png';

        final outputFile = await FilePicker.saveFile(
          dialogTitle: 'Select where to save your progress card',
          fileName: defaultFileName,
          type: FileType.image,
          allowedExtensions: ['png'],
        );

        if (outputFile == null) {
          // User cancelled
          setState(() => _isExporting = false);
          return;
        }

        final file = File(outputFile);
        await file.writeAsBytes(pngBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully saved image to: $outputFile'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Share progress PNG
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/progress_${widget.habit.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(filePath);
        await file.writeAsBytes(pngBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'My progress tracking "${widget.habit.name}" on Flux!',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _shareCsv() async {
    try {
      final csvData = HabitsRepository.instance.exportHabitToCsv(widget.habit);
      final tempDir = await getTemporaryDirectory();
      final sanitizedName = widget.habit.name.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
      final fileName = '${sanitizedName}_report.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvData);

      final xFile = XFile(file.path, mimeType: 'text/csv');
      await Share.shareXFiles(
        [xFile],
        subject: '${widget.habit.name} - Habit Report',
        text: 'Here is the detailed CSV report for my habit "${widget.habit.name}".',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export CSV: $e')),
        );
      }
    }
  }

  Map<String, String> _getPeriodStats() {
    final DateTime endLimit;
    final List<DateTime> allDays = [];

    if (_timeframe == 'week') {
      final start = _startOfWeek;
      for (int i = 0; i < 7; i++) {
        allDays.add(start.add(Duration(days: i)));
      }
      final weekEnd = start.add(const Duration(days: 6));
      endLimit = weekEnd.isAfter(DateTime.now()) ? DateTime.now() : weekEnd;
    } else if (_timeframe == 'month') {
      final start = _startOfMonth;
      final daysInMonth = DateUtils.getDaysInMonth(start.year, start.month);
      for (int i = 0; i < daysInMonth; i++) {
        allDays.add(start.add(Duration(days: i)));
      }
      final monthEnd = DateTime(start.year, start.month, daysInMonth);
      endLimit = monthEnd.isAfter(DateTime.now()) ? DateTime.now() : monthEnd;
    } else {
      final start = _startOfYear;
      final DateTime yearEnd = DateTime(start.year, 12, 31);
      final daysCount = yearEnd.difference(start).inDays + 1;
      for (int i = 0; i < daysCount; i++) {
        allDays.add(start.add(Duration(days: i)));
      }
      endLimit = yearEnd.isAfter(DateTime.now()) ? DateTime.now() : yearEnd;
    }

    int dueDays = 0;
    int successDays = 0;

    for (final day in allDays) {
      if (day.isAfter(DateTime.now())) continue;

      if (widget.habit.isDueOnDate(day)) {
        dueDays++;
        final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));
        if (entry != null) {
          if (entry.isSkipped || widget.habit.isPositiveDay(entry)) {
            successDays++;
          }
        }
      }
    }

    // Calculate streak ending at endLimit
    int streak = 0;
    DateTime checkDay = DateTime(endLimit.year, endLimit.month, endLimit.day);
    final startOfPeriod = allDays.first;

    while (!checkDay.isBefore(startOfPeriod)) {
      if (widget.habit.isDueOnDate(checkDay)) {
        final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, checkDay));
        if (entry != null && (entry.isSkipped || widget.habit.isPositiveDay(entry))) {
          streak++;
        } else {
          break; // broke streak
        }
      }
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    final double rate = dueDays > 0 ? (successDays / dueDays) * 100 : 0.0;

    return {
      'completions': '$successDays / $dueDays',
      'successRate': '${rate.toStringAsFixed(0)}%',
      'streak': '$streak Days',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = widget.habit.color ?? theme.colorScheme.primary;
    
    // Dynamic contrast color calculation based on background luminance
    final useDarkText = habitColor.computeLuminance() > 0.55;
    final primaryTextColor = useDarkText ? Colors.black : Colors.white;
    final secondaryTextColor = useDarkText ? Colors.black54 : Colors.white38;
    final dividerColor = useDarkText ? Colors.black12 : Colors.white12;
    
    final stats = _getPeriodStats();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Share Progress Card',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Timeframe toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeframeButton('week', 'Week'),
              const SizedBox(width: 8),
              _buildTimeframeButton('month', 'Month'),
              const SizedBox(width: 8),
              _buildTimeframeButton('year', 'Year'),
            ],
          ),
          const SizedBox(height: 12),

          // Style selector if month or year is selected
          if (_timeframe == 'month' || _timeframe == 'year') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Style: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                if (_timeframe == 'month') ...[
                  _buildStyleChip('circle', 'Circles'),
                  const SizedBox(width: 8),
                  _buildStyleChip('grid', 'Heatmap'),
                ] else ...[
                  _buildStyleChip('bars', 'Bars'),
                  const SizedBox(width: 8),
                  _buildStyleChip('grid', 'Heatmap'),
                ],
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Date Slider Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                onPressed: _goPrevious,
              ),
              GestureDetector(
                onTap: _selectDate,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _getDateRangeLabel(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: _goNext,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Repaint Boundary Container (This captures the custom image!)
          RepaintBoundary(
            key: _boundaryKey,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    habitColor.withOpacity(0.85),
                    const Color(0xFF121212),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: habitColor.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FLUX',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: secondaryTextColor,
                          letterSpacing: 2,
                        ),
                      ),
                      if (widget.habit.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: useDarkText ? Colors.black.withOpacity(0.08) : Colors.white12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.habit.category!.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: useDarkText ? Colors.black87 : Colors.white70,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Habit Title / Icon
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: useDarkText ? Colors.black.withOpacity(0.08) : Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: HabitIcon(
                          symbol: widget.habit.symbol,
                          size: 24,
                          color: useDarkText ? Colors.black87 : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.habit.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dynamic Chart representing the selected timeframe
                  if (_timeframe == 'week')
                    _buildWeekChart(_startOfWeek, useDarkText)
                  else if (_timeframe == 'month')
                    (_monthlyStyle == 'circle' ? _buildMonthCircles(_startOfMonth) : _buildMonthGrid(_startOfMonth))
                  else
                    (_yearlyStyle == 'bars' ? _buildYearChart(_startOfYear) : _buildYearGrid(_startOfYear)),

                  const SizedBox(height: 16),
                  Divider(color: dividerColor, height: 1),
                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Completions', stats['completions']!, useDarkText),
                      _buildStatColumn('Streak', stats['streak']!, useDarkText),
                      _buildStatColumn('Success', stats['successRate']!, useDarkText),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isExporting ? null : () => _shareImage(true),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Export Picture'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _isExporting ? null : () => _shareImage(false),
                  style: FilledButton.styleFrom(
                    backgroundColor: habitColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Share Progress'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isExporting ? null : _shareCsv,
                icon: const Icon(Icons.description),
                tooltip: 'Share CSV',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.15)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeButton(String code, String label) {
    final theme = Theme.of(context);
    final isSelected = _timeframe == code;
    final activeColor = widget.habit.color ?? theme.colorScheme.primary;

    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _timeframe = code);
      },
      selectedColor: activeColor.withOpacity(0.15),
      checkmarkColor: activeColor,
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? activeColor.withOpacity(0.5) : theme.colorScheme.outline.withOpacity(0.15),
          width: isSelected ? 1.5 : 1,
        ),
      ),
    );
  }

  Widget _buildStyleChip(String code, String label) {
    final theme = Theme.of(context);
    final isSelected = (_timeframe == 'month' && _monthlyStyle == code) ||
        (_timeframe == 'year' && _yearlyStyle == code);
    final activeColor = widget.habit.color ?? theme.colorScheme.primary;

    return ChoiceChip(
      showCheckmark: false,
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            if (_timeframe == 'month') {
              _monthlyStyle = code;
            } else {
              _yearlyStyle = code;
            }
          });
        }
      },
      selectedColor: activeColor.withOpacity(0.12),
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? activeColor.withOpacity(0.4) : theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, bool useDarkText) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: useDarkText ? Colors.black54 : Colors.white38,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: useDarkText ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekChart(DateTime startOfWeek, bool useDarkText) {
    final borderOutlineColor = useDarkText ? Colors.black12 : Colors.white12;
    final activeBorderColor = useDarkText ? Colors.black26 : Colors.white24;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));

        final Color circleColor;
        final Widget child;

        if (day.isAfter(DateTime.now())) {
          circleColor = useDarkText ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.08);
          child = const SizedBox();
        } else if (entry == null) {
          circleColor = Colors.transparent;
          child = const SizedBox();
        } else if (entry.isSkipped) {
          circleColor = Colors.orange.withOpacity(0.15);
          child = const Icon(Icons.skip_next, color: Colors.orange, size: 14);
        } else if (widget.habit.isPositiveDay(entry)) {
          circleColor = Colors.green.withOpacity(0.2);
          child = const Icon(Icons.check, color: Colors.greenAccent, size: 14);
        } else {
          circleColor = Colors.red.withOpacity(0.15);
          child = const Icon(Icons.close, color: Colors.redAccent, size: 14);
        }

        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: entry == null ? borderOutlineColor : activeBorderColor,
                  width: 1,
                ),
              ),
              child: Center(child: child),
            ),
            const SizedBox(height: 6),
            Text(
              ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
              style: TextStyle(
                color: useDarkText ? Colors.black54 : Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMonthCircles(DateTime startOfMonth) {
    final daysInMonth = DateUtils.getDaysInMonth(startOfMonth.year, startOfMonth.month);
    final firstDayOffset = DateTime(startOfMonth.year, startOfMonth.month, 1).weekday - 1;

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final gridBgColor = isDarkTheme 
        ? Colors.black.withOpacity(0.55) 
        : Colors.white.withOpacity(0.9);

    final neutralTextColor = isDarkTheme ? Colors.white38 : Colors.black45;
    final unscheduledTextColor = isDarkTheme ? Colors.white10 : Colors.black12;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gridBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((w) {
              return SizedBox(
                width: 24,
                child: Text(
                  w,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white24 : Colors.black38,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox();
              final dayNum = index - firstDayOffset + 1;
              final day = DateTime(startOfMonth.year, startOfMonth.month, dayNum);

              final isDue = widget.habit.isDueOnDate(day);
              final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));

              Color ringColor = Colors.transparent;
              Color bgColor = Colors.transparent;
              Color textColor = neutralTextColor;

              if (day.isBefore(DateTime.now()) || DateUtils.isSameDay(day, DateTime.now())) {
                if (isDue) {
                  if (entry != null) {
                    if (entry.isSkipped) {
                      ringColor = Colors.orange;
                      bgColor = Colors.orange.withOpacity(0.12);
                      textColor = Colors.orange;
                    } else if (widget.habit.isPositiveDay(entry)) {
                      ringColor = Colors.green;
                      bgColor = Colors.green.withOpacity(0.12);
                      textColor = Colors.green;
                    } else {
                      ringColor = Colors.red;
                      bgColor = Colors.red.withOpacity(0.12);
                      textColor = Colors.red;
                    }
                  } else {
                    ringColor = isDarkTheme ? Colors.white24 : Colors.black26;
                    textColor = neutralTextColor;
                  }
                } else {
                  textColor = unscheduledTextColor;
                }
              } else {
                textColor = isDue ? neutralTextColor : unscheduledTextColor;
              }

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor,
                  border: ringColor != Colors.transparent ? Border.all(color: ringColor, width: 1.5) : null,
                ),
                child: Center(
                  child: Text(
                    '$dayNum',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(DateTime startOfMonth) {
    final daysInMonth = DateUtils.getDaysInMonth(startOfMonth.year, startOfMonth.month);
    final firstDayOffset = DateTime(startOfMonth.year, startOfMonth.month, 1).weekday - 1;

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final gridBgColor = isDarkTheme 
        ? Colors.black.withOpacity(0.55) 
        : Colors.white.withOpacity(0.9);

    final emptyCellColor = isDarkTheme ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04);
    final unscheduledCellColor = isDarkTheme ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.01);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gridBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((w) {
              return SizedBox(
                width: 24,
                child: Text(
                  w,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white24 : Colors.black38,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox();
              final dayNum = index - firstDayOffset + 1;
              final day = DateTime(startOfMonth.year, startOfMonth.month, dayNum);

              final isDue = widget.habit.isDueOnDate(day);
              final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));

              Color cellColor = emptyCellColor;
              if (day.isBefore(DateTime.now()) || DateUtils.isSameDay(day, DateTime.now())) {
                if (isDue) {
                  if (entry != null) {
                    if (entry.isSkipped) {
                      cellColor = Colors.orange;
                    } else if (widget.habit.isPositiveDay(entry)) {
                      cellColor = Colors.green;
                    } else {
                      cellColor = Colors.red;
                    }
                  } else {
                    cellColor = isDarkTheme ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12);
                  }
                } else {
                  cellColor = unscheduledCellColor;
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYearChart(DateTime startOfYear) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final gridBgColor = isDarkTheme 
        ? Colors.black.withOpacity(0.55) 
        : Colors.white.withOpacity(0.9);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
      decoration: BoxDecoration(
        color: gridBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(12, (index) {
          final monthStart = DateTime(startOfYear.year, index + 1, 1);
          final monthEnd = DateTime(startOfYear.year, index + 2, 0);

          final monthEntries = widget.habit.entries.where((e) => e.date.year == monthStart.year && e.date.month == monthStart.month).toList();

          int dueDays = 0;
          int successDays = 0;

          for (int d = 1; d <= monthEnd.day; d++) {
            final day = DateTime(monthStart.year, monthStart.month, d);
            if (day.isAfter(DateTime.now())) break;

            if (widget.habit.isDueOnDate(day)) {
              dueDays++;
              final entry = monthEntries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, day));
              if (entry != null) {
                if (entry.isSkipped || widget.habit.isPositiveDay(entry)) {
                  successDays++;
                }
              }
            }
          }

          final double rate = dueDays > 0 ? (successDays / dueDays) : 0.0;
          final barHeight = 80 * rate;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 14,
                height: 80,
                decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 14,
                    height: barHeight.clamp(1.0, 80.0),
                    decoration: BoxDecoration(
                      color: (widget.habit.color ?? Colors.teal).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'][index],
                style: TextStyle(
                  color: isDarkTheme ? Colors.white38 : Colors.black45,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYearGrid(DateTime startOfYear) {
    final jan1 = DateTime(startOfYear.year, 1, 1);
    final startDay = jan1.subtract(Duration(days: jan1.weekday % 7));

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final gridBgColor = isDarkTheme 
        ? Colors.black.withOpacity(0.55) 
        : Colors.white.withOpacity(0.9);

    final emptyCellColor = isDarkTheme ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04);
    final unscheduledCellColor = isDarkTheme ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.01);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gridBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(53, (colIndex) {
              return Column(
                children: List.generate(7, (rowIndex) {
                  final date = startDay.add(Duration(days: colIndex * 7 + rowIndex));
                  if (date.year != startOfYear.year) {
                    return Container(
                      width: 3,
                      height: 3,
                      margin: const EdgeInsets.all(0.5),
                      color: Colors.transparent,
                    );
                  }

                  final isDue = widget.habit.isDueOnDate(date);
                  final entry = widget.habit.entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, date));

                  Color color = emptyCellColor;

                  if (date.isBefore(DateTime.now()) || DateUtils.isSameDay(date, DateTime.now())) {
                    if (isDue) {
                      if (entry != null) {
                        if (entry.isSkipped) {
                          color = Colors.orange;
                        } else if (widget.habit.isPositiveDay(entry)) {
                          color = Colors.green;
                        } else {
                          color = Colors.red;
                        }
                      } else {
                        color = isDarkTheme ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12);
                      }
                    } else {
                      color = unscheduledCellColor;
                    }
                  }

                  return Container(
                    width: 3,
                    height: 3,
                    margin: const EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}
