import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeData themeData;
  final String themeName;
  final bool isDarkMode;

  ThemeState({
    required this.themeData,
    required this.themeName,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    ThemeData? themeData,
    String? themeName,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      themeName: themeName ?? this.themeName,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final Ref ref;
  static const _iconChannel = MethodChannel('dev.wisamidris77.flux/launcher_icon');

  ThemeNotifier(this.ref)
    : super(
        ThemeState(
          themeData: ThemeService.createTheme(
            themeName: 'Emerald',
            isDarkMode: ui.PlatformDispatcher.instance.platformBrightness == ui.Brightness.dark,
            gamifiedMode: false,
          ),
          themeName: 'Emerald',
          isDarkMode: ui.PlatformDispatcher.instance.platformBrightness == ui.Brightness.dark,
        ),
      ) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await ThemeService.isDarkMode();
    var name = await ThemeService.getCurrentTheme();
    final gamified = await SettingsService.getGamifiedMode();

    if (!kIsWeb && Platform.isAndroid) {
      try {
        final bool isThemedEnabled = await _iconChannel.invokeMethod('isThemedIconEnabled') ?? false;
        debugPrint('System themed icon enabled status: $isThemedEnabled');
      } catch (e) {
        debugPrint('Failed to query themed icon status: $e');
      }
    }

    state = ThemeState(
      themeData: ThemeService.createTheme(
        themeName: name,
        isDarkMode: isDark,
        gamifiedMode: gamified,
      ),
      themeName: name,
      isDarkMode: isDark,
    );
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await ThemeService.setDarkMode(isDark);
    final gamified = await SettingsService.getGamifiedMode();
    state = state.copyWith(
      themeData: ThemeService.createTheme(
        themeName: state.themeName,
        isDarkMode: isDark,
        gamifiedMode: gamified,
      ),
      isDarkMode: isDark,
    );
  }

  Future<void> selectTheme(String themeName) async {
    await ThemeService.setCurrentTheme(themeName);
    final gamified = await SettingsService.getGamifiedMode();
    state = state.copyWith(
      themeData: ThemeService.createTheme(
        themeName: themeName,
        isDarkMode: state.isDarkMode,
        gamifiedMode: gamified,
      ),
      themeName: themeName,
    );
    await _updateLauncherIcon(themeName);
  }

  Future<void> _updateLauncherIcon(String themeName) async {
    final matchIcon = ref.read(settingsProvider).matchLauncherIcon;
    if (!matchIcon) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final String targetIcon = themeName.toLowerCase() == 'system' ? 'Emerald' : themeName;
        await _iconChannel.invokeMethod('changeIcon', {'iconName': targetIcon});
      } catch (e) {
        debugPrint('Failed to change launcher icon: $e');
      }
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier(ref);
});
