import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
        showDateSelector: true,
        weekendDaysSetting: habit.weekendDays,
        onSave: (entry) async {
          await ref.read(habitsProvider.notifier).addEntry(habit, entry);
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditHabitSheet(Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitSheet(
        habitToEdit: habit,
        onSave: (updatedHabit) async {
          await ref.read(habitsProvider.notifier).updateHabit(updatedHabit);
        },
        existingCategories: (ref.read(habitsProvider).value ?? [])
            .map((h) => h.category)
            .whereType<String>()
            .toSet()
            .toList(),
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
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Habit'),
              subtitle: const Text(
                'Change name, schedule, limit/goal, icon, and colors',
              ),
              onTap: () {
                Navigator.pop(context);
                _showEditHabitSheet(habit);
              },
            ),
            const Divider(),
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

  Future<void> _exportHabitReport(Habit habit) async {
    try {
      final repository = ref.read(habitsRepositoryProvider);
      final csvData = repository.exportHabitToCsv(habit);

      final tempDir = await getTemporaryDirectory();
      final sanitizedName = habit.name.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
      final fileName = '${sanitizedName}_report.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvData);

      final xFile = XFile(file.path, mimeType: 'text/csv');
      await Share.shareXFiles(
        [xFile],
        subject: '${habit.name} - Habit Report',
        text: 'Here is the detailed CSV report for my habit "${habit.name}".',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export report: $e')),
        );
      }
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

    final habitColor = habit.color;
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
      child: Scaffold(
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
              icon: const Icon(Icons.ios_share),
              tooltip: 'Export CSV Report',
              onPressed: () => _exportHabitReport(habit),
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
          _buildHeaderMetaCard(habit),
          const SizedBox(height: 16),
          _buildMotivationalBanner(habit),
          _buildGoalProgressCard(habit),
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

  Widget _buildHeaderMetaCard(Habit habit) {
    final typeName = habit.type.name;
    final frequencyText = habit.getFrequencyDisplayText();
    final unitText = habit.getUnitDisplayName();
    final categoryText = habit.category ?? 'Uncategorized';

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (habit.icon != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  habit.icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          typeName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Frequency: $frequencyText • Unit: $unitText',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  if (habit.notes != null && habit.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      habit.notes!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalBanner(Habit habit) {

    final hasRecentFailure = habit.type == HabitType.FailBased && habit.entries.any((e) {
      final isTodayOrYesterday = DateUtils.isSameDay(e.date, DateTime.now()) ||
          DateUtils.isSameDay(e.date, DateTime.now().subtract(const Duration(days: 1)));
      return isTodayOrYesterday && e.value > 0;
    });

    if (!hasRecentFailure) return const SizedBox.shrink();

    final goalText = habit.goalType != null
        ? "Don't let one slip-up stop you from reaching your ${habit.goalType == 'streak' ? '${habit.goalValue?.toInt() ?? 90}-day streak' : '${habit.goalValue?.toInt() ?? 80}% success rate'} goal!"
        : "1 slip-up doesn't erase your progress. Let's start fresh and make today a win!";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.15),
            Colors.red.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text(
                   "You can get it!",
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   goalText,
                   style: const TextStyle(fontSize: 13, color: Colors.black87),
                 ),
               ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgressCard(Habit habit) {
    if (habit.goalType == null || habit.goalValue == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditHabitSheet(habit),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Active Goal Set",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tap here to set a target streak or success rate to stay motivated!",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }

    final goalVal = habit.goalValue!;
    double progress = 0.0;
    String progressLabel = "";
    String goalLabel = "";

    if (habit.goalType == 'streak') {
      progress = (habit.currentStreak / goalVal).clamp(0.0, 1.0);
      progressLabel = "${habit.currentStreak} of ${goalVal.toInt()} days";
      goalLabel = "Streak Goal: ${goalVal.toInt()} Days";
    } else if (habit.goalType == 'percentage') {
      progress = (habit.successRate / goalVal).clamp(0.0, 1.0);
      progressLabel = "${habit.successRate.toStringAsFixed(0)}% of ${goalVal.toInt()}%";
      goalLabel = "Success Rate Goal: ${goalVal.toInt()}%";
    } else {
      final totalCount = habit.entries.length;
      progress = (totalCount / goalVal).clamp(0.0, 1.0);
      progressLabel = "$totalCount of ${goalVal.toInt()} completions";
      goalLabel = "Completions Goal: ${goalVal.toInt()} times";
    }

    final isCompleted = progress >= 1.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.emoji_events : Icons.emoji_events_outlined,
                      color: isCompleted ? Colors.amber : Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                       goalLabel,
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Achieved!",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% reached",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressLabel,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                if (!isCompleted && habit.goalType == 'streak')
                  Text(
                    "${(goalVal - habit.currentStreak).toInt()} days left",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
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
