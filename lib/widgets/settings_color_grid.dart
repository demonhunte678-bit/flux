import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/core/index.dart';

class SettingsColorGrid extends StatelessWidget {
  final ThemeState themeState;
  final ValueChanged<String> onThemeSelected;

  const SettingsColorGrid({
    super.key,
    required this.themeState,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeService.accentColors;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = colors[index];
          final color = item.color;
          final name = item.colorName;
          final isSelected = themeState.themeName.toLowerCase() == name.toLowerCase();

          final decoration = BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? (themeState.isDarkMode ? Colors.white : Colors.black87)
                  : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          );

          final buttonContent = isSelected
              ? Icon(
                  Icons.check,
                  color: _isDarkColor(color) ? Colors.white : Colors.black87,
                  size: 16,
                )
              : const SizedBox.shrink();

          return GestureDetector(
            onTap: () => onThemeSelected(name),
            child: Container(
              width: 36,
              height: 36,
              decoration: decoration,
              child: Center(child: buttonContent),
            ),
          );
        },
      ),
    );
  }

  bool _isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }
}
