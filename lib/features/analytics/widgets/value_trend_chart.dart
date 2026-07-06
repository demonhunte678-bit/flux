import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/core/enums/app_enums.dart';
import 'chart_data_models.dart';

class ValueTrendChart extends StatelessWidget {
  final List<Habit> habits;

  const ValueTrendChart({super.key, required this.habits});

  List<HabitTrendData> _generateValueTrendData() {
    return habits.where((h) => h.unit != HabitUnit.Count).take(3).map((habit) {
      List<ChartDataPoint> points = [];
      
      for (var entry in habit.entries) {
        if (entry.value != null) {
          points.add(ChartDataPoint(
            DateTime(entry.date.year, entry.date.month, entry.date.day),
            entry.value!,
          ));
        }
      }
      
      points.sort((a, b) => a.date.compareTo(b.date));
      
      return HabitTrendData(
        habitName: habit.formattedName,
        points: points,
        color: habit.color ?? Colors.green,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _generateValueTrendData();
    
    if (chartData.isEmpty) return const SizedBox();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Value Trends',
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
                  title: AxisTitle(text: 'Values'),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: chartData.map((habitData) => 
                  ColumnSeries<ChartDataPoint, DateTime>(
                    name: habitData.habitName,
                    dataSource: habitData.points,
                    xValueMapper: (point, _) => point.date,
                    yValueMapper: (point, _) => point.value,
                    color: habitData.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
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
