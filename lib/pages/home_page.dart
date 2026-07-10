import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:flux/index.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  late ScrollController _daySelectorScrollController;
  late ScrollController _habitsScrollController;
  late ScrollController _dashboardScrollController;
  List<FocusNode> _focusableNodes = [];
  final KeyboardService _keyboardService = KeyboardService();

  @override
  void initState() {
    super.initState();
    _habitsScrollController = ScrollController();
    _dashboardScrollController = ScrollController();
    _daySelectorScrollController = ScrollController();
    _focusableNodes = List.generate(20, (index) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerToday();
      Future.delayed(const Duration(milliseconds: 150), () {
        _centerToday();
      });
    });
  }

  @override
  void dispose() {
    _habitsScrollController.dispose();
    _dashboardScrollController.dispose();
    _daySelectorScrollController.dispose();
    for (var node in _focusableNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    final currentController = index == 0
        ? _habitsScrollController
        : _dashboardScrollController;
    _keyboardService.setScrollController(currentController);
  }

  void _showAddHabit(List<Habit> activeHabits) {
    final existingCategories =
        activeHabits
            .where((h) => h.category != null)
            .map((h) => h.category!)
            .toSet()
            .toList()
          ..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHabitSheet(
        existingCategories: existingCategories,
        onSave: (h) async {
          if (h.name.isEmpty) return;
          await ref.read(habitsProvider.notifier).addHabit(h);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final settingsState = ref.watch(settingsProvider);
    final themeState = ref.watch(themeProvider);

    return habitsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Error loading habits: $err'))),
      data: (allHabits) {
        final activeHabits = allHabits.where((h) => !h.isArchived).toList();

        final categories =
            activeHabits
                .where((h) => h.category != null)
                .map((h) => h.category!)
                .toSet()
                .toList()
              ..sort();

        final filteredHabits = _selectedCategory == null
            ? activeHabits
            : activeHabits
                  .where((h) => h.category == _selectedCategory)
                  .toList();

        int totalPositive = 0;
        int totalNegative = 0;
        int totalEntries = 0;
        int bestStreak = 0;
        String bestStreakHabit = '';

        for (var habit in filteredHabits) {
          totalPositive += habit.positiveCount;
          totalNegative += habit.negativeCount;
          totalEntries += habit.entries.length;

          if (habit.currentStreak > bestStreak) {
            bestStreak = habit.currentStreak;
            bestStreakHabit = habit.formattedName;
          }
        }

        int totalDays = totalPositive + totalNegative;
        final overallSuccessRate = totalDays > 0
            ? (totalPositive / totalDays) * 100
            : 0.0;

        return KeyboardAwareWidget(
          scrollController: _currentIndex == 0
              ? _habitsScrollController
              : _dashboardScrollController,
          focusableNodes: _focusableNodes,
          onAddHabit: () => _showAddHabit(activeHabits),
          onOpenSettings: () => _onTabChanged(3),
          onOpenAnalytics: () => _onTabChanged(2),
          onShowKeyboardShortcuts: _showKeyboardShortcuts,
          child: Scaffold(
            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () => _showAddHabit(activeHabits),
                    child: const Icon(Icons.add),
                  )
                : null,
            bottomNavigationBar: _buildCustomBottomNavigationBar(),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHabitsTab(
                  filteredHabits,
                  categories,
                  overallSuccessRate,
                  settingsState,
                ),
                _buildDashboardTab(
                  filteredHabits,
                  overallSuccessRate,
                  bestStreak,
                  bestStreakHabit,
                  settingsState,
                ),
                AnalyticsDashboardPage(
                  habits: filteredHabits,
                  showBackButton: false,
                ),
                const SettingsPage(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitsTab(
    List<Habit> filteredHabits,
    List<String> categories,
    double overallSuccessRate,
    SettingsState settingsState,
  ) {
    return Column(
      children: [
        _buildHabitsHeader(overallSuccessRate, filteredHabits.isNotEmpty),
        _buildSuccessRateCard(
          overallSuccessRate,
          settingsState.showSuccessRate,
        ),
        _buildDaySelector(),
        _buildCategoryFilterRow(categories),
        Expanded(
          child: filteredHabits.isEmpty
              ? _buildEmpty()
              : _buildHabitsList(filteredHabits),
        ),
      ],
    );
  }

  Widget _buildDashboardTab(
    List<Habit> filteredHabits,
    double overallSuccessRate,
    int bestStreak,
    String bestStreakHabit,
    SettingsState settingsState,
  ) {
    return _buildDashboard(
      filteredHabits,
      overallSuccessRate,
      bestStreak,
      bestStreakHabit,
      settingsState,
    );
  }

  Widget _buildHabitsHeader(double overallSuccessRate, bool hasHabits) {
    final encouragement = EncouragementService.getEncouragement(
      overallSuccessRate,
      hasHabits,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_getGreeting()},",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  encouragement.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessRateCard(double overallSuccessRate, bool show) {
    if (!show) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Success Rate',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: overallSuccessRate / 100,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${overallSuccessRate.toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterRow(List<String> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedCategory == null,
            onSelected: (selected) {
              if (selected) setState(() => _selectedCategory = null);
            },
          ),
          const SizedBox(width: 8),
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat),
                selected: _selectedCategory == cat,
                onSelected: (selected) {
                  setState(() => _selectedCategory = selected ? cat : null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final today = DateTime.now();
    return SizedBox(
      height: 90,
      child: ListView.builder(
        controller: _daySelectorScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 365,
        itemBuilder: (context, index) {
          final date = today.subtract(Duration(days: 30 - index));
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          final isToday = DateUtils.isSameDay(date, today);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : isToday
                    ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.4)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : isToday
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 2),
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
                    DateFormat('d').format(date),
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

  void _centerToday() {
    if (_daySelectorScrollController.hasClients) {
      _daySelectorScrollController.animateTo(
        30 * 63.0 - (MediaQuery.of(context).size.width / 2) + 31,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No habits for today',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a habit to get started!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(List<Habit> filteredHabits) {
    return ListView.builder(
      controller: _habitsScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: filteredHabits.length,
      itemBuilder: (context, index) {
        final habit = filteredHabits[index];
        return HabitListItem(
          habit: habit,
          selectedDate: _selectedDate,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailPage(habit: habit),
              ),
            );
          },
          onCompletionTap: () => _toggleHabitCompletion(habit),
        );
      },
    );
  }

  void _toggleHabitCompletion(Habit habit) {
    final entry = habit.entries.firstWhereOrNull(
      (e) =>
          e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day,
    );

    if (entry == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddEntryDialog(
          habit: habit,
          selectedDate: _selectedDate,
          onSave: (newEntry) async {
            await ref.read(habitsProvider.notifier).addEntry(habit, newEntry);
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Entry Notes/Value'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddEntryDialog(
                      habit: habit,
                      selectedDate: _selectedDate,
                      onSave: (updatedEntry) async {
                        await ref
                            .read(habitsProvider.notifier)
                            .updateEntry(habit, entry, updatedEntry);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Entry'),
                onTap: () async {
                  await ref
                      .read(habitsProvider.notifier)
                      .deleteEntry(habit, entry);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDashboard(
    List<Habit> filteredHabits,
    double overallSuccessRate,
    int bestStreak,
    String bestStreakHabit,
    SettingsState settingsState,
  ) {
    return ListView(
      controller: _dashboardScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Success Rate',
                '${overallSuccessRate.toStringAsFixed(0)}%',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Best Streak',
                '$bestStreak Days',
                Icons.flash_on,
                Colors.orange,
                subtitle: bestStreakHabit.isNotEmpty
                    ? 'on $bestStreakHabit'
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Success Rate History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getLineChartSpots(filteredHabits),
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getLineChartSpots(List<Habit> habits) {
    final spots = <FlSpot>[];
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      int totalDue = 0;
      int doneCount = 0;
      for (var habit in habits) {
        if (habit.isDueOnDate(date)) {
          totalDue++;
          final entry = habit.entries.firstWhereOrNull(
            (e) => DateUtils.isSameDay(e.date, date),
          );
          if (entry != null && habit.isPositiveDay(entry)) {
            doneCount++;
          }
        }
      }
      final rate = totalDue > 0 ? (doneCount / totalDue) * 100 : 0.0;
      spots.add(FlSpot(i.toDouble(), rate));
    }
    return spots;
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onTabChanged,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.check_circle_outline),
          selectedIcon: Icon(Icons.check_circle),
          label: 'Today',
        ),
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _showKeyboardShortcuts() {
    showDialog(
      context: context,
      builder: (context) => const KeyboardShortcutsDialog(),
    );
  }
}
