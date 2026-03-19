import 'package:drift/drift.dart';
import '../app_database.dart';

part 'notes_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  Future<List<Note>> getAllNotes() async {
    return (select(notes)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  Future<List<Note>> getPinnedNotes() async {
    return (select(notes)
          ..where((tbl) => tbl.isPinned.equals(true) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  Future<List<Note>> getNotesByFolder(String folderId) async {
    return (select(notes)
          ..where((tbl) =>
              tbl.folderId.equals(folderId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  Future<List<Note>> getNotesByTag(String tagId) async {
    final query = select(notes).join([
      innerJoin(db.noteTags, db.noteTags.noteId.equalsExp(notes.id)),
    ])
      ..where(db.noteTags.tagId.equals(tagId) & notes.isDeleted.equals(false))
      ..orderBy([OrderingTerm.desc(notes.updatedAt)]);

    return query.map((row) => row.readTable(notes)).get();
  }

  Future<List<Note>> searchNotes(String query) async {
    final searchQuery = '%$query%';
    return (select(notes)
          ..where((tbl) =>
              tbl.title.like(searchQuery) |
              tbl.content.like(searchQuery) &
                  tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  Future<List<Note>> getDeletedNotes() async {
    return (select(notes)
          ..where((tbl) => tbl.isDeleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.deletedAt)]))
        .get();
  }

  Future<Note?> getNoteById(String id) async {
    return (select(notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertNote(NotesCompanion note) async {
    return into(notes).insert(note);
  }

  Future<bool> updateNote(NotesCompanion note) async {
    return update(notes).replace(note);
  }

  Future<int> deleteNote(String id) async {
    return (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> softDeleteNote(String id) async {
    (update(notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(NotesCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(DateTime.now()),
          )));
  }

  Future<void> restoreNote(String id) async {
    (update(notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(const NotesCompanion(
            isDeleted: Value(false),
            deletedAt: const Value(null),
          )));
  }

  Future<void> togglePinNote(String id) async {
    final note = await getNoteById(id);
    if (note == null) return;

    (update(notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(NotesCompanion(
            isPinned: Value(!note.isPinned),
          )));
  }

  Future<int> emptyTrash() async {
    return (delete(notes)..where((tbl) => tbl.isDeleted.equals(true))).go();
  }
}
