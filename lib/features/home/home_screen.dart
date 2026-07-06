// lib/main.dart
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flux/core/services/settings_service.dart';
import 'package:flux/features/habits/widgets/add_habit_sheet.dart';
import 'package:flux/features/habits/widgets/add_entry_dialog.dart';
import 'package:flux/core/services/encouragement_service.dart';
import 'package:flux/main.dart';
import 'package:flux/features/settings/settings_screen.dart';
import 'package:flux/features/analytics/analytics_dashboard.dart';
import 'package:flux/core/services/reports_service.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/features/habits/habit_detail_screen.dart';
import 'package:flux/data/models/habit_entry.dart';
import 'package:flux/core/services/storage_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flux/core/services/widget_service.dart';
import 'package:flux/features/backup_and_import/backup_import_screen.dart';
import 'package:flux/core/services/keyboard_service.dart';
import 'package:flux/core/widgets/keyboard_aware_widget.dart';
import 'package:flux/core/widgets/focusable_button.dart';
import 'package:flux/core/widgets/keyboard_shortcuts_dialog.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final Function(String)? changeTheme;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    this.changeTheme,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  List<Habit> _activeHabits = [];
  List<Habit> _archivedHabits = [];
  List<Habit> _filteredHabits = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  int _totalPositiveDays = 0;
  int _totalNegativeDays = 0;
  double _overallSuccessRate = 0;
  int _totalEntries = 0;
  int _bestCurrentStreak = 0;
  String _bestStreakHabit = '';
  bool _showArchived = false;
  String? _selectedCategory;
  List<String> _categories = [];
  bool _showSuccessRate = true;
  bool _showCurrentStreak = true;

  // Date selection & horizontal Day Selector
  DateTime _selectedDate = DateTime.now();
  late ScrollController _daySelectorScrollController;

  // Keyboard navigation
  late ScrollController _habitsScrollController;
  late ScrollController _dashboardScrollController;
  List<FocusNode> _focusableNodes = [];
  final KeyboardService _keyboardService = KeyboardService();

  @override
  void initState() {
    super.initState();

    // Initialize scroll controllers
    _habitsScrollController = ScrollController();
    _dashboardScrollController = ScrollController();
    _daySelectorScrollController = ScrollController();

    // Initialize focus nodes for keyboard navigation
    _initializeFocusNodes();

    _loadHabits();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerToday();
      // Ensure layout stabilizes and scrolls to today perfectly
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

    // Dispose focus nodes
    for (var node in _focusableNodes) {
      node.dispose();
    }
    _focusableNodes.clear();

    super.dispose();
  }

  void _initializeFocusNodes() {
    // Create focus nodes for all interactive elements
    _focusableNodes = List.generate(20, (index) => FocusNode());
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

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    final all = await StorageService.loadAll();
    final showSuccessRate = await SettingsService.getShowSuccessRate();
    final showCurrentStreak = await SettingsService.getShowCurrentStreak();

    // Filter active and archived habits
    final active = all.where((h) => !h.isArchived).toList();
    final archived = all.where((h) => h.isArchived).toList();

    // Extract categories
    final categories =
        active
            .where((h) => h.category != null)
            .map((h) => h.category!)
            .toSet()
            .toList()
          ..sort();

    // Apply category filter
    final filtered = _selectedCategory == null
        ? active
        : active.where((h) => h.category == _selectedCategory).toList();

    // Calculate overall metrics (using filtered habits)
    int totalPositive = 0;
    int totalNegative = 0;
    int totalEntries = 0;
    int bestStreak = 0;
    String bestStreakHabit = '';

    for (var habit in filtered) {
      totalPositive += habit.positiveCount;
      totalNegative += habit.negativeCount;
      totalEntries += habit.entries.length;

      if (habit.currentStreak > bestStreak) {
        bestStreak = habit.currentStreak;
        bestStreakHabit = habit.formattedName;
      }
    }

    setState(() {
      _habits = all;
      _activeHabits = active;
      _archivedHabits = archived;
      _categories = categories;
      _filteredHabits = filtered;
      _totalPositiveDays = totalPositive;
      _totalNegativeDays = totalNegative;
      _totalEntries = totalEntries;
      _showSuccessRate = showSuccessRate;
      _showCurrentStreak = showCurrentStreak;

      int totalDays = totalPositive + totalNegative;
      _overallSuccessRate = totalDays > 0
          ? (totalPositive / totalDays) * 100
          : 0;

      _bestCurrentStreak = bestStreak;
      _bestStreakHabit = bestStreakHabit;
      _isLoading = false;
    });

    // Update home widgets
    await WidgetService.updateHomeWidgets();
  }

  void _showAddHabit() {
    // Get existing categories
    final existingCategories =
        _activeHabits
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
          await StorageService.save(h);
          Navigator.pop(context);
          _loadHabits();
        },
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    ).then((_) => _loadHabits());
  }

  void _toggleArchiveView() {
    setState(() {
      _showArchived = !_showArchived;
    });
  }

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('All Categories'),
              leading: Radio<String?>(
                value: null,
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                  _loadHabits();
                  Navigator.pop(context);
                },
              ),
            ),
            ..._categories.map(
              (category) => ListTile(
                title: Text(category),
                leading: Radio<String?>(
                  value: category,
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                    _loadHabits();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyticsDashboard(habits: _filteredHabits),
      ),
    );
  }

  void _openBackupScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BackupImportScreen()),
    );
  }

  void _showYearInReview() {
    final currentYear = DateTime.now().year;
    final yearReview = ReportsService.generateYearInReview(
      _filteredHabits,
      currentYear,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$currentYear Year in Review'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (yearReview.totalHabits == 0) ...[
                Text('No data available for $currentYear'),
                SizedBox(height: 16),
                Text('Start tracking habits to see your year in review!'),
              ] else ...[
                Text('🎯 Total Habits: ${yearReview.totalHabits}'),
                Text('📅 Total Entries: ${yearReview.totalEntries}'),
                Text(
                  '📊 Success Rate: ${yearReview.overallSuccessRate.toStringAsFixed(1)}%',
                ),
                Text('🔥 Longest Streak: ${yearReview.longestStreak} days'),
                SizedBox(height: 16),
                if (yearReview.milestones.isNotEmpty) ...[
                  Text(
                    '🏆 Key Milestones:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...yearReview.milestones
                      .take(3)
                      .map(
                        (milestone) => Padding(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          child: Text('• ${milestone.title}'),
                        ),
                      ),
                ],
                if (yearReview.insights.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    '💡 Insights:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...yearReview.insights
                      .take(3)
                      .map(
                        (insight) => Padding(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          child: Text(
                            '• ${insight.title}: ${insight.description}',
                          ),
                        ),
                      ),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showKeyboardShortcuts() {
    showKeyboardShortcutsDialog(context);
  }

  void _handleClose() {
    // Close any open dialogs or navigate back
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _handleToggleFullscreen() {
    // This would need to be implemented based on the platform
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fullscreen toggle not implemented on this platform'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showArchived
          ? AppBar(
              title: const Text('Archived Habits'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _toggleArchiveView,
              ),
            )
          : null,
      floatingActionButton: !_showArchived
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: _showAddHabit,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: !_showArchived
          ? _buildCustomBottomNavigationBar()
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showArchived
          ? _buildArchivedList()
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildHabitsTab(),
                _buildDashboardTab(),
                _buildStatisticsTab(),
                _buildSettingsTab(),
              ],
            ),
    );
  }

  Widget _buildHabitsTab() {
    return Column(
      children: [
        _buildHabitsHeader(),
        _buildSuccessRateCard(),
        _buildDaySelector(),
        Expanded(
          child: _filteredHabits.isEmpty
              ? _buildEmpty()
              : _buildHabitsList(_filteredHabits),
        ),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return _buildDashboard();
  }

  Widget _buildStatisticsTab() {
    return AnalyticsDashboard(habits: _filteredHabits);
  }

  Widget _buildSettingsTab() {
    return SettingsScreen();
  }

  Widget _buildHabitsHeader() {
    final encouragement = EncouragementService.getEncouragement(
      _overallSuccessRate,
      _filteredHabits.isNotEmpty,
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
                    ).colorScheme.onSurfaceVariant.withOpacity(0.7),
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

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _currentIndex == index;
    final color = isSelected ? colorScheme.primary : Colors.grey.shade400;

    return InkWell(
      onTap: () => _onTabChanged(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(0, Icons.home_rounded, "Home"),
            _buildBottomNavItem(1, Icons.dashboard_rounded, "Dashboard"),
            const SizedBox(width: 40), // Spacer for center FAB
            _buildBottomNavItem(2, Icons.analytics_rounded, "Statistics"),
            _buildBottomNavItem(3, Icons.settings_rounded, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildArchivedList() {
    if (_archivedHabits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No archived habits',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Archived habits will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            TextButton.icon(
              onPressed: _toggleArchiveView,
              icon: Icon(Icons.arrow_back),
              label: Text('Back to Active Habits'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _habitsScrollController,
      padding: EdgeInsets.all(16),
      itemCount: _archivedHabits.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (_, i) {
        final habit = _archivedHabits[i];
        return HabitListItem(
          habit: habit,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HabitDetailScreen(habit: habit),
              ),
            );
            _loadHabits();
          },
        );
      },
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.add_circle_outline, size: 72, color: Colors.grey),
        SizedBox(height: 16),
        Text('No habits yet', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 8),
        Text(
          'Start tracking your habits to build better routines',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _showAddHabit,
          icon: Icon(Icons.add),
          label: Text('Create Habit'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    ),
  );

  Widget _buildHabitsList(List<Habit> habits) {
    return ListView.separated(
      controller: _habitsScrollController,
      padding: EdgeInsets.all(16),
      itemCount: habits.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final habit = habits[index];
        return HabitListItem(
          habit: habit,
          selectedDate: _selectedDate,
          onCompletionTap: () => _handleCompletionTap(habit),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HabitDetailScreen(habit: habit),
              ),
            );
            _loadHabits();
          },
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good evening";
    } else {
      return "Good night";
    }
  }

  Widget _buildSuccessRateCard() {
    if (!_showSuccessRate) return const SizedBox.shrink();
    final successRate = _overallSuccessRate;
    final hasData = _filteredHabits.isNotEmpty;

    // Get encouragement data from the smart service
    final encouragement = EncouragementService.getEncouragement(
      successRate,
      hasData,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: encouragement.color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      encouragement.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: encouragement.color,
                      ),
                    ),
                    if (hasData) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(${successRate.toStringAsFixed(0)}% Success)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: encouragement.color.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  encouragement.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    height: 1.3,
                  ),
                ),
                if (hasData) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: successRate / 100.0,
                      minHeight: 6,
                      backgroundColor: Colors.grey.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        encouragement.color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: encouragement.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              encouragement.icon,
              color: encouragement.color,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  void _centerToday() {
    if (!_daySelectorScrollController.hasClients) return;
    final screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 70.0; // 58 width + 6 left + 6 right padding
    final double offset = (7 * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    _daySelectorScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  Widget _buildDaySelector() {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);

    // Generate 15 days (7 before, today, 7 after)
    final days = List.generate(15, (index) {
      final date = todayMidnight.subtract(Duration(days: 7 - index));
      return DateTime(date.year, date.month, date.day);
    });

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        controller: _daySelectorScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected =
              date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          final isToday =
              date.year == todayMidnight.year &&
              date.month == todayMidnight.month &&
              date.day == todayMidnight.day;

          final weekdayStr = isToday ? 'TODAY' : DateFormat('E').format(date);
          final dayStr = DateFormat('d').format(date);
          final monthStr = DateFormat('MMM').format(date);

          final colorScheme = Theme.of(context).colorScheme;
          final accentColor = colorScheme.primary;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor
                      : isToday
                      ? accentColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? accentColor
                        : isToday
                        ? accentColor
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekdayStr,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isToday || isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : isToday
                            ? accentColor
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayStr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      monthStr,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleCompletionTap(Habit habit) async {
    final entry = habit.entries.firstWhereOrNull(
      (e) =>
          e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day,
    );

    if (entry == null) {
      // Habit is not done yet, show AddEntryDialog
      final nextDay = habit.getNextDayNumber();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddEntryDialog(
          habit: habit,
          dayNumber: nextDay,
          selectedDate: _selectedDate,
          onSave: (newEntry) async {
            habit.entries.add(newEntry);
            await StorageService.save(habit);
            Navigator.of(context).pop();
            _loadHabits();
          },
        ),
      );
    } else {
      // Entry already exists, show options sheet
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
                  Navigator.pop(context); // Close selection sheet

                  final nextDay = entry.dayNumber;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddEntryDialog(
                      habit: habit,
                      dayNumber: nextDay,
                      selectedDate: _selectedDate,
                      onSave: (updatedEntry) async {
                        // Remove old entry
                        habit.entries.removeWhere(
                          (e) =>
                              e.date.year == _selectedDate.year &&
                              e.date.month == _selectedDate.month &&
                              e.date.day == _selectedDate.day,
                        );

                        // Add updated entry
                        habit.entries.add(updatedEntry);
                        await StorageService.save(habit);
                        Navigator.of(context).pop();
                        _loadHabits();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Entry (Mark Incomplete)'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Entry'),
                      content: const Text(
                        'Are you sure you want to mark this habit as incomplete for this day?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await StorageService.deleteEntry(habit, entry);
                    _loadHabits();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDashboard() {
    if (_habits.isEmpty) {
      return Center(
        child: Text('No data available', style: TextStyle(color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      controller: _dashboardScrollController,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          _buildMetricsCards(),
          SizedBox(height: 24),

          if (_showSuccessRate) ...[
            _buildSectionTitle('Success Rate by Habit'),
            SizedBox(height: 12),
            _buildSuccessRateChart(),
            SizedBox(height: 24),
          ],

          if (_showCurrentStreak) ...[
            _buildSectionTitle('Habit Streaks'),
            SizedBox(height: 12),
            _buildStreaksList(),
            SizedBox(height: 24),
          ],

          _buildSectionTitle('Recent Entries'),
          SizedBox(height: 12),
          _buildRecentEntries(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Column(
      children: [
        Row(
          children: [
            if (_showSuccessRate) ...[
              Expanded(
                child: _buildMetricCard(
                  title: 'Success Rate',
                  value: '${_overallSuccessRate.toStringAsFixed(1)}%',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: _buildMetricCard(
                title: 'Total Entries',
                value: '$_totalEntries',
                icon: Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Positive Days',
                value: '$_totalPositiveDays',
                icon: Icons.thumb_up_alt_outlined,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Negative Days',
                value: '$_totalNegativeDays',
                icon: Icons.thumb_down_alt_outlined,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
        if (_showCurrentStreak && _bestCurrentStreak > 0) ...[
          const SizedBox(height: 12),
          _buildMetricCard(
            title: 'Best Current Streak',
            value: '$_bestCurrentStreak days - $_bestStreakHabit',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            isWide: true,
          ),
        ],
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isWide = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isWide ? 16 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessRateChart() {
    if (_habits.isEmpty) {
      return SizedBox();
    }

    return SizedBox(
      height: 220,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() < _habits.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _habits[value.toInt()].name.length > 6
                                ? '${_habits[value.toInt()].name.substring(0, 6)}...'
                                : _habits[value.toInt()].name,
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: TextStyle(fontSize: 10),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              barGroups: List.generate(_habits.length, (index) {
                final habit = _habits[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: habit.successRate,
                      color: Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreaksList() {
    if (_habits.isEmpty) {
      return SizedBox();
    }

    // Sort habits by current streak
    final sortedHabits = [..._habits]
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: sortedHabits.length > 5 ? 5 : sortedHabits.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final habit = sortedHabits[index];
          return Row(
            children: [
              Icon(
                habit.icon ?? Icons.star,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  habit.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: habit.currentStreak > 0
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${habit.currentStreak} days',
                  style: TextStyle(
                    color: habit.currentStreak > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentEntries() {
    if (_habits.isEmpty) {
      return SizedBox();
    }

    // Collect all entries from all habits
    List<MapEntry<Habit, HabitEntry>> allEntries = [];

    for (var habit in _habits) {
      for (var entry in habit.entries) {
        allEntries.add(MapEntry(habit, entry));
      }
    }

    // Sort by date (newest first)
    allEntries.sort((a, b) => b.value.date.compareTo(a.value.date));

    // Take only the 5 most recent
    final recentEntries = allEntries.take(5).toList();

    if (recentEntries.isEmpty) {
      return Center(child: Text('No entries yet'));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: recentEntries.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final habit = recentEntries[index].key;
          final entry = recentEntries[index].value;
          final isPositive = habit.isPositiveDay(entry);

          return Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPositive ? Icons.check : Icons.close,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy').format(entry.date),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                'Day ${entry.dayNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
