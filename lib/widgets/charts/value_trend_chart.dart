import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flux/index.dart';
import 'package:flux/l10n/index.dart';

class ValueTrendChart extends StatelessWidget {
  final List<Habit> habits;

  const ValueTrendChart({super.key, required this.habits});

  List<HabitTrendData> _generateValueTrendData() {
    return habits.where((h) => h.unit != HabitUnit.count).take(3).map((habit) {
      List<ChartDataPoint> points = [];

      for (var entry in habit.entries) {
        points.add(
          ChartDataPoint(
            DateTime(entry.date.year, entry.date.month, entry.date.day),
            entry.value!,
          ),
        );
      }

      points.sort((a, b) => a.date.compareTo(b.date));

      return HabitTrendData(
        habitName: habit.name,
        points: points,
        color: habit.color ?? Colors.green,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _generateValueTrendData();

    if (chartData.isEmpty) return const SizedBox();

    final locale = Localizations.localeOf(context).toString();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.valueTrends,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat('MMM d', locale),
                  intervalType: DateTimeIntervalType.days,
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: context.l10n.values),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: chartData
                    .map(
                      (habitData) => ColumnSeries<ChartDataPoint, DateTime>(
                        name: habitData.habitName,
                        dataSource: habitData.points,
                        xValueMapper: (point, _) => point.date,
                        yValueMapper: (point, _) => point.value,
                        color: habitData.color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
