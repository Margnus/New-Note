import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/theme/app_theme.dart';
import 'package:kpm/presentation/pages/folders_page.dart';
import 'package:kpm/presentation/pages/home_page.dart';
import 'package:kpm/presentation/pages/note_editor_page.dart';
import 'package:kpm/presentation/pages/settings_page.dart';
import 'package:kpm/presentation/pages/tags_page.dart';
import 'package:kpm/presentation/pages/tag_notes_page.dart';
import 'package:kpm/presentation/pages/trash_page.dart';
import 'package:kpm/presentation/providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'KPM',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/editor': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return NoteEditorPage(noteId: args ?? '');
        },
        '/folders': (context) => const FoldersPage(),
        '/tags': (context) => const TagsPage(),
        '/tag_notes': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return TagNotesPage(tagId: args ?? '');
        },
        '/trash': (context) => const TrashPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
