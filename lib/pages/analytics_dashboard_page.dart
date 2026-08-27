import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import 'package:flux/data/index.dart';
import 'package:flux/l10n/index.dart';

class AnalyticsDashboardPage extends ConsumerStatefulWidget {
  final bool showBackButton;

  const AnalyticsDashboardPage({
    super.key,
    this.showBackButton = true,
  });

  @override
  ConsumerState<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends ConsumerState<AnalyticsDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
    'All Time',
    'Custom Range',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsProvider);
    final filteredHabits = analyticsState.filteredHabits;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.analyticsDashboard),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.timeline), text: context.l10n.trends),
            Tab(icon: const Icon(Icons.pie_chart), text: context.l10n.distribution),
            Tab(icon: const Icon(Icons.grid_view), text: context.l10n.heatmap),
            Tab(icon: const Icon(Icons.analytics), text: context.l10n.insights),
          ],
        ),
        automaticallyImplyLeading: widget.showBackButton,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              if (value == 'Custom Range') {
                _showDateRangePicker(analyticsState);
              } else {
                ref.read(analyticsProvider.notifier).setTimeRange(value);
              }
            },
            itemBuilder: (context) => _timeRanges
                .map((range) => PopupMenuItem(value: range, child: Text(_getTimeRangeLabel(context, range))))
                .toList(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrendsTab(filteredHabits, analyticsState),
          _buildDistributionTab(filteredHabits),
          _buildHeatmapTab(filteredHabits),
          _buildInsightsTab(filteredHabits),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(List<Habit> filtered, AnalyticsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeInfo(state),
          const SizedBox(height: 16),
          SuccessRateTrendChart(habits: filtered),
          const SizedBox(height: 24),
          ValueTrendChart(habits: filtered),
          const SizedBox(height: 24),
          StreakTrendChart(habits: filtered),
        ],
      ),
    );
  }

  Widget _buildDistributionTab(List<Habit> filtered) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HabitTypeDistributionChart(habits: filtered),
          const SizedBox(height: 24),
          CategoryDistributionChart(habits: filtered),
          const SizedBox(height: 24),
          FrequencyDistributionChart(habits: filtered),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab(List<Habit> filtered) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.activityHeatmap,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ActivityHeatmap(habits: filtered),
        ],
      ),
    );
  }

  Widget _buildInsightsTab(List<Habit> filtered) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AnalyticsReport(habits: filtered),
    );
  }

  Widget _buildDateRangeInfo(AnalyticsState state) {
    String rangeText = _getTimeRangeLabel(context, state.selectedTimeRange);
    if (state.startDate != null && state.endDate != null) {
      final locale = Localizations.localeOf(context).toString();
      final formatter = DateFormat('MMM d, yyyy', locale);
      rangeText +=
          '\n${formatter.format(state.startDate!)} - ${formatter.format(state.endDate!)}';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rangeText,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(AnalyticsState state) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: state.startDate != null && state.endDate != null
          ? DateTimeRange(start: state.startDate!, end: state.endDate!)
          : null,
    );

    if (picked != null) {
      ref.read(analyticsProvider.notifier).setCustomRange(picked.start, picked.end);
    }
  }
  String _getTimeRangeLabel(BuildContext context, String range) {
    switch (range) {
      case 'Last 7 Days':
        return context.l10n.last7Days;
      case 'Last 30 Days':
        return context.l10n.last30Days;
      case 'Last 90 Days':
        return context.l10n.last90Days;
      case 'This Year':
        return context.l10n.thisYear;
      case 'All Time':
        return context.l10n.allTime;
      case 'Custom Range':
        return context.l10n.customRange;
      default:
        return range;
    }
  }
}
