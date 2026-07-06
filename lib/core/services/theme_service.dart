import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccentColor {
  final String colorName;
  final Color color;
  
  const AccentColor(this.colorName, this.color);
}

class ThemeService {
  static const String _themeKey = 'app_theme';
  static const String _accentColorKey = 'accent_color';
  static const String _customThemeKey = 'custom_theme';
  
  // Predefined accent colors with proper structure
  static final List<AccentColor> accentColors = [
    const AccentColor('Green', Color(0xFF1DB954)),
    const AccentColor('Blue', Color(0xFF2196F3)),
    const AccentColor('Purple', Color(0xFF9C27B0)),
    const AccentColor('Orange', Color(0xFFFF9800)),
    const AccentColor('Red', Color(0xFFF44336)),
    const AccentColor('Teal', Color(0xFF009688)),
    const AccentColor('Indigo', Color(0xFF3F51B5)),
    const AccentColor('Pink', Color(0xFFE91E63)),
    const AccentColor('Deep Purple', Color(0xFF673AB7)),
    const AccentColor('Cyan', Color(0xFF00BCD4)),
    const AccentColor('Amber', Color(0xFFFFC107)),
    const AccentColor('Deep Orange', Color(0xFFFF5722)),
    const AccentColor('Light Blue', Color(0xFF03A9F4)),
    const AccentColor('Lime', Color(0xFFCDDC39)),
    const AccentColor('Yellow', Color(0xFFFFEB3B)),
    const AccentColor('Brown', Color(0xFF795548)),
    const AccentColor('Grey', Color(0xFF607D8B)),
  ];
  
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
  
  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
  
  static Future<Color> getAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_accentColorKey);
    return colorValue != null ? Color(colorValue) : accentColors[0].color;
  }
  
  static Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.value);
  }
  
  static Future<String> getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customThemeKey) ?? 'Green';
  }
  
  static Future<void> setCurrentTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customThemeKey, themeName);
  }
  
  static ThemeData createTheme({
    required String themeName,
    required bool isDarkMode,
  }) {
    final accent = accentColors.firstWhere(
      (c) => c.colorName.toLowerCase() == themeName.toLowerCase(),
      orElse: () => accentColors[0],
    );
    final primaryColor = accent.color;
    final useDark = isDarkMode;
    
    return ThemeData(
      useMaterial3: true,
      brightness: useDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: useDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}