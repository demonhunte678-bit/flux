import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';
import 'package:flux/core/index.dart';

class HabitsPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onAddHabit;

  const HabitsPage({
    super.key,
    required this.scrollController,
    required this.onAddHabit,
  });

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  late ScrollController _daySelectorScrollController;

  @override
  void initState() {
    super.initState();
    _daySelectorScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerToday();
      Future.delayed(const Duration(milliseconds: 150), () {
        _centerToday();
      });
    });
  }

  @override
  void dispose() {
    _daySelectorScrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final settingsState = ref.watch(settingsProvider);

    return habitsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error loading habits: $err'))),
      data: (allHabits) {
        final activeHabits = allHabits.where((h) => !h.isArchived).toList();

        final categories = activeHabits
            .where((h) => h.category != null)
            .map((h) => h.category!)
            .toSet()
            .toList()
          ..sort();

        final filteredHabits = _selectedCategory == null
            ? activeHabits
            : activeHabits.where((h) => h.category == _selectedCategory).toList();

        int totalPositive = 0;
        int totalNegative = 0;
        for (var habit in filteredHabits) {
          totalPositive += habit.positiveCount;
          totalNegative += habit.negativeCount;
        }
        int totalDays = totalPositive + totalNegative;
        final overallSuccessRate = totalDays > 0 ? (totalPositive / totalDays) * 100 : 0.0;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: widget.onAddHabit,
            child: const Icon(Icons.add),
          ),
          body: Column(
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
          ),
        );
      },
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                  "Today's Success Rate",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: overallSuccessRate / 100,
                  backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
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
      controller: widget.scrollController,
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
