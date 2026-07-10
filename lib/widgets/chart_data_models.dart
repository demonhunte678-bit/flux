import 'package:flutter/material.dart';

class HabitTrendData {
  final String habitName;
  final List<ChartDataPoint> points;
  final Color color;

  HabitTrendData({
    required this.habitName,
    required this.points,
    required this.color,
  });
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint(this.date, this.value);
}

class StreakDataPoint {
  final String habitName;
  final int streak;
  final Color color;

  StreakDataPoint({
    required this.habitName,
    required this.streak,
    required this.color,
  });
}

class PieDataPoint {
  final String label;
  final double value;
  final Color color;

  PieDataPoint(this.label, this.value, this.color);
}

class FrequencyDataPoint {
  final String frequency;
  final int count;

  FrequencyDataPoint(this.frequency, this.count);
}

class CorrelationData {
  final String habit1;
  final String habit2;
  final double coefficient;

  CorrelationData({
    required this.habit1,
    required this.habit2,
    required this.coefficient,
  });
}

class InsightData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  InsightData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class RecommendationData {
  final String text;

  RecommendationData(this.text);
}
