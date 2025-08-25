import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () {
        ref.read(themeServiceProvider.notifier).toggleTheme();
      },
      tooltip: isDarkMode ? 'Açık temaya geç' : 'Koyu temaya geç',
    );
  }
}

class ThemeSwitchListTile extends ConsumerWidget {
  const ThemeSwitchListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return SwitchListTile(
      title: const Text('Koyu Tema'),
      subtitle: Text(isDarkMode ? 'Açık' : 'Kapalı'),
      value: isDarkMode,
      onChanged: (value) {
        ref.read(themeServiceProvider.notifier).setTheme(
              value ? ThemeMode.dark : ThemeMode.light,
            );
      },
      secondary: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
      ),
    );
  }
}