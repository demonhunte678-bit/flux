import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/widgets/index.dart';
import '../l10n/app_languages.dart';
import '../l10n/localizations_extension.dart';
import 'backup_import_page.dart';
import 'package:flux/l10n/localized_string.dart';

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
              L10n.of(context)!.settingsTab,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: L10n.of(context)!.appearance,
              children: [
                SettingsSwitchTile(
                  title: L10n.of(context)!.darkMode,
                  subtitle: L10n.of(context)!.toggleDarkLight,
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
                      Text(
                        L10n.of(context)!.themeColor,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SettingsColorGrid(
                        themeState: themeState,
                        onThemeSelected: (name) {
                          ref.read(themeProvider.notifier).selectTheme(name);
                        },
                      ),
                      if (!kIsWeb && Platform.isAndroid) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        SettingsSwitchTile(
                          title: L10n.of(context)!.matchLauncherIcon,
                          subtitle: L10n.of(context)!.matchLauncherIconSubtitle,
                          value: settingsState.matchLauncherIcon,
                          onChanged: (value) {
                            ref
                                .read(settingsProvider.notifier)
                                .toggleMatchLauncherIcon(value);
                          },
                          icon: Icons.app_shortcut_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
                SettingsNavigationTile(
                  title: context.l10n.font,
                  subtitle: settingsState.selectedFont,
                  icon: Icons.font_download_outlined,
                  onTap: () => _showFontSelector(
                    context,
                    ref,
                    settingsState.selectedFont,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              context,
              title: L10n.of(context)!.displayPreferences,
              children: [
                SettingsSwitchTile(
                  title: L10n.of(context)!.showSuccessRate,
                  subtitle: L10n.of(context)!.showSuccessRateSubtitle,
                  value: settingsState.showSuccessRate,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleShowSuccessRate(value);
                  },
                  icon: Icons.percent_rounded,
                ),
                SettingsSwitchTile(
                  title: L10n.of(context)!.showStreakDays,
                  subtitle: L10n.of(context)!.showStreakDaysSubtitle,
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
              title: L10n.of(context)!.general,
              children: [
                SettingsNavigationTile(
                  title: context.l10n.language,
                  subtitle: settingsState.language == 'ar'
                      ? context.l10n.arabic
                      : context.l10n.english,
                  icon: Icons.language_outlined,
                  onTap: () => _showLanguageSelector(
                    context,
                    ref,
                    settingsState.language,
                  ),
                ),
                SettingsNavigationTile(
                  title: L10n.of(context)!.backupRestore,
                  subtitle: L10n.of(context)!.backupRestoreSubtitle,
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
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    String currentLanguage,
  ) {
    final languages = AppLanguages.supportedCodes;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang == 'ar'
                  ? context.l10n.arabic
                  : context.l10n.english),
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

  void _showFontSelector(
    BuildContext context,
    WidgetRef ref,
    String currentFont,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FontSelectorDialog(
        currentFont: currentFont,
        onFontSelected: (String fontName) {
          ref.read(settingsProvider.notifier).changeFont(fontName);
          Navigator.pop(context);
        },
      ),
    );
  }
}
