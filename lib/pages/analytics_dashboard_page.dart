import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';
class AnalyticsDashboardPage extends StatefulWidget {
  final List<Habit> habits;
  final bool showBackButton;
  
  const AnalyticsDashboardPage({super.key, required this.habits, this.showBackButton = true});
  
  @override
  _AnalyticsDashboardPageState createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Last 30 Days';
  DateTime? _startDate;
  DateTime? _endDate;
  
  final List<String> _timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
    'All Time',
    'Custom Range'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setDateRange();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setDateRange() {
    final now = DateTime.now();
    switch (_selectedTimeRange) {
      case 'Last 7 Days':
        _startDate = now.subtract(const Duration(days: 7));
        _endDate = now;
        break;
      case 'Last 30 Days':
        _startDate = now.subtract(const Duration(days: 30));
        _endDate = now;
        break;
      case 'Last 90 Days':
        _startDate = now.subtract(const Duration(days: 90));
        _endDate = now;
        break;
      case 'This Year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        break;
      case 'All Time':
        _startDate = null;
        _endDate = null;
        break;
      case 'Custom Range':
        // Handled by date picker
        break;
    }
  }

  List<Habit> get _filteredHabits {
    if (_startDate == null || _endDate == null) return widget.habits;
    
    return widget.habits.map((habit) {
      final filteredEntries = habit.entries.where((entry) {
        return entry.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
               entry.date.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
      
      // Create a copy of the habit with filtered entries
      final filteredHabit = Habit(
        id: habit.id,
        name: habit.name,
        type: habit.type,
        displayMode: habit.displayMode,
        icon: habit.icon,
        color: habit.color,
        isArchived: habit.isArchived,
        notes: habit.notes,
        category: habit.category,
        frequency: habit.frequency,
        customDays: habit.customDays,
        targetFrequency: habit.targetFrequency,
        targetValue: habit.targetValue,
        unit: habit.unit,
        customUnit: habit.customUnit,
        entries: filteredEntries,
      );
      
      return filteredHabit;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Trends'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Distribution'),
            Tab(icon: Icon(Icons.grid_view), text: 'Heatmap'),
            Tab(icon: Icon(Icons.analytics), text: 'Insights'),
          ],
        ),
        automaticallyImplyLeading: widget.showBackButton,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
                if (value == 'Custom Range') {
                  _showDateRangePicker();
                } else {
                  _setDateRange();
                }
              });
            },
            itemBuilder: (context) => _timeRanges.map((range) =>
              PopupMenuItem(
                value: range,
                child: Text(range),
              ),
            ).toList(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrendsTab(),
          _buildDistributionTab(),
          _buildHeatmapTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    final filtered = _filteredHabits;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeInfo(),
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

  Widget _buildDistributionTab() {
    final filtered = _filteredHabits;
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

  Widget _buildHeatmapTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Heatmap',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ActivityHeatmap(habits: _filteredHabits),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AnalyticsReport(habits: _filteredHabits),
    );
  }

  Widget _buildDateRangeInfo() {
    String rangeText = _selectedTimeRange;
    if (_startDate != null && _endDate != null) {
      final formatter = DateFormat('MMM d, yyyy');
      rangeText += '\n${formatter.format(_startDate!)} - ${formatter.format(_endDate!)}';
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.date_range, color: Theme.of(context).colorScheme.primary),
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

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null 
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}