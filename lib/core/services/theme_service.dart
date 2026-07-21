import 'package:flutter/material.dart';
import 'package:flux/index.dart';

class AccentColor {
  final String colorName;
  final Color color;

  const AccentColor(this.colorName, this.color);
}

class ThemeService {
  static VoidCallback? onThemeChanged;
  
  // Predefined accent colors with proper structure
  static final List<AccentColor> accentColors = [
    const AccentColor('Emerald', Color(0xFF1DB954)),
    const AccentColor('Azure', Color(0xFF2196F3)),
    const AccentColor('Violet', Color(0xFF9C27B0)),
    const AccentColor('Sunset', Color(0xFFFF9800)),
    const AccentColor('Ruby', Color(0xFFF44336)),
    const AccentColor('Amber', Color(0xFFFFC107)),
    const AccentColor('Graphite', Color(0xFF4A4A4A)),
    const AccentColor('Blossom', Color(0xFFE91E63)),
  ];

  static Future<bool> isDarkMode() async {
    return await SettingsService.isDarkMode();
  }

  static Future<void> setDarkMode(bool isDark) async {
    await SettingsService.setDarkMode(isDark);
  }

  static Future<Color> getAccentColor() async {
    final themeName = await getCurrentTheme();
    if (themeName.toLowerCase() == 'system') {
      return accentColors[0].color; // Default fallback to Emerald
    }
    final accent = accentColors.firstWhere(
      (c) => c.colorName.toLowerCase() == themeName.toLowerCase(),
      orElse: () => accentColors[0],
    );
    return accent.color;
  }

  static Future<void> setAccentColor(Color color) async {
    final accent = accentColors.firstWhere(
      (c) => c.color.toARGB32() == color.toARGB32(),
      orElse: () => accentColors[0],
    );
    await setCurrentTheme(accent.colorName);
  }

  static Future<String> getCurrentTheme() async {
    final theme = await SettingsService.getSelectedTheme();
    // Migrating old 'Green' theme to 'Emerald'
    if (theme.toLowerCase() == 'green') {
      return 'Emerald';
    }
    return theme;
  }

  static Future<void> setCurrentTheme(String themeName) async {
    await SettingsService.setSelectedTheme(themeName);
  }

  static ThemeData createTheme({
    required String themeName,
    required bool isDarkMode,
    ColorScheme? dynamicColorScheme,
  }) {
    if (themeName.toLowerCase() == 'system' && dynamicColorScheme != null) {
      return ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorScheme: dynamicColorScheme,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
        ),
      );
    }

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
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static List<Color> getGradientColors(Color primary) {
    final hsl = HSLColor.fromColor(primary);
    final color1 = hsl.withLightness((hsl.lightness + 0.12).clamp(0.0, 1.0)).toColor();
    final color2 = hsl.withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0)).toColor();
    return [color1, color2];
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
