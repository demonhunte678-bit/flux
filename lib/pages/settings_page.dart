import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class SettingsPage extends ConsumerWidget {
  final bool wrapWithScaffold;
  const SettingsPage({super.key, this.wrapWithScaffold = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final themeState = ref.watch(themeProvider);

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: 'Appearance',
              children: [
                _buildSwitchTile(
                  context,
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark or light theme',
                  value: themeState.isDarkMode,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleDarkMode(value);
                  },
                  icon: themeState.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Theme Color',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildColorGrid(ref, themeState),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: 'Display Preferences',
              children: [
                _buildSwitchTile(
                  context,
                  title: 'Show Success Rate',
                  subtitle: 'Show percentage rates in the app',
                  value: settingsState.showSuccessRate,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleShowSuccessRate(value);
                  },
                  icon: Icons.percent_rounded,
                ),
                _buildSwitchTile(
                  context,
                  title: 'Show Streak Days',
                  subtitle: 'Show daily streaks in the app',
                  value: settingsState.showCurrentStreak,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleShowCurrentStreak(value);
                  },
                  icon: Icons.local_fire_department_outlined,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: 'General',
              children: [
                _buildNavigationTile(
                  context,
                  title: 'Language',
                  subtitle: settingsState.language,
                  icon: Icons.language_outlined,
                  onTap: () => _showLanguageSelector(
                    context,
                    ref,
                    settingsState.language,
                  ),
                ),
                _buildNavigationTile(
                  context,
                  title: 'Backup & Restore',
                  subtitle: 'Export or import your habit database',
                  icon: Icons.backup_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BackupImportPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (wrapWithScaffold) {
      return Scaffold(body: content);
    }
    return content;
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isLast = index == children.length - 1;
              return Column(
                children: [
                  child,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
        activeThumbColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildColorGrid(WidgetRef ref, ThemeState themeState) {
    final colors = ThemeService.accentColors;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = colors[index];
          final color = item.color;
          final name = item.colorName;
          final isSelected =
              themeState.themeName.toLowerCase() == name.toLowerCase();

          return GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).selectTheme(name);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (themeState.isDarkMode ? Colors.white : Colors.black87)
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: _isDarkColor(color)
                          ? Colors.white
                          : Colors.black87,
                      size: 16,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  bool _isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    String currentLanguage,
  ) {
    final languages = ['English', 'Arabic'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: currentLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).changeLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
