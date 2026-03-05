import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_colors.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:kpm/domain/entities/tag_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';
import 'package:kpm/presentation/widgets/note/note_card.dart';

class TagNotesPage extends ConsumerStatefulWidget {
  final String tagId;

  const TagNotesPage({
    super.key,
    required this.tagId,
  });

  @override
  ConsumerState<TagNotesPage> createState() => _TagNotesPageState();
}

class _TagNotesPageState extends ConsumerState<TagNotesPage> {
  TagEntity? _tag;

  @override
  void initState() {
    super.initState();
    _loadTag();
  }

  Future<void> _loadTag() async {
    final tag = await ref.read(tagRepositoryProvider).getTagById(widget.tagId);
    if (mounted) {
      setState(() {
        _tag = tag;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(
      noteDetailProvider(widget.tagId),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _tag != null
            ? Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(int.parse(_tag!.color)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(_tag!.name),
                ],
              )
            : const Text(AppStrings.tags),
      ),
      body: notesAsync.when(
        data: (note) {
          final tagNotesAsync = ref.watch(
            noteDetailProvider(widget.tagId),
          );
          
          return FutureBuilder<List<NoteEntity>>(
            future: ref.read(noteRepositoryProvider).getNotesByTag(widget.tagId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final notes = snapshot.data ?? [];

              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        '该标签下暂无笔记',
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                    child: NoteCard(note: notes[index]),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
