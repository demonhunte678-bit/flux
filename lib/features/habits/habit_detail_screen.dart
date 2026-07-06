import 'package:flutter/material.dart';
import 'package:flux/core/enums/app_enums.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/core/services/settings_service.dart';
import 'package:flux/features/habits/widgets/add_entry_dialog.dart';
import 'package:flux/data/models/habit_entry.dart';
import 'package:flux/core/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flux/features/analytics/widgets/success_rate_trend_chart.dart';
import 'package:flux/features/analytics/widgets/value_trend_chart.dart';
import 'package:flux/features/analytics/widgets/streak_trend_chart.dart';
import 'package:flux/features/analytics/widgets/distribution_charts.dart';
import 'package:flux/features/analytics/widgets/activity_heatmap.dart';
import 'package:flux/features/analytics/widgets/analytics_report.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});
  
  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSuccessRate = true;
  bool _showCurrentStreak = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final showSuccessRate = await SettingsService.getShowSuccessRate();
    final showCurrentStreak = await SettingsService.getShowCurrentStreak();
    setState(() {
      _showSuccessRate = showSuccessRate;
      _showCurrentStreak = showCurrentStreak;
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _refreshHabit() {
    setState(() {});
  }
  
  void _showAddEntryDialog() {
    final nextDay = widget.habit.getNextDayNumber();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: AddEntryDialog(
          habit: widget.habit,
          dayNumber: nextDay,
          onSave: (entry) async {
            widget.habit.entries.add(entry);
            await StorageService.save(widget.habit);
            Navigator.of(context).pop();
            _refreshHabit();
          },
        ),
      ),
    );
  }
  
  void _showToggleDisplayModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Display Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ReportDisplay.values.map((mode) {
            return RadioListTile<ReportDisplay>(
              title: Text(mode.toString().split('.').last),
              value: mode,
              groupValue: widget.habit.displayMode,
              onChanged: (value) async {
                if (value != null) {
                  widget.habit.displayMode = value;
                  await StorageService.save(widget.habit);
                  Navigator.pop(context);
                  _refreshHabit();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  
  void _showDeleteHabitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What would you like to do with "${widget.habit.formattedName}"?'),
            SizedBox(height: 16),
            if (!widget.habit.isPaused) ListTile(
              leading: Icon(Icons.pause_circle, color: Colors.orange),
              title: Text('Pause Habit'),
              subtitle: Text('Temporarily stop tracking without affecting streaks'),
              onTap: () async {
                widget.habit.isPaused = true;
                widget.habit.pauseStartDate = DateTime.now();
                await StorageService.save(widget.habit);
                Navigator.pop(context);
                _refreshHabit();
              },
            ),
            if (widget.habit.isPaused) ListTile(
              leading: Icon(Icons.play_circle, color: Colors.green),
              title: Text('Resume Habit'),
              subtitle: Text('Continue tracking this habit'),
              onTap: () async {
                widget.habit.isPaused = false;
                widget.habit.pauseEndDate = DateTime.now();
                await StorageService.save(widget.habit);
                Navigator.pop(context);
                _refreshHabit();
              },
            ),
            if (!widget.habit.isArchived) ListTile(
              leading: Icon(Icons.archive, color: Colors.amber),
              title: Text('Archive Habit'),
              subtitle: Text('Hide it from the main list but keep the data'),
              onTap: () async {
                widget.habit.isArchived = true;
                await StorageService.save(widget.habit);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
            ),
            if (widget.habit.isArchived) ListTile(
              leading: Icon(Icons.unarchive, color: Colors.green),
              title: Text('Restore Habit'),
              subtitle: Text('Bring it back to the active list'),
              onTap: () async {
                widget.habit.isArchived = false;
                await StorageService.save(widget.habit);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('Delete Permanently'),
              subtitle: Text('This cannot be undone'),
              onTap: () {
                _confirmDelete();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to permanently delete "${widget.habit.formattedName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await StorageService.delete(widget.habit);
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close manage dialog
              Navigator.pop(context); // Go back to home
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.formattedName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Delete Habit",
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteHabitDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        tooltip: 'Add Entry',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final habit = widget.habit;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showCurrentStreak) ...[
            _buildStreakCard(),
            const SizedBox(height: 16),
          ],
          _buildHabitInfoCard(),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stats Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                ],
              ),
            ),
          ),
          if (habit.type == HabitType.FailBased) ...[
            const SizedBox(height: 16),
            _buildTimeSinceLastFailure(),
          ],
          const SizedBox(height: 24),
          const Text(
            'Recent Entry History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (habit.entries.isEmpty)
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 16),
                  Icon(Icons.inbox, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No entries yet', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Tap the + button to add your first entry', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          else
            ..._buildEntriesList().take(10),
        ],
      ),
    );
  }



  Widget _buildAnalyticsTab() {
    final habit = widget.habit;
    if (habit.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No entries yet. Add entries to unlock analytics!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityHeatmap(habits: [habit]),
          const SizedBox(height: 24),
          if (_showSuccessRate) ...[
            SuccessRateTrendChart(habits: [habit]),
            const SizedBox(height: 24),
          ],
          if (habit.unit != HabitUnit.Count || habit.targetValue != null) ...[
            ValueTrendChart(habits: [habit]),
            const SizedBox(height: 24),
          ],
          FrequencyDistributionChart(habits: [habit]),
          const SizedBox(height: 24),
          AnalyticsReport(habits: [habit]),
        ],
      ),
    );
  }

  Widget _buildHabitInfoCard() {
    final habit = widget.habit;
    final entries = habit.entries;
    
    final days = entries.length;
    final positiveDays = habit.positiveCount;
    final negativeDays = days - positiveDays;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Type', _getHabitTypeText(habit.type)),
            _buildInfoRow('Frequency', _getFrequencyText(habit)),
            if (habit.category != null)
              _buildInfoRow('Category', habit.category!),
            if (habit.targetValue != null)
              _buildInfoRow('Target', '${habit.targetValue} ${habit.getUnitDisplayName()}'),
            if (habit.isPaused)
              _buildInfoRow('Status', 'Paused', color: Colors.orange),
            if (habit.type == HabitType.FailBased && habit.hasEntries)
              _buildInfoRow('Time Clean', habit.getTimeSinceLastFailure(), color: Colors.green),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsGrid() {
    final habit = widget.habit;
    final entries = habit.entries;
    
    final days = entries.length;
    final totalCount = entries.fold(0, (sum, e) => sum + e.count);
    final positiveDays = habit.positiveCount;
    final negativeDays = days - positiveDays;
    final posRate = days > 0 ? (positiveDays / days) * 100 : 0;
    final negRate = days > 0 ? (negativeDays / days) * 100 : 0;
    
    final avgPerDay = days > 0 ? totalCount / days : 0;
    final avgPositive = positiveDays > 0
        ? entries
            .where((e) => habit.isPositiveDay(e))
            .fold(0, (sum, e) => sum + e.count) / positiveDays
        : 0;
    
    final maxCount = entries.isEmpty ? 0 : entries.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final maxDays = entries.where((e) => e.count == maxCount).map((e) => e.dayNumber).toList();
    
    return Column(
      children: [
        _buildStatItem('Total Days Tracked', days.toString()),
        _buildStatItem('Total Count Sum', '$totalCount'),
        _buildStatItem('Average Count per Day', avgPerDay.toStringAsFixed(2)),
        if (maxCount > 0)
          _buildStatItem('Highest Count ($maxCount) on Day(s)', maxDays.join(', ')),
      ],
    );
  }
  
  Widget _buildTimeSinceLastFailure() {
    final habit = widget.habit;
    final timeSinceLastFailure = habit.getTimeSinceLastFailure();
    
    return _buildInfoRow('Time Since Last Failure', timeSinceLastFailure, color: Colors.green);
  }
  
  Widget _buildStreakCard() {
    final habit = widget.habit;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Streak',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${habit.currentStreak}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'days',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Best Streak',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${habit.bestStreak}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'days',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            if (habit.currentStreak > 0)
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text(
                      habit.getMilestoneMessage(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  
  
  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  String _getHabitTypeText(HabitType type) {
    switch (type) {
      case HabitType.FailBased:
        return 'Avoid (Failure-based)';
      case HabitType.SuccessBased:
        return 'Achieve (Success-based)';
      case HabitType.DoneBased:
        return 'Check (Done-based)';
    }
  }
  
  String _getFrequencyText(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.Daily:
        return 'Daily';
      case HabitFrequency.Weekdays:
        return 'Weekdays (Mon-Fri)';
      case HabitFrequency.Weekends:
        return 'Weekends (Sat-Sun)';
      case HabitFrequency.CustomDays:
        final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        final selectedDays = habit.customDays.map((i) => dayNames[i]).join(', ');
        return 'Custom Days ($selectedDays)';
      case HabitFrequency.XTimesPerWeek:
        return '${habit.targetFrequency ?? 'X'} times per week';
      case HabitFrequency.XTimesPerMonth:
        return '${habit.targetFrequency ?? 'X'} times per month';
    }
  }

  List<Widget> _buildEntriesList() {
    final entries = widget.habit.entries;
    
    // Sort entries by day number in descending order
    final sortedEntries = [...entries]..sort((a, b) => b.dayNumber.compareTo(a.dayNumber));
    
    return sortedEntries.map((entry) {
      final isPositive = widget.habit.isPositiveDay(entry);
      
      return Card(
        margin: EdgeInsets.only(bottom: 8),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            child: Icon(entry.isSkipped 
                ? Icons.skip_next
                : isPositive 
                    ? Icons.check 
                    : Icons.close),
          ),
          title: Text(
            'Day ${entry.dayNumber}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(entry.date),
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(_getEntryDescription(entry)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Entry'),
                  content: Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await StorageService.deleteEntry(widget.habit, entry);
                _refreshHabit();
              }
            },
          ),
        ),
      );
    }).toList();
  }

  String _getEntryDescription(HabitEntry entry) {
    if (entry.isSkipped) {
      return 'Skipped day';
    }
    
    String description;
    switch (widget.habit.type) {
      case HabitType.FailBased:
        if (entry.value != null) {
          description = entry.count == 0 
              ? 'Success (0 ${widget.habit.getUnitDisplayName()})' 
              : '${entry.value} ${entry.unit ?? widget.habit.getUnitDisplayName()}';
        } else {
          description = entry.count == 0 
              ? 'Success (0 failures)' 
              : '${entry.count} failure(s)';
        }
        break;
      case HabitType.SuccessBased:
        if (entry.value != null) {
          description = entry.count > 0 
              ? '${entry.value} ${entry.unit ?? widget.habit.getUnitDisplayName()}' 
              : 'Failed (0 ${widget.habit.getUnitDisplayName()})';
        } else {
          description = entry.count > 0 
              ? '${entry.count} success(es)' 
              : 'Failed (0 successes)';
        }
        break;
      case HabitType.DoneBased:
        if (entry.value != null) {
          description = entry.count > 0 
              ? 'Completed (${entry.value} ${entry.unit ?? widget.habit.getUnitDisplayName()})' 
              : 'Not completed';
        } else {
          description = entry.count > 0 ? 'Completed' : 'Not completed';
        }
        break;
    }
    
    if (entry.notes != null && entry.notes!.isNotEmpty) {
      description += '\nNote: ${entry.notes}';
    }
    
    return description;
  }
}

class _ChartData {
  final DateTime date;
  final double value;
  _ChartData(this.date, this.value);
}

class _WeekdayData {
  final String day;
  final double rate;
  _WeekdayData(this.day, this.rate);
}