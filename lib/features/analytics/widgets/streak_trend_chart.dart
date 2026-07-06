import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flux/data/models/habit.dart';
import 'chart_data_models.dart';

class StreakTrendChart extends StatelessWidget {
  final List<Habit> habits;

  const StreakTrendChart({super.key, required this.habits});

  List<StreakDataPoint> _generateStreakData() {
    return habits.map((habit) => StreakDataPoint(
      habitName: habit.formattedName,
      streak: habit.currentStreak,
      color: habit.color ?? Colors.orange,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _generateStreakData();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Streaks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Days'),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  BarSeries<StreakDataPoint, String>(
                    dataSource: chartData,
                    xValueMapper: (point, _) => point.habitName,
                    yValueMapper: (point, _) => point.streak,
                    pointColorMapper: (point, _) => point.color,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
