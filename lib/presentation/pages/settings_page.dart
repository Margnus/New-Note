import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpm/core/constants/app_strings.dart';
import 'package:kpm/core/constants/app_constants.dart';
import 'package:kpm/presentation/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _Section(title: AppStrings.appearance, children: [
            _ThemeTile(
              themeMode: themeMode,
              onChanged: (mode) {
                ref.read(themeModeProvider.notifier).state = mode;
              },
            ),
          ]),
          _Section(title: AppStrings.about, children: [
            ListTile(
              title: const Text(AppStrings.version),
              subtitle: Text(AppConstants.appVersion),
              leading: const Icon(Icons.info_outline),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.defaultPadding,
            AppConstants.defaultPadding,
            AppConstants.defaultPadding,
            AppConstants.smallPadding,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeTile({required this.themeMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('跟随系统'),
          subtitle: const Text('自动切换亮色和暗色模式'),
          value: ThemeMode.system,
          groupValue: themeMode,
          onChanged: (value) => onChanged(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Row(
            children: [
              Icon(Icons.light_mode, size: 20),
              SizedBox(width: 8),
              Text('亮色模式'),
            ],
          ),
          value: ThemeMode.light,
          groupValue: themeMode,
          onChanged: (value) => onChanged(value!),
        ),
        RadioListTile<ThemeMode>(
          title: const Row(
            children: [
              Icon(Icons.dark_mode, size: 20),
              SizedBox(width: 8),
              Text('暗色模式'),
            ],
          ),
          value: ThemeMode.dark,
          groupValue: themeMode,
          onChanged: (value) => onChanged(value!),
        ),
      ],
    );
  }
}
