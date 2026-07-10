class HabitEntry {
  DateTime date;
  int count;
  
  // Quantifiable entries (e.g., 30 minutes, 5.5 km)
  double? value;
  String? unit;
  String? notes;
  bool isSkipped;
  
  HabitEntry({
    required this.date, 
    required this.count, 
    this.value,
    this.unit,
    this.notes,
    this.isSkipped = false,
  });
  
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'count': count,
        'value': value,
        'unit': unit,
        'notes': notes,
        'isSkipped': isSkipped,
      };
      
  static HabitEntry fromJson(Map<String, dynamic> json) => HabitEntry(
        date: DateTime.parse(json['date']),
        count: json['count'],
        value: json['value']?.toDouble(),
        unit: json['unit'],
        notes: json['notes'],
        isSkipped: json['isSkipped'] ?? false,
      );
}
