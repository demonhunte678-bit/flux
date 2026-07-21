import 'dart:convert';
import 'dart:io';
import 'package:flux/index.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<Directory> _dataDir() async {
    final supportDir = await PathService.getAppSupportDirectory();
    final data = Directory('${supportDir.path}/habits');

    // Migrate habits folder if exists in documents
    if (!await data.exists()) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final oldDataDir = Directory('${docDir.path}/habits');
        if (await oldDataDir.exists()) {
          if (!await supportDir.exists()) await supportDir.create(recursive: true);
          // Simply rename/move the directory
          await oldDataDir.rename(data.path);
        }
      } catch (e) {
        // Ignore
      }
    }

    if (!await data.exists()) await data.create(recursive: true);
    return data;
  }

  static Future<List<Habit>> loadAll() async {
    try {
      return await HabitsRepository.instance.loadAllHabits();
    } catch (e) {
      print('Error loading habits: $e');
      return [];
    }
  }

  static Future<void> save(Habit habit) async {
    await HabitsRepository.instance.saveHabit(habit);
  }

  static Future<void> delete(Habit habit) async {
    await HabitsRepository.instance.deleteHabit(habit.id);
  }

  static Future<void> updateEntry(
    Habit habit,
    HabitEntry oldEntry,
    HabitEntry newEntry,
  ) async {
    await HabitsRepository.instance.updateEntry(habit, oldEntry, newEntry);
  }

  static Future<void> deleteEntry(Habit habit, HabitEntry entry) async {
    await HabitsRepository.instance.deleteEntry(habit, entry);
  }

  // Migration method to move from JSON files to Drift database
  static Future<void> migrateFromJsonToDatabase() async {
    try {
      final dir = await _dataDir();
      final files = dir.listSync();
      final habits = files
          .whereType<File>()
          .map((f) => Habit.fromJson(jsonDecode(f.readAsStringSync())))
          .toList();

      // Save all habits to the database
      await HabitsRepository.instance.migrateFromJson(habits);

      // Backup and remove the old JSON files
      final backupDir = Directory('${dir.path}/json_backup');
      if (!await backupDir.exists()) await backupDir.create();

      for (var file in files.whereType<File>()) {
        final backupFile = File(
          '${backupDir.path}/${file.path.split('/').last}',
        );
        await file.copy(backupFile.path);
        await file.delete();
      }

      print('Migration completed successfully!');
    } catch (e) {
      print('Error during migration: $e');
    }
  }

  static Future<File> _settingsFile() async {
    final supportDir = await PathService.getAppSupportDirectory();
    final targetFile = File('${supportDir.path}/settings.json');

    // Migration of settings.json from Documents to ApplicationSupport
    if (!await targetFile.exists()) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final oldFile = File('${docDir.path}/settings.json');
        if (await oldFile.exists()) {
          if (!await supportDir.exists()) {
            await supportDir.create(recursive: true);
          }
          await oldFile.copy(targetFile.path);
          await oldFile.delete();
        }
      } catch (e) {
        // Ignore
      }
    }
    return targetFile;
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
