import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

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
  ThemeNotifier()
    : super(
        ThemeState(
          themeData: ThemeService.createTheme(
            themeName: 'Green',
            isDarkMode: false,
          ),
          themeName: 'Green',
          isDarkMode: false,
        ),
      ) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await ThemeService.isDarkMode();
    final name = await ThemeService.getCurrentTheme();
    state = ThemeState(
      themeData: ThemeService.createTheme(themeName: name, isDarkMode: isDark),
      themeName: name,
      isDarkMode: isDark,
    );
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await ThemeService.setDarkMode(isDark);
    state = state.copyWith(
      themeData: ThemeService.createTheme(
        themeName: state.themeName,
        isDarkMode: isDark,
      ),
      isDarkMode: isDark,
    );
  }

  Future<void> selectTheme(String themeName) async {
    await ThemeService.setCurrentTheme(themeName);
    state = state.copyWith(
      themeData: ThemeService.createTheme(
        themeName: themeName,
        isDarkMode: state.isDarkMode,
      ),
      themeName: themeName,
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
