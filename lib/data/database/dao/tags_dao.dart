import 'package:drift/drift.dart';
import '../app_database.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [Tags, NoteTags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<Tag>> getAllTags() async {
    return (select(tags)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<Tag?> getTagById(String id) async {
    return (select(tags)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Tag>> getTagsByNoteId(String noteId) async {
    final query = select(tags).join([
      innerJoin(noteTags, noteTags.tagId.equalsExp(tags.id)),
    ])
      ..where(noteTags.noteId.equals(noteId))
      ..orderBy([OrderingTerm.asc(tags.name)]);

    return query.map((row) => row.readTable(tags)).get();
  }

  Future<int> insertTag(TagsCompanion tag) async {
    return into(tags).insert(tag);
  }

  Future<bool> updateTag(TagsCompanion tag) async {
    return update(tags).replace(tag);
  }

  Future<int> deleteTag(String id) async {
    await (delete(noteTags)..where((tbl) => tbl.tagId.equals(id))).go();
    return (delete(tags)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> addTagToNote(String noteId, String tagId) async {
    await into(noteTags).insert(NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
    ));
  }

  Future<void> removeTagFromNote(String noteId, String tagId) async {
    await (delete(noteTags)
          ..where((tbl) =>
              tbl.noteId.equals(noteId) & tbl.tagId.equals(tagId)))
        .go();
  }

  Future<void> setNoteTags(String noteId, List<String> tagIds) async {
    await (delete(noteTags)..where((tbl) => tbl.noteId.equals(noteId))).go();

    for (final tagId in tagIds) {
      await addTagToNote(noteId, tagId);
    }
  }

  Future<bool> tagExists(String name) async {
    final result = await (select(tags)
          ..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
    return result != null;
  }
}
