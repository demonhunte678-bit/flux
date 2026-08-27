import 'package:drift/drift.dart';

@DataClassName('CategoryData')
class Categories extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get color => integer().nullable()();
  IntColumn get icon => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
