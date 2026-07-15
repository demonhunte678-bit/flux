import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';

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
                    Navigator.pop(context); // Go back to home/shell
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
                    Navigator.pop(context); // Go back to home/shell
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
                Navigator.pop(context); // Go back to home/shell
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(Habit habit, HabitEntry entry) async {
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
      await ref.read(habitsProvider.notifier).deleteEntry(habit, entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = ref.watch(habitDetailProvider(widget.habit.id));
    final settingsState = ref.watch(settingsProvider);

    if (habit == null) {
      return const Scaffold(
        body: Center(
          child: Text('Habit not found or deleted.'),
        ),
      );
    }

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
          QuickStatsCard(
            habit: habit,
            showSuccessRate: showSuccessRate,
            showCurrentStreak: showCurrentStreak,
          ),
          const SizedBox(height: 24),
          const Text(
            'History Logs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          EntriesHistoryList(
            habit: habit,
            onDeleteEntry: (entry) => _deleteEntry(habit, entry),
          ),
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
}
