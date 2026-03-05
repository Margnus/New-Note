import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_colors.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';
import 'package:intl/intl.dart';

class NoteCard extends ConsumerWidget {
  final NoteEntity note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      curve: Curves.easeInOut,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/editor',
              arguments: note.id,
            );
          },
          onLongPress: () => _showOptions(context, ref),
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              gradient: note.isPinned
                  ? LinearGradient(
                      colors: [
                        AppColors.lightPrimary.withOpacity(0.05),
                        AppColors.lightPrimaryDark.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title.isEmpty ? AppStrings.emptyTitle : note.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (note.isPinned)
                        AnimatedContainer(
                          duration: AppConstants.shortAnimationDuration,
                          child: const Icon(
                            Icons.push_pin,
                            size: 16,
                            color: AppColors.lightPrimary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    note.content.isEmpty
                        ? AppStrings.emptyContent
                        : note.content.substring(0, 100),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          height: 1.5,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MM/dd HH:mm').format(note.updatedAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? AppStrings.unpinNote : AppStrings.pinNote),
              onTap: () async {
                await ref.read(noteRepositoryProvider).togglePinNote(note.id);
                ref.invalidate(notesProvider);
                ref.invalidate(pinnedNotesProvider);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text(AppStrings.deleteNote),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(AppStrings.confirmDelete),
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

                if (confirmed == true && context.mounted) {
                  await ref.read(noteRepositoryProvider).softDeleteNote(note.id);
                  ref.invalidate(notesProvider);
                  ref.invalidate(pinnedNotesProvider);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: AppConstants.smallPadding),
          ],
        ),
      ),
    );
  }
}
