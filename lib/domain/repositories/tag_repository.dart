import '../entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> getAllTags();
  Future<TagEntity?> getTagById(String id);
  Future<List<TagEntity>> getTagsByNoteId(String noteId);
  Future<void> addTag(TagEntity tag);
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(String id);
  Future<void> addTagToNote(String noteId, String tagId);
  Future<void> removeTagFromNote(String noteId, String tagId);
  Future<void> setNoteTags(String noteId, List<String> tagIds);
  Future<bool> tagExists(String name);
}
