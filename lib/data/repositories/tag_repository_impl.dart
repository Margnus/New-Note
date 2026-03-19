import '../../data/database/app_database.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';
import 'package:drift/drift.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _database;

  TagRepositoryImpl(this._database);

  @override
  Future<List<TagEntity>> getAllTags() async {
    final tags = await (_database.select(_database.tags)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<TagEntity?> getTagById(String id) async {
    final tag = await (_database.select(_database.tags)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return tag != null ? _mapToEntity(tag) : null;
  }

  @override
  Future<List<TagEntity>> getTagsByNoteId(String noteId) async {
    final tags = await (_database.select(_database.tags)
          ..where((tbl) => _database.noteTags.noteId.equals(noteId)))
        .get();
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<void> addTag(TagEntity tag) async {
    await _database.into(_database.tags).insert(_mapToCompanion(tag));
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    await _database.update(_database.tags).replace(_mapToCompanion(tag));
  }

  @override
  Future<void> deleteTag(String id) async {
    await (_database.delete(_database.noteTags)..where((tbl) => tbl.tagId.equals(id))).go();
    await (_database.delete(_database.tags)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> addTagToNote(String noteId, String tagId) async {
    await _database.into(_database.noteTags).insert(NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
    ));
  }

  @override
  Future<void> removeTagFromNote(String noteId, String tagId) async {
    await (_database.delete(_database.noteTags)
          ..where((tbl) => tbl.noteId.equals(noteId) & tbl.tagId.equals(tagId)))
        .go();
  }

  @override
  Future<void> setNoteTags(String noteId, List<String> tagIds) async {
    await (_database.delete(_database.noteTags)..where((tbl) => tbl.noteId.equals(noteId))).go();

    for (final tagId in tagIds) {
      await addTagToNote(noteId, tagId);
    }
  }

  @override
  Future<bool> tagExists(String name) async {
    final result = await (_database.select(_database.tags)
          ..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
    return result != null;
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
