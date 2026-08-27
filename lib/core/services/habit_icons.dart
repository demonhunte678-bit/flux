import 'package:flutter/material.dart';

enum HabitSymbolType { icon, emoji }

class HabitSymbol {
  final HabitSymbolType type;
  final dynamic value; // IconData for icon, String for emoji
  final String name;

  const HabitSymbol.icon(IconData icon, this.name)
      : type = HabitSymbolType.icon,
        value = icon;

  const HabitSymbol.emoji(String emoji, this.name)
      : type = HabitSymbolType.emoji,
        value = emoji;
}

class HabitSymbolsGroup {
  final String name;
  final String label;
  final List<HabitSymbol> symbols;

  const HabitSymbolsGroup({
    required this.name,
    required this.label,
    required this.symbols,
  });
}

class HabitSymbolConcept {
  final String name;
  final IconData icon;
  final String emoji;

  const HabitSymbolConcept({
    required this.name,
    required this.icon,
    required this.emoji,
  });
}

class HabitSymbolsCategoryGroup {
  final String name;
  final String label;
  final List<HabitSymbolConcept> concepts;

  const HabitSymbolsCategoryGroup({
    required this.name,
    required this.label,
    required this.concepts,
  });
}

class HabitsIcon {
  static const List<HabitSymbolsCategoryGroup> symbolGroups = [
    HabitSymbolsCategoryGroup(
      name: 'art',
      label: 'Art & Creative',
      concepts: [
        HabitSymbolConcept(name: 'painting', icon: Icons.brush, emoji: '🎨'),
        HabitSymbolConcept(name: 'reading', icon: Icons.menu_book, emoji: '📚'),
        HabitSymbolConcept(name: 'writing', icon: Icons.edit, emoji: '✍️'),
        HabitSymbolConcept(name: 'music', icon: Icons.music_note, emoji: '🎵'),
        HabitSymbolConcept(name: 'guitar', icon: Icons.music_video, emoji: '🎸'),
        HabitSymbolConcept(name: 'piano', icon: Icons.piano, emoji: '🎹'),
        HabitSymbolConcept(name: 'coding', icon: Icons.code, emoji: '💻'),
        HabitSymbolConcept(name: 'game', icon: Icons.sports_esports, emoji: '🎮'),
        HabitSymbolConcept(name: 'movie', icon: Icons.movie, emoji: '🎬'),
        HabitSymbolConcept(name: 'camera', icon: Icons.camera_alt, emoji: '📷'),
        HabitSymbolConcept(name: 'theater', icon: Icons.theater_comedy, emoji: '🎭'),
        HabitSymbolConcept(name: 'micro', icon: Icons.mic, emoji: '🎤'),
        HabitSymbolConcept(name: 'craft', icon: Icons.construction, emoji: '🛠️'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'health',
      label: 'Health & Fitness',
      concepts: [
        HabitSymbolConcept(name: 'gym', icon: Icons.fitness_center, emoji: '🏋️'),
        HabitSymbolConcept(name: 'running', icon: Icons.directions_run, emoji: '🏃'),
        HabitSymbolConcept(name: 'cycling', icon: Icons.directions_bike, emoji: '🚴'),
        HabitSymbolConcept(name: 'walking', icon: Icons.directions_walk, emoji: '🚶'),
        HabitSymbolConcept(name: 'swimming', icon: Icons.pool, emoji: '🏊'),
        HabitSymbolConcept(name: 'water', icon: Icons.local_drink, emoji: '💧'),
        HabitSymbolConcept(name: 'bicep', icon: Icons.bolt, emoji: '💪'),
        HabitSymbolConcept(name: 'soccer', icon: Icons.sports_soccer, emoji: '⚽'),
        HabitSymbolConcept(name: 'basketball', icon: Icons.sports_basketball, emoji: '🏀'),
        HabitSymbolConcept(name: 'tennis', icon: Icons.sports_tennis, emoji: '🎾'),
        HabitSymbolConcept(name: 'golf', icon: Icons.sports_golf, emoji: '⛳'),
        HabitSymbolConcept(name: 'medicine', icon: Icons.medication, emoji: '💊'),
        HabitSymbolConcept(name: 'apple', icon: Icons.apple, emoji: '🍎'),
        HabitSymbolConcept(name: 'salad', icon: Icons.restaurant, emoji: '🥗'),
        HabitSymbolConcept(name: 'heartbeat', icon: Icons.favorite, emoji: '❤️'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'mind',
      label: 'Mind & Spirit',
      concepts: [
        HabitSymbolConcept(name: 'meditate', icon: Icons.spa, emoji: '🧘'),
        HabitSymbolConcept(name: 'brain', icon: Icons.psychology, emoji: '🧠'),
        HabitSymbolConcept(name: 'yoga', icon: Icons.self_improvement, emoji: '🧘‍♂️'),
        HabitSymbolConcept(name: 'sleep', icon: Icons.bedtime, emoji: '💤'),
        HabitSymbolConcept(name: 'light', icon: Icons.lightbulb, emoji: '💡'),
        HabitSymbolConcept(name: 'fire', icon: Icons.local_fire_department, emoji: '🔥'),
        HabitSymbolConcept(name: 'peace', icon: Icons.volunteer_activism, emoji: '🕊️'),
        HabitSymbolConcept(name: 'star', icon: Icons.star, emoji: '⭐'),
        HabitSymbolConcept(name: 'prayer', icon: Icons.favorite, emoji: '🙏'),
        HabitSymbolConcept(name: 'shield', icon: Icons.shield, emoji: '🛡️'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'finance',
      label: 'Finance & Work',
      concepts: [
        HabitSymbolConcept(name: 'cash', icon: Icons.attach_money, emoji: '💵'),
        HabitSymbolConcept(name: 'savings', icon: Icons.savings, emoji: '💰'),
        HabitSymbolConcept(name: 'shopping', icon: Icons.shopping_cart, emoji: '🛒'),
        HabitSymbolConcept(name: 'card', icon: Icons.credit_card, emoji: '💳'),
        HabitSymbolConcept(name: 'trend_up', icon: Icons.trending_up, emoji: '📈'),
        HabitSymbolConcept(name: 'work', icon: Icons.work, emoji: '💼'),
        HabitSymbolConcept(name: 'lock', icon: Icons.lock, emoji: '🔒'),
        HabitSymbolConcept(name: 'key', icon: Icons.key, emoji: '🔑'),
        HabitSymbolConcept(name: 'calculate', icon: Icons.calculate, emoji: '📊'),
        HabitSymbolConcept(name: 'target', icon: Icons.adjust, emoji: '🎯'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'home',
      label: 'Home & Life',
      concepts: [
        HabitSymbolConcept(name: 'home', icon: Icons.home, emoji: '🏠'),
        HabitSymbolConcept(name: 'clean', icon: Icons.cleaning_services, emoji: '🧹'),
        HabitSymbolConcept(name: 'plant', icon: Icons.local_florist, emoji: '🌱'),
        HabitSymbolConcept(name: 'pet', icon: Icons.pets, emoji: '🐱'),
        HabitSymbolConcept(name: 'dog', icon: Icons.pets, emoji: '🐶'),
        HabitSymbolConcept(name: 'alarm', icon: Icons.alarm, emoji: '⏰'),
        HabitSymbolConcept(name: 'tools', icon: Icons.build, emoji: '🔧'),
        HabitSymbolConcept(name: 'inbox', icon: Icons.mail, emoji: '✉️'),
        HabitSymbolConcept(name: 'bed', icon: Icons.bed, emoji: '🛌'),
        HabitSymbolConcept(name: 'coffee', icon: Icons.coffee, emoji: '☕'),
        HabitSymbolConcept(name: 'tea', icon: Icons.emoji_food_beverage, emoji: '🍵'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'social',
      label: 'Social & Fun',
      concepts: [
        HabitSymbolConcept(name: 'phone', icon: Icons.phone, emoji: '📞'),
        HabitSymbolConcept(name: 'chat', icon: Icons.chat, emoji: '💬'),
        HabitSymbolConcept(name: 'heart', icon: Icons.favorite, emoji: '❤️'),
        HabitSymbolConcept(name: 'party', icon: Icons.celebration, emoji: '🎉'),
        HabitSymbolConcept(name: 'gift', icon: Icons.card_giftcard, emoji: '🎁'),
        HabitSymbolConcept(name: 'trophy', icon: Icons.emoji_events, emoji: '🏆'),
        HabitSymbolConcept(name: 'medal', icon: Icons.military_tech, emoji: '🏅'),
        HabitSymbolConcept(name: 'balloon', icon: Icons.chat_bubble, emoji: '🎈'),
        HabitSymbolConcept(name: 'email', icon: Icons.email, emoji: '💌'),
        HabitSymbolConcept(name: 'photo', icon: Icons.photo_camera, emoji: '📸'),
      ],
    ),
    HabitSymbolsCategoryGroup(
      name: 'nature',
      label: 'Nature & Travel',
      concepts: [
        HabitSymbolConcept(name: 'sun', icon: Icons.wb_sunny, emoji: '☀️'),
        HabitSymbolConcept(name: 'moon', icon: Icons.bedtime, emoji: '🌙'),
        HabitSymbolConcept(name: 'tree', icon: Icons.forest, emoji: '🌲'),
        HabitSymbolConcept(name: 'flower', icon: Icons.filter_vintage, emoji: '🌸'),
        HabitSymbolConcept(name: 'mountain', icon: Icons.terrain, emoji: '🏔️'),
        HabitSymbolConcept(name: 'explore', icon: Icons.explore, emoji: '🧭'),
        HabitSymbolConcept(name: 'map', icon: Icons.map, emoji: '🗺️'),
        HabitSymbolConcept(name: 'plane', icon: Icons.flight, emoji: '✈️'),
        HabitSymbolConcept(name: 'sailboat', icon: Icons.sailing, emoji: '⛵'),
        HabitSymbolConcept(name: 'flag', icon: Icons.flag, emoji: '🚩'),
        HabitSymbolConcept(name: 'cloud', icon: Icons.cloud, emoji: '☁️'),
        HabitSymbolConcept(name: 'bolt', icon: Icons.bolt, emoji: '⚡'),
      ],
    ),
  ];

  static List<HabitSymbol> get icons => symbolGroups
      .expand((g) => g.concepts.map((c) => HabitSymbol.icon(c.icon, c.name)))
      .toList();

  static List<HabitSymbol> get emojis => symbolGroups
      .expand((g) => g.concepts.map((c) => HabitSymbol.emoji(c.emoji, c.name)))
      .toList();

  static final List<HabitSymbolsGroup> groups = [
    HabitSymbolsGroup(name: 'icons', label: 'Icons', symbols: icons),
    HabitSymbolsGroup(name: 'emojis', label: 'Emojis', symbols: emojis),
  ];

  static int getSymbolId(HabitSymbol symbol) {
    if (symbol.type == HabitSymbolType.icon) {
      return (symbol.value as IconData).codePoint;
    } else {
      return (symbol.value as String).runes.first;
    }
  }

  static HabitSymbol getSymbol(int? id) {
    if (id == null) return icons.first;
    for (var root in groups) {
      for (var symbol in root.symbols) {
        if (getSymbolId(symbol) == id) {
          return symbol;
        }
      }
    }
    if (_isEmojiCodePoint(id)) {
      return HabitSymbol.emoji(String.fromCharCode(id), 'emoji_$id');
    }
    return HabitSymbol.icon(IconData(id, fontFamily: 'MaterialIcons'), 'icon_$id');
  }

  static HabitSymbol getSymbolFromPath(String? path) {
    if (path == null) return icons.first;
    if (path.contains('.')) {
      final parts = path.split('.');
      if (parts.length >= 2) {
        final rootName = parts[0];
        final symbolName = parts[1];
        for (var root in groups) {
          if (root.name == rootName) {
            for (var s in root.symbols) {
              if (s.name == symbolName) return s;
            }
          }
        }
      }
    }
    for (var root in groups) {
      for (var s in root.symbols) {
        if (s.name == path) return s;
      }
    }
    return icons.first;
  }

  static String getSymbolPath(HabitSymbol symbol) {
    final symId = getSymbolId(symbol);
    for (var root in groups) {
      for (var s in root.symbols) {
        if (getSymbolId(s) == symId) {
          return '${root.name}.${s.name}';
        }
      }
    }
    return 'icons.star';
  }

  static bool _isEmojiCodePoint(int codePoint) {
    return (codePoint >= 0x1F300 && codePoint <= 0x1F9FF) ||
           (codePoint >= 0x1F600 && codePoint <= 0x1F64F) ||
           (codePoint >= 0x1F680 && codePoint <= 0x1F6FF) ||
           (codePoint >= 0x2600 && codePoint <= 0x27BF) ||
           (codePoint >= 0x1F1E6 && codePoint <= 0x1F1FF) ||
           (codePoint >= 0x1F900 && codePoint <= 0x1F9FF);
  }
}

typedef HabitIcons = HabitsIcon;
