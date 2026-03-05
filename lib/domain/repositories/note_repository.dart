import '../entities/note_entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getAllNotes();
  Future<List<NoteEntity>> getPinnedNotes();
  Future<List<NoteEntity>> getNotesByFolder(String folderId);
  Future<List<NoteEntity>> getNotesByTag(String tagId);
  Future<List<NoteEntity>> searchNotes(String query);
  Future<List<NoteEntity>> getDeletedNotes();
  Future<NoteEntity?> getNoteById(String id);
  Future<void> addNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String id);
  Future<void> softDeleteNote(String id);
  Future<void> restoreNote(String id);
  Future<void> togglePinNote(String id);
  Future<void> emptyTrash();
}
