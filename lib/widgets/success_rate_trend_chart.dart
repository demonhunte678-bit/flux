import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flux/index.dart';import 'package:flux/index.dart';import 'chart_data_models.dart';

class SuccessRateTrendChart extends StatelessWidget {
  final List<Habit> habits;

  const SuccessRateTrendChart({super.key, required this.habits});

  List<HabitTrendData> _generateSuccessRateData() {
    return habits.take(5).map((habit) {
      List<ChartDataPoint> points = [];
      
      // Group entries by day and calculate daily success rate
      final groupedEntries = groupBy(habit.entries, (HabitEntry entry) => 
          DateTime(entry.date.year, entry.date.month, entry.date.day));
      
      groupedEntries.forEach((date, entries) {
        final positiveEntries = entries.where((e) => habit.isPositiveDay(e)).length;
        final successRate = (positiveEntries / entries.length) * 100;
        points.add(ChartDataPoint(date, successRate));
      });
      
      points.sort((a, b) => a.date.compareTo(b.date));
      
      return HabitTrendData(
        habitName: habit.formattedName,
        points: points,
        color: habit.color ?? Colors.blue,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _generateSuccessRateData();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Success Rate Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat('MMM d'),
                  intervalType: DateTimeIntervalType.days,
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 25,
                  title: AxisTitle(text: 'Success Rate (%)'),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: chartData.map((habitData) => 
                  SplineSeries<ChartDataPoint, DateTime>(
                    name: habitData.habitName,
                    dataSource: habitData.points,
                    xValueMapper: (point, _) => point.date,
                    yValueMapper: (point, _) => point.value,
                    color: habitData.color,
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      width: 6,
                      height: 6,
                    ),
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
