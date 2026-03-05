import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/domain/entities/folder_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';
import 'package:uuid/uuid.dart';

class FoldersPage extends ConsumerStatefulWidget {
  const FoldersPage({super.key});

  @override
  ConsumerState<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends ConsumerState<FoldersPage> {
  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(foldersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.folders),
        elevation: 0,
      ),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    '暂无文件夹',
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
            itemCount: folders.length,
            itemBuilder: (context, index) {
              return _FolderCard(folder: folders[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateFolderDialog(),
        icon: const Icon(Icons.add),
        label: Text(AppStrings.newFolder),
      ),
    );
  }

  Future<void> _showCreateFolderDialog() async {
    final controller = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.newFolder),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: AppStrings.folderName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().isNotEmpty) {
      final newFolder = FolderEntity(
        id: const Uuid().v4(),
        name: controller.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(folderRepositoryProvider).addFolder(newFolder);
      ref.invalidate(foldersProvider);
    }

    controller.dispose();
  }
}

class _FolderCard extends ConsumerWidget {
  final FolderEntity folder;

  const _FolderCard({required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(folder.name),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            ref.read(selectedFolderProvider.notifier).state = folder.id;
            Navigator.pop(context);
          },
        ),
        onTap: () {
          ref.read(selectedFolderProvider.notifier).state = folder.id;
          Navigator.pop(context);
        },
      ),
    );
  }
}
