import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flux/index.dart';

class SettingsService {
  static const String SELECTED_THEME_KEY = 'selected_theme';
  static const String LANGUAGE_KEY = 'language';
  static const String SHOW_SUCCESS_RATE_KEY = 'show_success_rate';
  static const String SHOW_CURRENT_STREAK_KEY = 'show_current_streak';
  static const String MATCH_LAUNCHER_ICON_KEY = 'match_launcher_icon';
  static const String WEEKEND_DAYS_KEY = 'weekend_days';

  static Map<String, dynamic>? _cache;

  static Future<Map<String, dynamic>> _getPrefs() async {
    if (_cache != null) return _cache!;
    try {
      final file = await PathService.getSharedPrefsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        _cache = jsonDecode(content) as Map<String, dynamic>;
        return _cache!;
      }
    } catch (e) {
      print('Error loading shared prefs: $e');
    }
    _cache = {};
    return _cache!;
  }

  static Future<void> reloadSettings() async {
    _cache = null;
    await _getPrefs();
  }

  static Future<void> _savePrefs() async {

    if (_cache == null) return;
    try {
      final file = await PathService.getSharedPrefsFile();
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsString(jsonEncode(_cache));
    } catch (e) {
      print('Error saving shared prefs: $e');
    }
  }

  static Future<T?> _getValue<T>(String key) async {
    final prefs = await _getPrefs();
    return prefs[key] as T?;
  }

  static Future<void> _setValue(String key, dynamic value) async {
    final prefs = await _getPrefs();
    prefs[key] = value;
    await _savePrefs();
  }

  // Theme settings
  static Future<bool> isDarkMode() async {
    final prefs = await _getPrefs();
    if (!prefs.containsKey('dark_mode')) {
      return ui.PlatformDispatcher.instance.platformBrightness == ui.Brightness.dark;
    }
    return prefs['dark_mode'] as bool? ?? false;
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    await _setValue('dark_mode', isDarkMode);
  }

  static Future<String> getSelectedTheme() async {
    return (await _getValue<String>(SELECTED_THEME_KEY)) ?? 'Emerald';
  }

  static Future<void> setSelectedTheme(String themeKey) async {
    await _setValue(SELECTED_THEME_KEY, themeKey);
  }

  // Display settings
  static Future<bool> getShowSuccessRate() async {
    return (await _getValue<bool>(SHOW_SUCCESS_RATE_KEY)) ?? true;
  }

  static Future<void> setShowSuccessRate(bool show) async {
    await _setValue(SHOW_SUCCESS_RATE_KEY, show);
  }

  static Future<bool> getShowCurrentStreak() async {
    return (await _getValue<bool>(SHOW_CURRENT_STREAK_KEY)) ?? true;
  }

  static Future<void> setShowCurrentStreak(bool show) async {
    await _setValue(SHOW_CURRENT_STREAK_KEY, show);
  }

  // Language settings
  static Future<String> getLanguage() async {
    return (await _getValue<String>(LANGUAGE_KEY)) ?? 'English';
  }

  static Future<void> setLanguage(String language) async {
    await _setValue(LANGUAGE_KEY, language);
  }

  // Launcher icon preference
  static Future<bool> getMatchLauncherIcon() async {
    final defaultMatch = (!kIsWeb && Platform.isAndroid);
    return (await _getValue<bool>(MATCH_LAUNCHER_ICON_KEY)) ?? defaultMatch;
  }

  static Future<void> setMatchLauncherIcon(bool match) async {
    await _setValue(MATCH_LAUNCHER_ICON_KEY, match);
  }

  // Weekend Definition settings
  static Future<String> getWeekendDays() async {
    return (await _getValue<String>(WEEKEND_DAYS_KEY)) ?? 'Saturday & Sunday';
  }

  static Future<void> setWeekendDays(String days) async {
    await _setValue(WEEKEND_DAYS_KEY, days);
  }

  static Future<String> getUserName() async {
    return (await _getValue<String>('user_name')) ?? '';
  }

  static Future<void> setUserName(String name) async {
    await _setValue('user_name', name);
  }

  static Future<String> getOccupation() async {
    return (await _getValue<String>('occupation')) ?? '';
  }

  static Future<void> setOccupation(String value) async {
    await _setValue('occupation', value);
  }

  static Future<String> getBiggestObstacle() async {
    return (await _getValue<String>('biggest_obstacle')) ?? '';
  }

  static Future<void> setBiggestObstacle(String value) async {
    await _setValue('biggest_obstacle', value);
  }

  // App launch & onboarding status
  static Future<bool> isFirstLaunch() async {
    return (await _getValue<bool>('first_launch')) ?? true;
  }

  static Future<void> setFirstLaunch(bool isFirst) async {
    await _setValue('first_launch', isFirst);
  }

  static Future<bool> isOnboardingCompleted() async {
    return (await _getValue<bool>('onboarding_completed')) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _setValue('onboarding_completed', completed);
  }

  // Auto Backup settings
  static Future<bool> isAutoBackupEnabled() async {
    return (await _getValue<bool>('auto_backup_enabled')) ?? false;
  }

  static Future<void> setAutoBackupEnabled(bool enabled) async {
    await _setValue('auto_backup_enabled', enabled);
  }

  static Future<String?> getBackupFolderPath() async {
    return await _getValue<String>('backup_folder_path');
  }

  static Future<void> setBackupFolderPath(String? path) async {
    await _setValue('backup_folder_path', path);
  }

  static Future<String?> getLastAutoBackupDate() async {
    return await _getValue<String>('last_auto_backup_date');
  }

  static Future<void> setLastAutoBackupDate(String dateStr) async {
    await _setValue('last_auto_backup_date', dateStr);
  }

  // Fallbacks for display settings referenced elsewhere in the app
  static Future<bool> getShowHabitIcons() async => true;
  static Future<bool> getCompactMode() async => false;
  static Future<HabitType> getDefaultHabitType() async =>
      HabitType.SuccessBased;
}

