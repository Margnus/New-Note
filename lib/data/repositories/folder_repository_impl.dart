import '../../data/database/app_database.dart';
import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final AppDatabase _database;

  FolderRepositoryImpl(this._database);

  @override
  Future<List<FolderEntity>> getAllFolders() async {
    final folders = await _database.foldersDao.getAllFolders();
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<List<FolderEntity>> getRootFolders() async {
    final folders = await _database.foldersDao.getRootFolders();
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<List<FolderEntity>> getSubFolders(String parentId) async {
    final folders = await _database.foldersDao.getSubFolders(parentId);
    return folders.map(_mapToEntity).toList();
  }

  @override
  Future<FolderEntity?> getFolderById(String id) async {
    final folder = await _database.foldersDao.getFolderById(id);
    return folder != null ? _mapToEntity(folder) : null;
  }

  @override
  Future<void> addFolder(FolderEntity folder) async {
    await _database.foldersDao.insertFolder(_mapToCompanion(folder));
  }

  @override
  Future<void> updateFolder(FolderEntity folder) async {
    await _database.foldersDao.updateFolder(_mapToCompanion(folder));
  }

  @override
  Future<void> deleteFolder(String id) async {
    await _database.foldersDao.deleteFolder(id);
  }

  @override
  Future<void> deleteFolderAndContents(String id) async {
    await _database.foldersDao.deleteFolderAndContents(id);
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
