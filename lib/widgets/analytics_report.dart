import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'chart_data_models.dart';
import 'package:flux/index.dart';
import 'package:intl/intl.dart';
import 'package:flux/l10n/index.dart';

class AnalyticsReport extends StatelessWidget {
  final List<Habit> habits;

  const AnalyticsReport({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCorrelationAnalysis(context),
        const SizedBox(height: 16),
        _buildPerformanceInsights(context),
        const SizedBox(height: 16),
        _buildRecommendations(context),
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
            Text(
              context.l10n.habitCorrelations,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.habitCorrelationsDesc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (correlations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(context.l10n.notEnoughDataCorrelations),
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
                        child: Text(
                          context.l10n.habit1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          context.l10n.habit2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          context.l10n.strength,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  ...correlations.map(
                    (corr) => TableRow(
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
                              color: corr.coefficient > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights(BuildContext context) {
    final insights = _generatePerformanceInsights(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.performanceInsights,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (insights.isEmpty)
              Center(
                child: Text(context.l10n.notEnoughDataInsights),
              )
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
        color: insight.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: insight.color.withValues(alpha: 0.3)),
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

  Widget _buildRecommendations(BuildContext context) {
    final recommendations = _generateRecommendations(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.recommendations,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              Center(
                child: Text(context.l10n.notEnoughDataRecommendations),
              )
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
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
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
          correlations.add(
            CorrelationData(
              habit1: habit1.name,
              habit2: habit2.name,
              coefficient: correlation,
            ),
          );
        }
      }
    }

    return correlations;
  }

  double _calculateSimpleCorrelation(Habit habit1, Habit habit2) {
    final dates1 = habit1.entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();
    final dates2 = habit2.entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();
    final commonDates = dates1.intersection(dates2).toList();

    if (commonDates.length < 5) return 0.0;

    int bothSuccess = 0;
    int bothFail = 0;
    int oneSuccessOneFail = 0;

    for (var date in commonDates) {
      final entry1 = habit1.entries.firstWhereOrNull(
        (e) => DateTime(e.date.year, e.date.month, e.date.day) == date,
      );
      final entry2 = habit2.entries.firstWhereOrNull(
        (e) => DateTime(e.date.year, e.date.month, e.date.day) == date,
      );

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

  List<InsightData> _generatePerformanceInsights(BuildContext context) {
    List<InsightData> insights = [];

    if (habits.isEmpty) return insights;

    final bestHabit = habits.reduce(
      (a, b) => a.successRate > b.successRate ? a : b,
    );
    insights.add(
      InsightData(
        title: context.l10n.bestPerformer,
        description: context.l10n.bestPerformerDesc(
          bestHabit.name,
          bestHabit.successRate.toStringAsFixed(1),
        ),
        icon: Icons.star,
        color: Colors.green,
      ),
    );

    final mostConsistent = habits.reduce(
      (a, b) => a.currentStreak > b.currentStreak ? a : b,
    );
    if (mostConsistent.currentStreak > 0) {
      insights.add(
        InsightData(
          title: context.l10n.mostConsistent,
          description: context.l10n.mostConsistentDesc(
            mostConsistent.name,
            mostConsistent.currentStreak.toString(),
          ),
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
      );
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

      final mostActiveDay = dayCount.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );

      final locale = Localizations.localeOf(context).toString();
      final formatter = DateFormat.EEEE(locale);
      final dayName = formatter.format(DateTime(2023, 1, 2 + (mostActiveDay.key - 1)));

      insights.add(
        InsightData(
          title: context.l10n.mostActiveDay,
          description: context.l10n.mostActiveDayDesc(
            dayName,
            mostActiveDay.value.toString(),
          ),
          icon: Icons.calendar_today,
          color: Colors.blue,
        ),
      );
    }

    return insights;
  }

  List<RecommendationData> _generateRecommendations(BuildContext context) {
    List<RecommendationData> recommendations = [];

    final strugglingHabits = habits
        .where((h) => h.successRate < 50 && h.entries.length > 5)
        .toList();

    if (strugglingHabits.isNotEmpty) {
      recommendations.add(
        RecommendationData(
          context.l10n.strugglingHabitRec(strugglingHabits.first.name),
        ),
      );
    }

    final now = DateTime.now();
    final staleHabits = habits.where((h) {
      if (h.entries.isEmpty) return true;
      final lastEntry = h.entries
          .map((e) => e.date)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      return now.difference(lastEntry).inDays > 7;
    }).toList();

    if (staleHabits.isNotEmpty) {
      recommendations.add(
        RecommendationData(
          context.l10n.staleHabitRec(staleHabits.first.name),
        ),
      );
    }

    final correlations = habits.length >= 2
        ? _calculateCorrelations()
        : <CorrelationData>[];
    final strongPositiveCorrelations = correlations
        .where((c) => c.coefficient > 0.5)
        .toList();

    if (strongPositiveCorrelations.isNotEmpty) {
      final correlation = strongPositiveCorrelations.first;
      recommendations.add(
        RecommendationData(
          context.l10n.correlationRec(correlation.habit1, correlation.habit2),
        ),
      );
    }

    return recommendations;
  }
}
