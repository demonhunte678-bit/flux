import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static final AppDatabase instance = AppDatabase();
}

QueryExecutor _openConnection() {
  return SqfliteQueryExecutor.inDatabaseFolder(path: 'flux_habits_drift.db');
}
