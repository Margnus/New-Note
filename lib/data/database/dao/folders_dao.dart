import 'package:drift/drift.dart';
import '../app_database.dart';

part 'folders_dao.g.dart';

@DriftAccessor(tables: [Folders])
class FoldersDao extends DatabaseAccessor<AppDatabase> with _$FoldersDaoMixin {
  FoldersDao(super.db);

  Future<List<Folder>> getAllFolders() async {
    return (select(folders)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<List<Folder>> getRootFolders() async {
    return (select(folders)
          ..where((tbl) => tbl.parentId.isNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<List<Folder>> getSubFolders(String parentId) async {
    return (select(folders)
          ..where((tbl) => tbl.parentId.equals(parentId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<Folder?> getFolderById(String id) async {
    return (select(folders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertFolder(FoldersCompanion folder) async {
    return into(folders).insert(folder);
  }

  Future<bool> updateFolder(FoldersCompanion folder) async {
    return update(folders).replace(folder);
  }

  Future<int> deleteFolder(String id) async {
    return (delete(folders)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteFolderAndContents(String id) async {
    await (delete(db.notes)..where((tbl) => db.notes.folderId.equals(id))).go();

    final subFolders = await getSubFolders(id);
    for (final folder in subFolders) {
      await deleteFolderAndContents(folder.id);
    }

    return deleteFolder(id);
  }
}
