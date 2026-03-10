import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Notes,
  Folders,
  Tags,
  NoteTags,
], daos: [
  NotesDao,
  FoldersDao,
  TagsDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here
      },
    );
  }
}
