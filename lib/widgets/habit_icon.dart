import 'package:flutter/material.dart';
import 'package:flux/index.dart';

class HabitIcon extends StatelessWidget {
  final HabitSymbol symbol;
  final double size;
  final Color? color;

  const HabitIcon({
    super.key,
    required this.symbol,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary;

    if (symbol.type == HabitSymbolType.emoji) {
      return Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Text(
          symbol.value as String,
          style: TextStyle(
            fontSize: size,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Icon(
        symbol.value as IconData,
        color: iconColor,
        size: size,
      );
    }
  }
}
