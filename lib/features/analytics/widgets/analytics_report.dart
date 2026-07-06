import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/data/models/habit_entry.dart';
import 'chart_data_models.dart';

class AnalyticsReport extends StatelessWidget {
  final List<Habit> habits;

  const AnalyticsReport({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCorrelationAnalysis(context),
        const SizedBox(height: 24),
        _buildPerformanceInsights(),
        const SizedBox(height: 24),
        _buildRecommendations(),
      ],
    );
  }

  Widget _buildCorrelationAnalysis(BuildContext context) {
    final correlations = _calculateCorrelations();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Correlations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Shows which habits tend to succeed or fail together. A coefficient close to 1.0 means they occur together, while -1.0 means one succeeds when the other fails.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (correlations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Not enough data to calculate correlations yet'),
                ),
              )
            else
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('Habit 1', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('Habit 2', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('Strength', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary), textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  ...correlations.map((corr) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(corr.habit1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(corr.habit2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          corr.coefficient.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: corr.coefficient > 0 ? Colors.green : Colors.red,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    final insights = _generatePerformanceInsights();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (insights.isEmpty)
              const Center(child: Text('Add more entries to generate insights!'))
            else
              ...insights.map((insight) => _buildInsightItem(insight)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(InsightData insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: insight.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: insight.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(insight.icon, color: insight.color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = _generateRecommendations();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Center(child: Text('Keep tracking to receive recommendations!'))
            else
              ...recommendations.map((rec) => _buildRecommendationItem(rec)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(RecommendationData recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation.text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<CorrelationData> _calculateCorrelations() {
    List<CorrelationData> correlations = [];
    
    if (habits.length < 2) return correlations;
    
    for (int i = 0; i < habits.length; i++) {
      for (int j = i + 1; j < habits.length; j++) {
        final habit1 = habits[i];
        final habit2 = habits[j];
        
        final correlation = _calculateSimpleCorrelation(habit1, habit2);
        
        if (correlation.abs() > 0.3) {
          correlations.add(CorrelationData(
            habit1: habit1.formattedName,
            habit2: habit2.formattedName,
            coefficient: correlation,
          ));
        }
      }
    }
    
    return correlations;
  }

  double _calculateSimpleCorrelation(Habit habit1, Habit habit2) {
    final dates1 = habit1.entries.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
    final dates2 = habit2.entries.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
    final commonDates = dates1.intersection(dates2).toList();
    
    if (commonDates.length < 5) return 0.0;
    
    int bothSuccess = 0;
    int bothFail = 0;
    int oneSuccessOneFail = 0;
    
    for (var date in commonDates) {
      final entry1 = habit1.entries.firstWhereOrNull((e) => 
          DateTime(e.date.year, e.date.month, e.date.day) == date);
      final entry2 = habit2.entries.firstWhereOrNull((e) => 
          DateTime(e.date.year, e.date.month, e.date.day) == date);
      
      if (entry1 != null && entry2 != null) {
        final success1 = habit1.isPositiveDay(entry1);
        final success2 = habit2.isPositiveDay(entry2);
        
        if (success1 && success2) {
          bothSuccess++;
        } else if (!success1 && !success2) {
          bothFail++;
        } else {
          oneSuccessOneFail++;
        }
      }
    }
    
    final agreements = bothSuccess + bothFail;
    final total = commonDates.length;
    
    return (agreements - oneSuccessOneFail) / total;
  }

  List<InsightData> _generatePerformanceInsights() {
    List<InsightData> insights = [];
    
    if (habits.isEmpty) return insights;
    
    final bestHabit = habits.reduce((a, b) => 
        a.successRate > b.successRate ? a : b);
    insights.add(InsightData(
      title: 'Best Performer',
      description: '${bestHabit.formattedName} has ${bestHabit.successRate.toStringAsFixed(1)}% success rate',
      icon: Icons.star,
      color: Colors.green,
    ));
    
    final mostConsistent = habits.reduce((a, b) => 
        a.currentStreak > b.currentStreak ? a : b);
    if (mostConsistent.currentStreak > 0) {
      insights.add(InsightData(
        title: 'Most Consistent',
        description: '${mostConsistent.formattedName} has a ${mostConsistent.currentStreak}-day streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
      ));
    }
    
    final entryDates = habits
        .expand((h) => h.entries)
        .map((e) => e.date.weekday)
        .toList();
    
    if (entryDates.isNotEmpty) {
      final dayCount = <int, int>{};
      for (var day in entryDates) {
        dayCount[day] = (dayCount[day] ?? 0) + 1;
      }
      
      final mostActiveDay = dayCount.entries.reduce((a, b) => 
          a.value > b.value ? a : b);
      final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      
      insights.add(InsightData(
        title: 'Most Active Day',
        description: '${dayNames[mostActiveDay.key - 1]} with ${mostActiveDay.value} entries',
        icon: Icons.calendar_today,
        color: Colors.blue,
      ));
    }
    
    return insights;
  }

  List<RecommendationData> _generateRecommendations() {
    List<RecommendationData> recommendations = [];
    
    final strugglingHabits = habits.where((h) => h.successRate < 50 && h.entries.length > 5).toList();
    
    if (strugglingHabits.isNotEmpty) {
      recommendations.add(RecommendationData(
        'Consider reviewing ${strugglingHabits.first.formattedName} - try adjusting the target or frequency',
      ));
    }
    
    final now = DateTime.now();
    final staleHabits = habits.where((h) {
      if (h.entries.isEmpty) return true;
      final lastEntry = h.entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b);
      return now.difference(lastEntry).inDays > 7;
    }).toList();
    
    if (staleHabits.isNotEmpty) {
      recommendations.add(RecommendationData(
        'You haven\'t logged ${staleHabits.first.formattedName} recently - consider adding an entry',
      ));
    }
    
    final correlations = habits.length >= 2 ? _calculateCorrelations() : <CorrelationData>[];
    final strongPositiveCorrelations = correlations.where((c) => c.coefficient > 0.5).toList();
    
    if (strongPositiveCorrelations.isNotEmpty) {
      final correlation = strongPositiveCorrelations.first;
      recommendations.add(RecommendationData(
        '${correlation.habit1} and ${correlation.habit2} work well together - consider doing them consecutively',
      ));
    }
    
    return recommendations;
  }
}
