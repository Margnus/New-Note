import '../../data/database/app_database.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _database;

  TagRepositoryImpl(this._database);

  @override
  Future<List<TagEntity>> getAllTags() async {
    final tags = await _database.tagsDao.getAllTags();
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<TagEntity?> getTagById(String id) async {
    final tag = await _database.tagsDao.getTagById(id);
    return tag != null ? _mapToEntity(tag) : null;
  }

  @override
  Future<List<TagEntity>> getTagsByNoteId(String noteId) async {
    final tags = await _database.tagsDao.getTagsByNoteId(noteId);
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<void> addTag(TagEntity tag) async {
    await _database.tagsDao.insertTag(_mapToCompanion(tag));
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    await _database.tagsDao.updateTag(_mapToCompanion(tag));
  }

  @override
  Future<void> deleteTag(String id) async {
    await _database.tagsDao.deleteTag(id);
  }

  @override
  Future<void> addTagToNote(String noteId, String tagId) async {
    await _database.tagsDao.addTagToNote(noteId, tagId);
  }

  @override
  Future<void> removeTagFromNote(String noteId, String tagId) async {
    await _database.tagsDao.removeTagFromNote(noteId, tagId);
  }

  @override
  Future<void> setNoteTags(String noteId, List<String> tagIds) async {
    await _database.tagsDao.setNoteTags(noteId, tagIds);
  }

  @override
  Future<bool> tagExists(String name) async {
    return await _database.tagsDao.tagExists(name);
  }

  TagEntity _mapToEntity(Tag tag) {
    return TagEntity(
      id: tag.id,
      name: tag.name,
      color: tag.color,
    );
  }

  TagsCompanion _mapToCompanion(TagEntity entity) {
    return TagsCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      color: Value(entity.color),
    );
  }
}
