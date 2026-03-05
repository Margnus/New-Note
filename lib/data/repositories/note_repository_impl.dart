import '../../data/database/app_database.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final AppDatabase _database;

  NoteRepositoryImpl(this._database);

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final notes = await _database.notesDao.getAllNotes();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getPinnedNotes() async {
    final notes = await _database.notesDao.getPinnedNotes();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getNotesByFolder(String folderId) async {
    final notes = await _database.notesDao.getNotesByFolder(folderId);
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getNotesByTag(String tagId) async {
    final notes = await _database.notesDao.getNotesByTag(tagId);
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    final notes = await _database.notesDao.searchNotes(query);
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getDeletedNotes() async {
    final notes = await _database.notesDao.getDeletedNotes();
    return notes.map(_mapToEntity).toList();
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    final note = await _database.notesDao.getNoteById(id);
    return note != null ? _mapToEntity(note) : null;
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await _database.notesDao.insertNote(_mapToCompanion(note));
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await _database.notesDao.updateNote(_mapToCompanion(note));
  }

  @override
  Future<void> deleteNote(String id) async {
    await _database.notesDao.deleteNote(id);
  }

  @override
  Future<void> softDeleteNote(String id) async {
    await _database.notesDao.softDeleteNote(id);
  }

  @override
  Future<void> restoreNote(String id) async {
    await _database.notesDao.restoreNote(id);
  }

  @override
  Future<void> togglePinNote(String id) async {
    await _database.notesDao.togglePinNote(id);
  }

  @override
  Future<void> emptyTrash() async {
    await _database.notesDao.emptyTrash();
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
