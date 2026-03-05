import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';

class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedNotesAsync = ref.watch(deletedNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.trash),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showEmptyTrashDialog(context, ref),
            tooltip: AppStrings.emptyTrash,
          ),
        ],
      ),
      body: deletedNotesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    AppStrings.trashEmpty,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return _TrashNoteCard(note: notes[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _showEmptyTrashDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.emptyTrash),
        content: const Text('确定要清空回收站吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(noteRepositoryProvider).emptyTrash();
      ref.invalidate(deletedNotesProvider);
    }
  }
}

class _TrashNoteCard extends ConsumerWidget {
  final NoteEntity note;

  const _TrashNoteCard({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        title: Text(
          note.title.isEmpty ? AppStrings.emptyTitle : note.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          note.content.isEmpty
              ? AppStrings.emptyContent
              : note.content.substring(0, 100),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              onPressed: () async {
                await ref.read(noteRepositoryProvider).restoreNote(note.id);
                ref.invalidate(deletedNotesProvider);
                ref.invalidate(notesProvider);
              },
              tooltip: AppStrings.restoreNote,
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(AppStrings.deleteForever),
                    content: const Text(AppStrings.confirmDeleteMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(AppStrings.delete),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(noteRepositoryProvider).deleteNote(note.id);
                  ref.invalidate(deletedNotesProvider);
                }
              },
              tooltip: AppStrings.deleteForever,
            ),
          ],
        ),
      ),
    );
  }
}
