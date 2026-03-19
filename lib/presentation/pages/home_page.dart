import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/presentation/providers/note_provider.dart';
import 'package:kpm/presentation/widgets/common/animations.dart';
import 'package:kpm/presentation/widgets/note/note_card.dart';
import 'package:kpm/domain/entities/note_entity.dart';
import 'package:uuid/uuid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinnedNotesAsync = ref.watch(pinnedNotesProvider);
    final notesAsync = ref.watch(notesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppConstants.smallPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'folders') {
                Navigator.pushNamed(context, '/folders');
              } else if (value == 'tags') {
                Navigator.pushNamed(context, '/tags');
              } else if (value == 'trash') {
                Navigator.pushNamed(context, '/trash');
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'folders',
                child: Row(
                  children: [
                    Icon(Icons.folder, size: 20),
                    SizedBox(width: 8),
                    Text(AppStrings.folders),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'tags',
                child: Row(
                  children: [
                    Icon(Icons.local_offer, size: 20),
                    SizedBox(width: 8),
                    Text(AppStrings.tags),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'trash',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 8),
                    Text(AppStrings.trash),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text(AppStrings.settings),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: AnimatedContainer(
              duration: AppConstants.shortAnimationDuration,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? AnimatedOpacity(
                          opacity: 1.0,
                          duration: AppConstants.shortAnimationDuration,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.defaultPadding,
                  ),
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(notesProvider);
                ref.invalidate(pinnedNotesProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (searchQuery.isEmpty) ...[
                        if (pinnedNotesAsync.value != null &&
                            pinnedNotesAsync.value!.isNotEmpty) ...[
                          SlideInAnimation(
                            delay: const Duration(milliseconds: 100),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppConstants.smallPadding,
                              ),
                              child: Text(
                                AppStrings.pinnedNotes,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          _buildNotesList(pinnedNotesAsync.value!, _isGridView, startDelay: 150),
                          const SizedBox(height: AppConstants.defaultPadding),
                        ],
                        SlideInAnimation(
                          delay: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.smallPadding,
                            ),
                            child: Text(
                              AppStrings.allNotes,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                      _buildNotesList(
                        searchQuery.isEmpty
                            ? (notesAsync.value ?? [])
                            : (ref.watch(searchedNotesProvider).value ?? []),
                        _isGridView,
                        startDelay: searchQuery.isEmpty ? 250 : 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: ScaleInAnimation(
          delay: const Duration(milliseconds: 300),
          child: FloatingActionButton.extended(
            onPressed: () async {
              final newNote = NoteEntity(
                id: const Uuid().v4(),
                title: '',
                content: '',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isDeleted: false,
                isPinned: false,
              );
              
              await ref.read(noteRepositoryProvider).addNote(newNote);
              
              if (mounted) {
                Navigator.pushNamed(
                  context,
                  '/editor',
                  arguments: newNote.id,
                );
              }
            },
            icon: const Icon(Icons.add),
            label: Text(AppStrings.newNote),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList(List<NoteEntity> notes, bool isGrid, {int startDelay = 0}) {
    if (notes.isEmpty) {
      return FadeInAnimation(
        delay: Duration(milliseconds: startDelay),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.largePadding),
          child: Column(
            children: [
              Icon(
                Icons.note_alt_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                AppStrings.emptyContent,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return FadeInAnimation(
            delay: Duration(milliseconds: startDelay + (index * 50)),
            child: NoteCard(note: notes[index]),
          );
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return FadeInAnimation(
          delay: Duration(milliseconds: startDelay + (index * 50)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
            child: NoteCard(note: notes[index]),
          ),
        );
      },
    );
  }
}
