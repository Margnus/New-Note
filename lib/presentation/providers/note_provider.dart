import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/data/repositories/note_repository_impl.dart';
import 'package:kpm/data/repositories/folder_repository_impl.dart';
import 'package:kpm/data/repositories/tag_repository_impl.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:kpm/domain/entities/folder_entity.dart';
import 'package:kpm/domain/entities/tag_entity.dart';
import 'package:kpm/domain/repositories/note_repository.dart';
import 'package:kpm/domain/repositories/folder_repository.dart';
import 'package:kpm/domain/repositories/tag_repository.dart';
import 'package:kpm/data/database/app_database_class.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return NoteRepositoryImpl(database);
});

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return FolderRepositoryImpl(database);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TagRepositoryImpl(database);
});

final notesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getAllNotes();
});

final pinnedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getPinnedNotes();
});

final foldersProvider = FutureProvider<List<FolderEntity>>((ref) async {
  final repository = ref.watch(folderRepositoryProvider);
  return repository.getRootFolders();
});

final tagsProvider = FutureProvider<List<TagEntity>>((ref) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getAllTags();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repository = ref.watch(noteRepositoryProvider);
  return repository.searchNotes(query);
});

final selectedFolderProvider = StateProvider<String?>((ref) => null);

final folderNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final folderId = ref.watch(selectedFolderProvider);
  if (folderId == null) return [];

  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNotesByFolder(folderId);
});

final deletedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getDeletedNotes();
});

final noteDetailProvider = FutureProvider.family<NoteEntity?, String>((ref, id) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNoteById(id);
});
