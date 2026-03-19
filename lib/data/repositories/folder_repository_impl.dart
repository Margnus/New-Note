import '../../data/database/app_database.dart';
import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';
import 'package:drift/drift.dart';

class FolderRepositoryImpl implements FolderRepository {
  final AppDatabase _database;

  FolderRepositoryImpl(this._database);

  @override
  Future<List<FolderEntity>> getAllFolders() async {
    final folders = await (_database.select(_database.folders)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<List<FolderEntity>> getRootFolders() async {
    final folders = await (_database.select(_database.folders)
          ..where((tbl) => tbl.parentId.isNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<List<FolderEntity>> getSubFolders(String parentId) async {
    final folders = await (_database.select(_database.folders)
          ..where((tbl) => tbl.parentId.equals(parentId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<FolderEntity?> getFolderById(String id) async {
    final folder = await (_database.select(_database.folders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return folder != null ? _mapToEntity(folder) : null;
  }

  @override
  Future<void> addFolder(FolderEntity folder) async {
    await _database.into(_database.folders).insert(_mapToCompanion(folder));
  }

  @override
  Future<void> updateFolder(FolderEntity folder) async {
    await _database.update(_database.folders).replace(_mapToCompanion(folder));
  }

  @override
  Future<void> deleteFolder(String id) async {
    await (_database.delete(_database.folders)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> deleteFolderAndContents(String id) async {
    await (_database.delete(_database.notes)..where((tbl) => _database.notes.folderId.equals(id))).go();

    final subFolders = await getSubFolders(id);
    for (final folder in subFolders) {
      await deleteFolderAndContents(folder.id);
    }

    await deleteFolder(id);
  }

  FolderEntity _mapToEntity(Folder folder) {
    return FolderEntity(
      id: folder.id,
      name: folder.name,
      parentId: folder.parentId,
      createdAt: folder.createdAt,
    );
  }

  FoldersCompanion _mapToCompanion(FolderEntity entity) {
    return FoldersCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      parentId: Value(entity.parentId),
      createdAt: Value(entity.createdAt),
    );
  }
}
