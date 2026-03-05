import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_colors.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/domain/entities/tag_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';
import 'package:uuid/uuid.dart';

class TagsPage extends ConsumerStatefulWidget {
  const TagsPage({super.key});

  @override
  ConsumerState<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends ConsumerState<TagsPage> {
  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tags),
        elevation: 0,
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    '暂无标签',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: AppConstants.defaultPadding,
              mainAxisSpacing: AppConstants.defaultPadding,
            ),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              return _TagCard(tag: tags[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTagDialog(),
        icon: const Icon(Icons.add),
        label: Text(AppStrings.newTag),
      ),
    );
  }

  Future<void> _showCreateTagDialog() async {
    final nameController = TextEditingController();
    int selectedColorIndex = 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(AppStrings.newTag),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.tagName,
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(AppStrings.tagColor),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Wrap(
                spacing: AppConstants.smallPadding,
                runSpacing: AppConstants.smallPadding,
                children: List.generate(
                  AppColors.tagColors.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.tagColors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColorIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && nameController.text.trim().isNotEmpty) {
      final colorValue = AppColors.tagColors[selectedColorIndex].value.toString();
      
      final newTag = TagEntity(
        id: const Uuid().v4(),
        name: nameController.text.trim(),
        color: colorValue,
      );

      await ref.read(tagRepositoryProvider).addTag(newTag);
      ref.invalidate(tagsProvider);
    }

    nameController.dispose();
  }
}

class _TagCard extends ConsumerWidget {
  final TagEntity tag;

  const _TagCard({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/tag_notes',
            arguments: tag.id,
          );
        },
        onLongPress: () => _showOptions(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(int.parse(tag.color)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Text(
                  tag.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(AppStrings.deleteTag),
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
                    await ref.read(tagRepositoryProvider).deleteTag(tag.id);
                    ref.invalidate(tagsProvider);
                  }
                },
                tooltip: AppStrings.deleteTag,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(AppStrings.editTag),
              onTap: () async {
                Navigator.pop(context);
                await _showEditTagDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text(AppStrings.deleteTag),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(AppStrings.deleteTag),
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
                  await ref.read(tagRepositoryProvider).deleteTag(tag.id);
                  ref.invalidate(tagsProvider);
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppConstants.smallPadding),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditTagDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController(text: tag.name);
    int selectedColorIndex = AppColors.tagColors.indexWhere(
      (color) => color.value.toString() == tag.color,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(AppStrings.editTag),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.tagName,
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(AppStrings.tagColor),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Wrap(
                spacing: AppConstants.smallPadding,
                runSpacing: AppConstants.smallPadding,
                children: List.generate(
                  AppColors.tagColors.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.tagColors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColorIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && nameController.text.trim().isNotEmpty) {
      final colorValue = AppColors.tagColors[selectedColorIndex].value.toString();
      
      final updatedTag = tag.copyWith(
        name: nameController.text.trim(),
        color: colorValue,
      );

      await ref.read(tagRepositoryProvider).updateTag(updatedTag);
      ref.invalidate(tagsProvider);
    }

    nameController.dispose();
  }
}
