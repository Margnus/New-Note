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
import 'package:kpm/data/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'kpm.db'));
  return AppDatabase(NativeDatabase.createInBackground(file));
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final database = ref.watch(databaseProvider.future);
  throw UnimplementedError('Use noteRepositoryProviderAsync instead');
});

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final database = ref.watch(databaseProvider.future);
  throw UnimplementedError('Use folderRepositoryProviderAsync instead');
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final database = ref.watch(databaseProvider.future);
  throw UnimplementedError('Use tagRepositoryProviderAsync instead');
});

final noteRepositoryProviderAsync = FutureProvider<NoteRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return NoteRepositoryImpl(database);
});

final folderRepositoryProviderAsync = FutureProvider<FolderRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return FolderRepositoryImpl(database);
});

final tagRepositoryProviderAsync = FutureProvider<TagRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return TagRepositoryImpl(database);
});

final notesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.getAllNotes();
});

final pinnedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.getPinnedNotes();
});

final foldersProvider = FutureProvider<List<FolderEntity>>((ref) async {
  final repository = await ref.watch(folderRepositoryProviderAsync.future);
  return repository.getRootFolders();
});

final tagsProvider = FutureProvider<List<TagEntity>>((ref) async {
  final repository = await ref.watch(tagRepositoryProviderAsync.future);
  return repository.getAllTags();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.searchNotes(query);
});

final selectedFolderProvider = StateProvider<String?>((ref) => null);

final folderNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final folderId = ref.watch(selectedFolderProvider);
  if (folderId == null) return [];

  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.getNotesByFolder(folderId);
});

final deletedNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.getDeletedNotes();
});

final noteDetailProvider = FutureProvider.family<NoteEntity?, String>((ref, id) async {
  final repository = await ref.watch(noteRepositoryProviderAsync.future);
  return repository.getNoteById(id);
});
