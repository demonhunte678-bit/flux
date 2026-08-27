class HabitEntry {
  DateTime date;
  double value;

  // Quantifiable entries (e.g., 30 minutes, 5.5 km)
  String? unit;
  String? notes;
  bool isSkipped;
  bool isArchived;

  HabitEntry({
    required this.date,
    required this.value,
    this.unit,
    this.notes,
    this.isSkipped = false,
    this.isArchived = false,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'value': value,
    'unit': unit,
    'notes': notes,
    'isSkipped': isSkipped,
    'isArchived': isArchived,
  };

  static HabitEntry fromJson(Map<String, dynamic> json) => HabitEntry(
    date: DateTime.parse(json['date']),
    value: (json['value'] ?? json['count'] ?? 1.0).toDouble(),
    unit: json['unit'],
    notes: json['notes'],
    isSkipped: json['isSkipped'] ?? false,
    isArchived: json['isArchived'] ?? false,
  );
}
