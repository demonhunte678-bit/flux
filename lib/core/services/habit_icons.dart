import 'package:flutter/material.dart';

class HabitsIcon {
  static const Map<String, IconData> icons = {
    'star': Icons.star,
    'fitness_center': Icons.fitness_center,
    'book': Icons.book,
    'brush': Icons.brush,
    'run_circle': Icons.run_circle,
    'water_drop': Icons.water_drop,
    'food_bank': Icons.food_bank,
    'bed': Icons.bed,
    'emoji_emotions': Icons.emoji_emotions,
    'self_improvement': Icons.self_improvement,
    'music_note': Icons.music_note,
    'code': Icons.code,
    'sports_basketball': Icons.sports_basketball,
    'smoking_rooms': Icons.smoking_rooms,
    'local_drink': Icons.local_drink,
    'monitor': Icons.monitor,
    'health_and_safety': Icons.health_and_safety,
    'directions_run': Icons.directions_run,
    'dark_mode': Icons.dark_mode,
    'light_mode': Icons.light_mode,
    'pets': Icons.pets,
    'nature': Icons.nature,
    'volunteer_activism': Icons.volunteer_activism,
    'school': Icons.school,
    'alarm': Icons.alarm,
    'piano': Icons.piano,
    'savings': Icons.savings,
    'attach_money': Icons.attach_money,
    'directions_walk': Icons.directions_walk,
    'smoke_free': Icons.smoke_free,
    'air': Icons.air,
    'no_food': Icons.no_food,
    'no_drinks': Icons.no_drinks,
    'spa': Icons.spa,
    'sentiment_satisfied_alt': Icons.sentiment_satisfied_alt,
    'edit_note': Icons.edit_note,
    'timer_off': Icons.timer_off,
    'shield_outlined': Icons.shield_outlined,
    'dangerous': Icons.dangerous,
    'videogame_asset_off': Icons.videogame_asset_off,
    'money_off': Icons.money_off,
    'cleaning_services': Icons.cleaning_services,
    'bedtime': Icons.bedtime,
    'nightlight_round': Icons.nightlight_round,
    'phone_in_talk': Icons.phone_in_talk,
    'favorite': Icons.favorite,
    'check_circle': Icons.check_circle,
    'check_circle_outline': Icons.check_circle_outline,
    'circle_outlined': Icons.circle_outlined,
    'block_outlined': Icons.block_outlined,
    'emoji_events_outlined': Icons.emoji_events_outlined,
    'flatware': Icons.flatware,
    'phonelink_off': Icons.phonelink_off,
  };

  /// Legacy property alias for backward compatibility
  static Map<String, IconData> get keysToIcons => icons;

  /// Returns the map of keys to IconData constants
  static Map<String, IconData> getIconsMap() => icons;

  static IconData getIcon(String? key) {
    if (key == null) return Icons.star;
    return icons[key] ?? Icons.star;
  }

  static String getKey(IconData? icon) {
    if (icon == null) return 'star';
    for (var entry in icons.entries) {
      if (entry.value.codePoint == icon.codePoint) {
        return entry.key;
      }
    }
    return 'star';
  }

  static IconData? fromCodePoint(int? codePoint) {
    if (codePoint == null) return null;
    for (var icon in icons.values) {
      if (icon.codePoint == codePoint) {
        return icon;
      }
    }
    return Icons.star;
  }
}

/// Backward compatibility alias
typedef HabitIcons = HabitsIcon;
