// lib/main.dart

import 'dart:convert';
import 'dart:io';
import 'package:flux/core/services/database_service.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/data/models/habit_entry.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<Directory> _dataDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final data = Directory('${dir.path}/habits');
    if (!await data.exists()) await data.create();
    return data;
  }

  static Future<List<Habit>> loadAll() async {
    try {
      return await DatabaseService.instance.loadAllHabits();
    } catch (e) {
      print('Error loading habits: $e');
      return [];
    }
  }

  static Future<void> save(Habit habit) async {
    await DatabaseService.instance.saveHabit(habit);
  }

  static Future<void> delete(Habit habit) async {
    await DatabaseService.instance.deleteHabit(habit);
  }
  
  static Future<void> updateEntry(Habit habit, HabitEntry oldEntry, HabitEntry newEntry) async {
    await DatabaseService.instance.updateEntry(habit, oldEntry, newEntry);
  }
  
  static Future<void> deleteEntry(Habit habit, HabitEntry entry) async {
    await DatabaseService.instance.deleteEntry(habit, entry);
  }
  
  // Migration method to move from JSON files to SQLite database
  static Future<void> migrateFromJsonToDatabase() async {
    try {
      final dir = await _dataDir();
      final files = dir.listSync();
      final habits = files
          .whereType<File>()
          .map((f) => Habit.fromJson(jsonDecode(f.readAsStringSync())))
          .toList();
      
      // Save all habits to the database
      await DatabaseService.instance.migrateFromJson(habits);
      
      // Optionally, backup and remove the old JSON files
      final backupDir = Directory('${dir.path}/json_backup');
      if (!await backupDir.exists()) await backupDir.create();
      
      for (var file in files.whereType<File>()) {
        final backupFile = File('${backupDir.path}/${file.path.split('/').last}');
        await file.copy(backupFile.path);
        await file.delete();
      }
      
      print('Migration completed successfully!');
    } catch (e) {
      print('Error during migration: $e');
    }
  }

  static Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/settings.json');
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final file = await _settingsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error loading settings file: $e');
    }
    return {};
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final file = await _settingsFile();
      await file.writeAsString(jsonEncode(settings));
    } catch (e) {
      print('Error saving settings file: $e');
    }
  }
}
