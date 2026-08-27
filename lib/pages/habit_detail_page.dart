import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:collection/collection.dart';
import 'package:flux/index.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitPage(
          habitToEdit: habit,
          onSave: (updatedHabit) async {
            await ref.read(habitsProvider.notifier).updateHabit(updatedHabit);
            if (mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showShareProgressSheet(Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProgressShareSheet(habit: habit),
    );
  }

  void _confirmDelete(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.confirmDeletion),
        content: Text(
          L10n.of(context)!.areYouSureDeleteHabit(habit.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context)!.cancel),
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
            child: Text(L10n.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(Habit habit, HabitEntry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.deleteEntry),
        content: Text(
          L10n.of(context)!.areYouSureDeleteEntry,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(L10n.of(context)!.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(L10n.of(context)!.delete),
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
          SnackBar(content: Text(L10n.of(context)!.failedToExportReport(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = ref.watch(habitDetailProvider(widget.habit.id));
    final settingsState = ref.watch(settingsProvider);

    if (habit == null) {
      return Scaffold(
        body: Center(
          child: Text(L10n.of(context)!.habitNotFound),
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
            tabs: [
              Tab(icon: const Icon(Icons.dashboard), text: L10n.of(context)!.dashboardTab),
              Tab(icon: const Icon(Icons.analytics), text: L10n.of(context)!.analyticsTab),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Share Progress Card',
              onPressed: () => _showShareProgressSheet(habit),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'edit') {
                  _showEditHabitSheet(habit);
                } else if (value == 'archive') {
                  habit.isArchived = !habit.isArchived;
                  await ref.read(habitsProvider.notifier).updateHabit(habit);
                  if (mounted) {
                    if (habit.isArchived) {
                      Navigator.pop(context);
                    } else {
                      setState(() {});
                    }
                  }
                } else if (value == 'reset') {
                  _showArchiveLogsDialog(habit);
                } else if (value == 'csv') {
                  _exportHabitReport(habit);
                } else if (value == 'delete') {
                  _confirmDelete(habit);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: themeData.colorScheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(L10n.of(ctx)!.editHabit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      Icon(
                        habit.isArchived ? Icons.unarchive : Icons.archive,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(habit.isArchived ? 'Unarchive Habit' : L10n.of(ctx)!.archiveHabit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'reset',
                  child: const Row(
                    children: [
                      Icon(Icons.history_toggle_off, color: Colors.blueGrey, size: 20),
                      const SizedBox(width: 12),
                      Text('Reset past records'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'csv',
                  child: Row(
                    children: [
                      Icon(Icons.file_present, color: themeData.colorScheme.secondary, size: 20),
                      const SizedBox(width: 12),
                      Text(L10n.of(ctx)!.exportCsvReport),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        L10n.of(ctx)!.deletePermanently,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: _shouldShowFab(habit)
            ? FloatingActionButton(
                onPressed: () => _showAddEntryDialog(habit),
                child: const Icon(Icons.add),
              )
            : null,
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
          const SizedBox(height: 16),
          HabitStreakCalendar(
            habit: habit,
            onModified: () {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          QuickStatsCard(
            habit: habit,
            showSuccessRate: showSuccessRate,
            showCurrentStreak: showCurrentStreak,
          ),
          const SizedBox(height: 24),

          Text(
            L10n.of(context)!.historyLogs,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    final categoryText = habit.category?.getLocalizedName(context) ?? 'Uncategorized';

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: HabitIcon(
                symbol: habit.symbol,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
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
                    L10n.of(context)!.frequencyAndUnit(frequencyText, unitText),
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

    final hasRecentFailure = habit.type == HabitType.bad && habit.entries.any((e) {
      final isTodayOrYesterday = DateUtils.isSameDay(e.date, DateTime.now()) ||
          DateUtils.isSameDay(e.date, DateTime.now().subtract(const Duration(days: 1)));
      return isTodayOrYesterday && e.value > 0;
    });

    if (!hasRecentFailure) return const SizedBox.shrink();

    final goalText = habit.goalType != null
        ? (habit.goalType == GoalType.streak
            ? L10n.of(context)!.slipUpStreakBanner((habit.goalValue?.toInt() ?? 90).toString())
            : L10n.of(context)!.slipUpSuccessBanner((habit.goalValue?.toInt() ?? 80).toString()))
        : L10n.of(context)!.slipUpGenericBanner;

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
                 Text(
                   L10n.of(context)!.youCanGetIt,
                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                        L10n.of(context)!.noActiveGoalSet,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        L10n.of(context)!.noActiveGoalSubtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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

    if (habit.goalType == GoalType.streak) {
      progress = (habit.currentStreak / goalVal).clamp(0.0, 1.0);
      progressLabel = L10n.of(context)!.progressLabelDays(habit.currentStreak.toString(), goalVal.toInt().toString());
      goalLabel = L10n.of(context)!.streakGoal(goalVal.toInt().toString());
    } else if (habit.goalType == GoalType.percentage) {
      progress = (habit.successRate / goalVal).clamp(0.0, 1.0);
      progressLabel = L10n.of(context)!.progressLabelPercentage(habit.successRate.toStringAsFixed(0), goalVal.toInt().toString());
      goalLabel = L10n.of(context)!.successRateGoal(goalVal.toInt().toString());
    } else {
      final totalCount = habit.entries.length;
      progress = (totalCount / goalVal).clamp(0.0, 1.0);
      progressLabel = L10n.of(context)!.progressLabelCompletions(totalCount.toString(), goalVal.toInt().toString());
      goalLabel = L10n.of(context)!.completionsGoal(goalVal.toInt().toString());
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
                    child: Text(
                      L10n.of(context)!.achieved,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Text(
                    L10n.of(context)!.reachedPercent((progress * 100).toStringAsFixed(0)),
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
                if (!isCompleted && habit.goalType == GoalType.streak)
                  Text(
                    L10n.of(context)!.daysLeft((goalVal - habit.currentStreak).toInt().toString()),
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
        if (habit.unit != HabitUnit.count) ...[
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

  bool _shouldShowFab(Habit habit) {
    if (!habit.isDueToday(weekendDaysSetting: habit.weekendDays)) {
      return false;
    }
    if (habit.trackingType == TrackingType.check) {
      final todayEntry = habit.entries.firstWhereOrNull(
        (e) => DateUtils.isSameDay(e.date, DateTime.now()),
      );
      if (todayEntry != null && habit.isPositiveDay(todayEntry)) {
        return false;
      }
    }
    return true;
  }

  void _showArchiveLogsDialog(Habit habit) {
    final now = DateTime.now();
    final startOfCurrentMonth = DateTime(now.year, now.month, 1);
    final startOfCurrentYear = DateTime(now.year, 1, 1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset & Archive Past Logs'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          'Archive logs from previous months or years to reset your success statistics and start fresh. '
          'Your old logs will remain visible in the history view for reference, but they will not be counted in active streaks or success rates. '
          'This action cannot be undone.',
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await HabitsRepository.instance.archivePastEntries(habit, startOfCurrentMonth);
              ref.read(habitsProvider.notifier).loadHabits();
              setState(() {});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Archived logs before the current month.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Before Current Month'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await HabitsRepository.instance.archivePastEntries(habit, startOfCurrentYear);
              ref.read(habitsProvider.notifier).loadHabits();
              setState(() {});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Archived logs before the current year.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Before Current Year'),
          ),
        ],
      ),
    );
  }
}
