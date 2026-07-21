import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flux/index.dart';

class SettingsService {
  static const String SELECTED_THEME_KEY = 'selected_theme';
  static const String LANGUAGE_KEY = 'language';
  static const String SHOW_SUCCESS_RATE_KEY = 'show_success_rate';
  static const String SHOW_CURRENT_STREAK_KEY = 'show_current_streak';

  // In-memory cache to speed up reads and avoid frequent IO
  static Map<String, dynamic>? _cachedSettings;

  static Future<Map<String, dynamic>> _getSettings() async {
    if (_cachedSettings != null) return _cachedSettings!;
    _cachedSettings = await StorageService.loadSettings();
    return _cachedSettings!;
  }

  static Future<void> _saveSetting(String key, dynamic value) async {
    final settings = await _getSettings();
    settings[key] = value;
    _cachedSettings = settings;
    await StorageService.saveSettings(settings);
  }

  // Theme settings
  static Future<bool> isDarkMode() async {
    final settings = await _getSettings();
    if (settings['dark_mode'] == null) {
      return ui.PlatformDispatcher.instance.platformBrightness == ui.Brightness.dark;
    }
    return settings['dark_mode'] ?? false;
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    await _saveSetting('dark_mode', isDarkMode);
  }

  static Future<String> getSelectedTheme() async {
    final settings = await _getSettings();
    return settings[SELECTED_THEME_KEY] ?? 'Emerald';
  }

  static Future<void> setSelectedTheme(String themeKey) async {
    await _saveSetting(SELECTED_THEME_KEY, themeKey);
  }

  // Display settings
  static Future<bool> getShowSuccessRate() async {
    final settings = await _getSettings();
    return settings[SHOW_SUCCESS_RATE_KEY] ?? true;
  }

  static Future<void> setShowSuccessRate(bool show) async {
    await _saveSetting(SHOW_SUCCESS_RATE_KEY, show);
  }

  static Future<bool> getShowCurrentStreak() async {
    final settings = await _getSettings();
    return settings[SHOW_CURRENT_STREAK_KEY] ?? true;
  }

  static Future<void> setShowCurrentStreak(bool show) async {
    await _saveSetting(SHOW_CURRENT_STREAK_KEY, show);
  }

  // Language settings
  static Future<String> getLanguage() async {
    final settings = await _getSettings();
    return settings[LANGUAGE_KEY] ?? 'English';
  }

  static Future<void> setLanguage(String language) async {
    await _saveSetting(LANGUAGE_KEY, language);
  }

  // Launcher icon preference
  static const String MATCH_LAUNCHER_ICON_KEY = 'match_launcher_icon';

  static Future<bool> getMatchLauncherIcon() async {
    final settings = await _getSettings();
    final defaultMatch = (!kIsWeb && Platform.isAndroid);
    return settings[MATCH_LAUNCHER_ICON_KEY] ?? defaultMatch;
  }

  static Future<void> setMatchLauncherIcon(bool match) async {
    await _saveSetting(MATCH_LAUNCHER_ICON_KEY, match);
  }

  // Weekend Definition settings
  static const String WEEKEND_DAYS_KEY = 'weekend_days';

  static Future<String> getWeekendDays() async {
    final settings = await _getSettings();
    return settings[WEEKEND_DAYS_KEY] ?? 'Saturday & Sunday';
  }

  static Future<void> setWeekendDays(String days) async {
    await _saveSetting(WEEKEND_DAYS_KEY, days);
  }

  // Fallbacks for display settings referenced elsewhere in the app
  static Future<bool> getShowHabitIcons() async => true;
  static Future<bool> getCompactMode() async => false;
  static Future<HabitType> getDefaultHabitType() async =>
      HabitType.SuccessBased;
}
