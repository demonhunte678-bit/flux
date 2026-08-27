import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/pages/add_habit_page.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';
import 'package:flux/core/index.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

import 'habits_page.dart';
import 'dashboard_page.dart';
import 'analytics_dashboard_page.dart';
import 'settings_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;
  late ScrollController _habitsScrollController;
  late ScrollController _dashboardScrollController;
  List<FocusNode> _focusableNodes = [];
  final KeyboardService _keyboardService = KeyboardService();

  @override
  void initState() {
    super.initState();
    _habitsScrollController = ScrollController();
    _dashboardScrollController = ScrollController();
    _focusableNodes = List.generate(20, (index) => FocusNode());

    _keyboardService.setScrollController(_habitsScrollController);
  }

  @override
  void dispose() {
    _habitsScrollController.dispose();
    _dashboardScrollController.dispose();
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
        : (index == 1 ? _dashboardScrollController : null);
    _keyboardService.setScrollController(currentController);
  }

  void _handlePreviousPage() {
    if (_currentIndex > 0) {
      _onTabChanged(_currentIndex - 1);
    }
  }

  void _handleNextPage() {
    if (_currentIndex < 3) {
      _onTabChanged(_currentIndex + 1);
    }
  }

  void _showAddHabit() {
    final habitsAsync = ref.read(habitsProvider);
    final activeHabits = habitsAsync.maybeWhen(
      data: (habits) => habits.where((h) => !h.isArchived).toList(),
      orElse: () => <Habit>[],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddHabitPage(
          onSave: (h) async {
            if (h.name.isEmpty) return;
            await ref.read(habitsProvider.notifier).addHabit(h);
            if (mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showKeyboardShortcuts() {
    showDialog(
      context: context,
      builder: (context) => const KeyboardShortcutsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAwareWidget(
      scrollController: _currentIndex == 0
          ? _habitsScrollController
          : (_currentIndex == 1 ? _dashboardScrollController : null),
      focusableNodes: _focusableNodes,
      onAddHabit: _showAddHabit,
      onOpenSettings: () => _onTabChanged(3),
      onOpenAnalytics: () => _onTabChanged(2),
      onShowKeyboardShortcuts: _showKeyboardShortcuts,
      onPreviousPage: _handlePreviousPage,
      onNextPage: _handleNextPage,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabChanged,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.check_circle_outline),
              selectedIcon: const Icon(Icons.check_circle),
              label: L10n.of(context)!.todayTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: L10n.of(context)!.dashboardTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.analytics_outlined),
              selectedIcon: const Icon(Icons.analytics),
              label: L10n.of(context)!.analyticsTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: L10n.of(context)!.settingsTab,
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              HabitsPage(
                scrollController: _habitsScrollController,
                onAddHabit: _showAddHabit,
              ),
              DashboardPage(
                scrollController: _dashboardScrollController,
              ),
              const AnalyticsDashboardPage(
                showBackButton: false,
              ),
              const SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
