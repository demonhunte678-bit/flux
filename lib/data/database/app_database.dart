import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flux/index.dart';
import '../tables/index.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static final AppDatabase instance = AppDatabase();
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final supportDir = await PathService.getAppSupportDirectory();
    final targetFile = File(p.join(supportDir.path, 'flux_habits_drift.db'));

    if (!await targetFile.exists()) {
      // Check if old DB exists in documents
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final oldFile = File(p.join(docDir.path, 'flux_habits_drift.db'));
        if (await oldFile.exists()) {
          if (!await supportDir.exists()) {
            await supportDir.create(recursive: true);
          }
          await oldFile.copy(targetFile.path);
          await oldFile.delete();
        }
      } catch (e) {
        // Ignore if documents is not accessible
      }
    }

    if (!await supportDir.exists()) {
      await supportDir.create(recursive: true);
    }
    return SqfliteQueryExecutor(path: targetFile.path);
  });
}
