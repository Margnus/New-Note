import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:kpm/presentation/providers/note_provider.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  final String noteId;

  const NoteEditorPage({
    super.key,
    required this.noteId,
  });

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  late TextEditingController _titleController;
  late QuillController _contentController;
  NoteEntity? _currentNote;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = QuillController.basic();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await ref.read(noteRepositoryProvider).getNoteById(widget.noteId);
    if (note != null && mounted) {
      setState(() {
        _currentNote = note;
        _titleController.text = note.title;
        _contentController = QuillController(
          document: Document.fromDelta(
            Delta.fromJson([
              {'insert': note.content}
            ]),
          ),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_currentNote == null) return;

    final updatedNote = _currentNote!.copyWith(
      title: _titleController.text.isEmpty ? AppStrings.emptyTitle : _titleController.text,
      content: _contentController.document.toPlainText(),
      updatedAt: DateTime.now(),
    );

    await ref.read(noteRepositoryProvider).updateNote(updatedNote);
    
    ref.invalidate(notesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(noteDetailProvider(widget.noteId));

    setState(() {
      _hasChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.noteSaved)),
      );
    }
  }

  Future<void> _deleteNote() async {
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

    if (confirmed == true && _currentNote != null) {
      await ref.read(noteRepositoryProvider).softDeleteNote(_currentNote!.id);
      
      ref.invalidate(notesProvider);
      ref.invalidate(pinnedNotesProvider);
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(AppStrings.discardChanges),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(AppStrings.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    await _saveNote();
                    if (mounted) Navigator.pop(context, true);
                  },
                  child: const Text(AppStrings.save),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(AppStrings.discard),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.editorTitle),
          elevation: 0,
          actions: [
            if (_hasChanges)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveNote,
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteNote();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text(AppStrings.deleteNote),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: InputDecoration(
                  hintText: AppStrings.untitledNote,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
                onChanged: (_) => _onChanged(),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Expanded(
                child: QuillEditor.basic(
                  controller: _contentController,
                  readOnly: false,
                  configurations: const QuillEditorConfigurations(
                    placeholder: AppStrings.emptyContent,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: QuillSimpleToolbar(
          controller: _contentController,
          configurations: const QuillSimpleToolbarConfigurations(
            showAlignmentButtons: false,
            showBackgroundColorButton: false,
            showClearFormat: false,
            showCodeBlock: false,
            showDirection: false,
            showDividers: false,
            showFontFamily: false,
            showFontSize: false,
            showHeaderStyle: false,
            showIndent: false,
            showLink: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
          ),
        ),
      ),
    );
  }
}
