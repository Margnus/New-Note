import '../entities/folder_entity.dart';

abstract class FolderRepository {
  Future<List<FolderEntity>> getAllFolders();
  Future<List<FolderEntity>> getRootFolders();
  Future<List<FolderEntity>> getSubFolders(String parentId);
  Future<FolderEntity?> getFolderById(String id);
  Future<void> addFolder(FolderEntity folder);
  Future<void> updateFolder(FolderEntity folder);
  Future<void> deleteFolder(String id);
  Future<void> deleteFolderAndContents(String id);
}
