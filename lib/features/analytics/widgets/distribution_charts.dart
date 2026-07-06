import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/core/enums/app_enums.dart';
import 'chart_data_models.dart';

class HabitTypeDistributionChart extends StatelessWidget {
  final List<Habit> habits;

  const HabitTypeDistributionChart({super.key, required this.habits});

  List<PieDataPoint> _generateHabitTypeData() {
    final Map<HabitType, int> typeCount = {};
    
    for (var habit in habits) {
      typeCount[habit.type] = (typeCount[habit.type] ?? 0) + 1;
    }
    
    return typeCount.entries.map((entry) {
      String label;
      Color color;
      
      switch (entry.key) {
        case HabitType.SuccessBased:
          label = 'Achieve';
          color = Colors.green;
          break;
        case HabitType.FailBased:
          label = 'Avoid';
          color = Colors.red;
          break;
        case HabitType.DoneBased:
          label = 'Check';
          color = Colors.blue;
          break;
      }
      
      return PieDataPoint(label, entry.value.toDouble(), color);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final typeData = _generateHabitTypeData();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Type Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCircularChart(
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  PieSeries<PieDataPoint, String>(
                    dataSource: typeData,
                    xValueMapper: (point, _) => point.label,
                    yValueMapper: (point, _) => point.value,
                    pointColorMapper: (point, _) => point.color,
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

class CategoryDistributionChart extends StatelessWidget {
  final List<Habit> habits;

  const CategoryDistributionChart({super.key, required this.habits});

  List<PieDataPoint> _generateCategoryData() {
    final Map<String, int> categoryCount = {};
    
    for (var habit in habits) {
      final category = habit.category ?? 'Uncategorized';
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink, Colors.teal];
    int colorIndex = 0;
    
    return categoryCount.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieDataPoint(entry.key, entry.value.toDouble(), color);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _generateCategoryData();
    
    if (categoryData.isEmpty) return const SizedBox();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCircularChart(
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  DoughnutSeries<PieDataPoint, String>(
                    dataSource: categoryData,
                    xValueMapper: (point, _) => point.label,
                    yValueMapper: (point, _) => point.value,
                    pointColorMapper: (point, _) => point.color,
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

class FrequencyDistributionChart extends StatelessWidget {
  final List<Habit> habits;

  const FrequencyDistributionChart({super.key, required this.habits});

  List<FrequencyDataPoint> _generateFrequencyData() {
    final Map<HabitFrequency, int> frequencyCount = {};
    
    for (var habit in habits) {
      frequencyCount[habit.frequency] = (frequencyCount[habit.frequency] ?? 0) + 1;
    }
    
    return frequencyCount.entries.map((entry) {
      String label = entry.key.toString().split('.').last;
      label = label.replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => ' ${match.group(1)}',
      ).trim();
      label = label[0].toUpperCase() + label.substring(1);
      return FrequencyDataPoint(label, entry.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final frequencyData = _generateFrequencyData();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequency Distribution',
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
                  title: AxisTitle(text: 'Number of Habits'),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  ColumnSeries<FrequencyDataPoint, String>(
                    dataSource: frequencyData,
                    xValueMapper: (point, _) => point.frequency,
                    yValueMapper: (point, _) => point.count,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
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
