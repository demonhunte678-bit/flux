import 'package:flutter/material.dart';
import 'package:flux/index.dart';

class Category {
  static final Map<int, Category> customCategories = {};

  static const Category health = Category(id: -1, name: 'health', color: Colors.teal);
  static const Category mental = Category(id: -2, name: 'mental', color: Colors.purple);
  static const Category growth = Category(id: -3, name: 'growth', color: Colors.orange);
  static const Category finances = Category(id: -4, name: 'finances', color: Colors.blue);
  static const Category home = Category(id: -5, name: 'home', color: Colors.indigo);
  static const Category sleep = Category(id: -6, name: 'sleep', color: Colors.amber);
  static const Category relationships = Category(id: -7, name: 'relationships', color: Colors.pink);

  final int id;
  final String name;
  final Color? color;
  final HabitSymbol? iconSymbol;

  const Category({
    required this.id,
    required this.name,
    this.color,
    this.iconSymbol,
  });

  Color get categoryColor => color ?? Colors.blue;

  String getLocalizedName(BuildContext context) {
    if (id < 0) {
      switch (id) {
        case -1:
          return context.l10n.areaHealth;
        case -2:
          return context.l10n.areaMental;
        case -3:
          return context.l10n.areaGrowth;
        case -4:
          return context.l10n.areaFinances;
        case -5:
          return context.l10n.areaHome;
        case -6:
          return context.l10n.areaSleep;
        case -7:
          return context.l10n.areaRelationships;
      }
    }
    return name;
  }

  HabitSymbol getIcon() {
    if (iconSymbol != null) return iconSymbol!;
    if (id < 0) {
      switch (id) {
        case -1:
          return HabitsIcon.getSymbol(Icons.favorite.codePoint);
        case -2:
          return HabitsIcon.getSymbol(Icons.spa.codePoint);
        case -3:
          return HabitsIcon.getSymbol(Icons.trending_up.codePoint);
        case -4:
          return HabitsIcon.getSymbol(Icons.attach_money.codePoint);
        case -5:
          return HabitsIcon.getSymbol(Icons.home.codePoint);
        case -6:
          return HabitsIcon.getSymbol(Icons.bedtime.codePoint);
        case -7:
          return HabitsIcon.getSymbol(Icons.people.codePoint);
      }
    }
    return HabitsIcon.getSymbol(Icons.label_outline.codePoint);
  }
}
