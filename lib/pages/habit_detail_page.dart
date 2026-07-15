import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';
import 'package:flux/core/index.dart';

class HabitDetailPage extends ConsumerStatefulWidget {
  final Habit habit;
  const HabitDetailPage({super.key, required this.habit});

  @override
  ConsumerState<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends ConsumerState<HabitDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEntryDialog(Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEntryDialog(
        habit: habit,
        onSave: (entry) async {
          await ref.read(habitsProvider.notifier).addEntry(habit, entry);
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showToggleDisplayModeDialog(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Display Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ReportDisplay.values.map((mode) {
            return RadioListTile<ReportDisplay>(
              title: Text(mode.toString().split('.').last),
              value: mode,
              groupValue: habit.displayMode,
              onChanged: (value) async {
                if (value != null) {
                  habit.displayMode = value;
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (context.mounted) Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteHabitDialog(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What would you like to do with "${habit.name}"?'),
            const SizedBox(height: 16),
            if (!habit.isPaused)
              ListTile(
                leading: const Icon(Icons.pause_circle, color: Colors.orange),
                title: const Text('Pause Habit'),
                subtitle: const Text(
                  'Temporarily stop tracking without affecting streaks',
                ),
                onTap: () async {
                  habit.isPaused = true;
                  habit.pauseStartDate = DateTime.now();
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            if (habit.isPaused)
              ListTile(
                leading: const Icon(Icons.play_circle, color: Colors.green),
                title: const Text('Resume Habit'),
                subtitle: const Text('Continue tracking this habit'),
                onTap: () async {
                  habit.isPaused = false;
                  habit.pauseEndDate = DateTime.now();
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            if (!habit.isArchived)
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.amber),
                title: const Text('Archive Habit'),
                subtitle: const Text(
                  'Hide it from the main list but keep the data',
                ),
                onTap: () async {
                  habit.isArchived = true;
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to home
                  }
                },
              ),
            if (habit.isArchived)
              ListTile(
                leading: const Icon(Icons.unarchive, color: Colors.green),
                title: const Text('Restore Habit'),
                subtitle: const Text('Bring it back to the active list'),
                onTap: () async {
                  habit.isArchived = false;
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to home
                  }
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Permanently'),
              subtitle: const Text('This cannot be undone'),
              onTap: () {
                _confirmDelete(habit);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to permanently delete "${habit.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await ref.read(habitsProvider.notifier).deleteHabit(habit.id);
              if (context.mounted) {
                Navigator.pop(context); // Close confirmation dialog
                Navigator.pop(context); // Close manage dialog
                Navigator.pop(context); // Go back to home
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final settingsState = ref.watch(settingsProvider);

    return habitsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (allHabits) {
        final habit = allHabits.firstWhere(
          (h) => h.id == widget.habit.id,
          orElse: () => widget.habit,
        );

        final showSuccessRate = settingsState.showSuccessRate;
        final showCurrentStreak = settingsState.showCurrentStreak;

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
                Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showToggleDisplayModeDialog(habit),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showDeleteHabitDialog(habit),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEntryDialog(habit),
            child: const Icon(Icons.add),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDashboardTab(habit, showSuccessRate, showCurrentStreak),
              _buildAnalyticsTab(habit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardTab(
    Habit habit,
    bool showSuccessRate,
    bool showCurrentStreak,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(habit, showSuccessRate, showCurrentStreak),
          const SizedBox(height: 24),
          const Text(
            'History Logs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildEntriesList(habit),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(Habit habit) {
    final filteredHabits = [habit];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ActivityHeatmap(habits: filteredHabits),
        const SizedBox(height: 16),
        SuccessRateTrendChart(habits: filteredHabits),
        const SizedBox(height: 16),
        if (habit.unit != HabitUnit.Count) ...[
          ValueTrendChart(habits: filteredHabits),
          const SizedBox(height: 16),
        ],
        StreakTrendChart(habits: filteredHabits),
        const SizedBox(height: 16),
        HabitTypeDistributionChart(habits: filteredHabits),
        const SizedBox(height: 16),
        AnalyticsReport(habits: filteredHabits),
      ],
    );
  }

  Widget _buildQuickStats(
    Habit habit,
    bool showSuccessRate,
    bool showCurrentStreak,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Type', _getHabitTypeText(habit.type)),
                _buildStatItem('Frequency', _getFrequencyText(habit)),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (showSuccessRate)
                  _buildStatItem(
                    'Success Rate',
                    '${habit.successRate.toStringAsFixed(0)}%',
                  ),
                if (showCurrentStreak)
                  _buildStatItem(
                    'Current Streak',
                    '${habit.currentStreak} Days',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _getHabitTypeText(HabitType type) {
    switch (type) {
      case HabitType.FailBased:
        return 'Avoid (Failure-based)';
      case HabitType.PageBased:
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
        final dayNames = const [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ];
        final selectedDays = habit.customDays
            .map((i) => dayNames[i])
            .join(', ');
        return 'Custom Days ($selectedDays)';
      case HabitFrequency.XTimesPerWeek:
        return '${habit.targetFrequency ?? 'X'} times per week';
      case HabitFrequency.XTimesPerMonth:
        return '${habit.targetFrequency ?? 'X'} times per month';
    }
  }

  List<Widget> _buildEntriesList(Habit habit) {
    final entries = habit.entries;
    final sortedEntries = [...entries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return sortedEntries.map((entry) {
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
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Entry'),
                  content: const Text(
                    'Are you sure you want to delete this entry?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref
                    .read(habitsProvider.notifier)
                    .deleteEntry(habit, entry);
              }
            },
          ),
        ),
      );
    }).toList();
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
      case HabitType.PageBased:
      case HabitType.ParagraphBased:
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
    }

    if (entry.notes != null && entry.notes!.isNotEmpty) {
      description += '\nNote: ${entry.notes}';
    }

    return description;
  }
}
