import '../../data/database/app_database.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import 'package:drift/drift.dart';

class NoteRepositoryImpl implements NoteRepository {
  final AppDatabase _database;

  NoteRepositoryImpl(this._database);

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final notes = await (_database.select(_database.notes)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getPinnedNotes() async {
    final notes = await (_database.select(_database.notes)
          ..where((tbl) => tbl.isPinned.equals(true) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getNotesByFolder(String folderId) async {
    final notes = await (_database.select(_database.notes)
          ..where((tbl) =>
              tbl.folderId.equals(folderId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getNotesByTag(String tagId) async {
    final notes = await (_database.select(_database.notes)
          ..where((tbl) => _database.noteTags.noteId.equals(tagId) & tbl.isDeleted.equals(false)))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    final searchQuery = '%$query%';
    final notes = await (_database.select(_database.notes)
          ..where((tbl) =>
              tbl.title.like(searchQuery) |
              tbl.content.like(searchQuery) &
                  tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getDeletedNotes() async {
    final notes = await (_database.select(_database.notes)
          ..where((tbl) => tbl.isDeleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.deletedAt)]))
        .get();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    final note = await (_database.select(_database.notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return note != null ? _mapToEntity(note) : null;
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await _database.into(_database.notes).insert(_mapToCompanion(note));
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await _database.update(_database.notes).replace(_mapToCompanion(note));
  }

  @override
  Future<void> deleteNote(String id) async {
    await (_database.delete(_database.notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> softDeleteNote(String id) async {
    await (_database.update(_database.notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(NotesCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(DateTime.now()),
          )));
  }

  @override
  Future<void> restoreNote(String id) async {
    await (_database.update(_database.notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(const NotesCompanion(
            isDeleted: Value(false),
            deletedAt: Value(null),
          )));
  }

  @override
  Future<void> togglePinNote(String id) async {
    final note = await getNoteById(id);
    if (note == null) return;

    await (_database.update(_database.notes)
          ..where((tbl) => tbl.id.equals(id))
          ..write(NotesCompanion(
            isPinned: Value(!note.isPinned),
          )));
  }

  @override
  Future<void> emptyTrash() async {
    await (_database.delete(_database.notes)..where((tbl) => tbl.isDeleted.equals(true))).go();
  }

  NoteEntity _mapToEntity(Note note) {
    return NoteEntity(
      id: note.id,
      title: note.title,
      content: note.content,
      folderId: note.folderId,
      isPinned: note.isPinned,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isDeleted: note.isDeleted,
      deletedAt: note.deletedAt,
    );
  }

  NotesCompanion _mapToCompanion(NoteEntity entity) {
    return NotesCompanion(
      id: Value(entity.id),
      title: Value(entity.title),
      content: Value(entity.content),
      folderId: Value(entity.folderId),
      isPinned: Value(entity.isPinned),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      isDeleted: Value(entity.isDeleted),
      deletedAt: Value(entity.deletedAt),
    );
  }
}
