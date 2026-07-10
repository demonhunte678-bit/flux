import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flux/index.dart';

class DataService {
  // Get the path of the database file to export
  static Future<String> exportToSql() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'flux_habits_drift.db'));

    if (await file.exists()) {
      return file.path;
    } else {
      throw Exception('Database file not found');
    }
  }

  // Restore database by replacing the file
  static Future<void> importFromDatabase(String databasePath) async {
    try {
      // Close the current database connection
      await AppDatabase.instance.close();

      final dbFolder = await getApplicationDocumentsDirectory();
      final targetFile = File(join(dbFolder.path, 'flux_habits_drift.db'));
      final sourceFile = File(databasePath);

      if (await sourceFile.exists()) {
        await sourceFile.copy(targetFile.path);
      } else {
        throw Exception('Source database file not found');
      }
    } catch (e) {
      throw Exception('Failed to import database: $e');
    }
  }
}
