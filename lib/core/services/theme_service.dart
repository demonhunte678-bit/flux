import 'package:flutter/material.dart';
import 'package:flux/core/services/settings_service.dart';

class AccentColor {
  final String colorName;
  final Color color;
  
  const AccentColor(this.colorName, this.color);
}

class ThemeService {
  static VoidCallback? onThemeChanged;
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
    return await SettingsService.isDarkMode();
  }
  
  static Future<void> setDarkMode(bool isDark) async {
    await SettingsService.setDarkMode(isDark);
  }
  
  static Future<Color> getAccentColor() async {
    final themeName = await getCurrentTheme();
    final accent = accentColors.firstWhere(
      (c) => c.colorName.toLowerCase() == themeName.toLowerCase(),
      orElse: () => accentColors[0],
    );
    return accent.color;
  }
  
  static Future<void> setAccentColor(Color color) async {
    final accent = accentColors.firstWhere(
      (c) => c.color.value == color.value,
      orElse: () => accentColors[0],
    );
    await setCurrentTheme(accent.colorName);
  }
  
  static Future<String> getCurrentTheme() async {
    return await SettingsService.getSelectedTheme();
  }
  
  static Future<void> setCurrentTheme(String themeName) async {
    await SettingsService.setSelectedTheme(themeName);
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
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }
  
  static List<Color> getGradientColors(Color primary) {
    return [
      primary,
      primary.withOpacity(0.8),
    ];
  }
  
  static Color getComplementaryColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }
  
  static Color getAnalogousColor(Color color, {double offset = 30}) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue((hsl.hue + offset) % 360).toColor();
  }
  
  static List<Color> generatePalette(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return [
      hsl.withLightness(0.9).toColor(),
      hsl.withLightness(0.7).toColor(),
      hsl.withLightness(0.5).toColor(),
      hsl.withLightness(0.3).toColor(),
      hsl.withLightness(0.1).toColor(),
    ];
  }
  
  static Color getAchievementColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'legendary':
        return Colors.purple;
      case 'mythic':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}