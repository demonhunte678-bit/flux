import 'package:flutter/material.dart';
import 'package:flux/index.dart';

class HabitColorPickerField extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> presetColors;

  const HabitColorPickerField({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.presetColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Color> expandedColors = [
      ...presetColors,
      const Color(0xFFE57373),
      const Color(0xFFF06292),
      const Color(0xFFBA68C8),
      const Color(0xFF9575CD),
      const Color(0xFF7986CB),
      const Color(0xFF64B5F6),
      const Color(0xFF4FC3F7),
      const Color(0xFF4DD0E1),
      const Color(0xFF4DB6AC),
      const Color(0xFF81C784),
      const Color(0xFFAED581),
      const Color(0xFFFFD54F),
      const Color(0xFFFFB74D),
      const Color(0xFFFF8A65),
    ];

    final bool isCustomColor = selectedColor != null && !expandedColors.any((col) => col.value == selectedColor!.value);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: expandedColors.length + 1,
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          final isSelected = isCustomColor;
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (c) => CustomColorPicker(
                  initialColor: selectedColor ?? theme.colorScheme.primary,
                  onColorSelected: onColorSelected,
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : null,
                    gradient: isSelected
                        ? null
                        : const SweepGradient(
                            colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.red],
                          ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: selectedColor!.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                ),
                Icon(
                  isSelected ? Icons.edit : Icons.palette,
                  color: Colors.white,
                  size: isSelected ? 16 : 18,
                ),
                if (isSelected)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        final col = expandedColors[idx - 1];
        final isSelected = selectedColor?.value == col.value;

        return GestureDetector(
          onTap: () => onColorSelected(col),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isSelected ? 40 : 32,
              height: isSelected ? 40 : 32,
              decoration: BoxDecoration(
                color: col,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
                  width: isSelected ? 2.5 : 0.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: col.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class HabitSymbolPickerField extends StatefulWidget {
  final HabitSymbol selectedSymbol;
  final ValueChanged<HabitSymbol> onSymbolSelected;
  final Color? themeColor;

  const HabitSymbolPickerField({
    super.key,
    required this.selectedSymbol,
    required this.onSymbolSelected,
    this.themeColor,
  });

  @override
  State<HabitSymbolPickerField> createState() => _HabitSymbolPickerFieldState();
}

class _HabitSymbolPickerFieldState extends State<HabitSymbolPickerField> {
  String _activeType = 'icons';
  int _selectedGroupIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateStateFromSymbol();
  }

  @override
  void didUpdateWidget(covariant HabitSymbolPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSymbol.value != oldWidget.selectedSymbol.value) {
      _updateStateFromSymbol();
    }
  }

  void _updateStateFromSymbol() {
    _activeType = widget.selectedSymbol.type == HabitSymbolType.emoji ? 'emojis' : 'icons';
    for (int i = 0; i < HabitsIcon.symbolGroups.length; i++) {
      final grp = HabitsIcon.symbolGroups[i];
      final matches = grp.concepts.any((c) {
        if (widget.selectedSymbol.type == HabitSymbolType.icon) {
          return c.icon.codePoint == (widget.selectedSymbol.value as IconData).codePoint;
        } else {
          return c.emoji == (widget.selectedSymbol.value as String);
        }
      });
      if (matches) {
        _selectedGroupIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.themeColor ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ChoiceChip(
              showCheckmark: false,
              label: const Text('Icons'),
              selected: _activeType == 'icons',
              onSelected: (val) {
                if (val) setState(() => _activeType = 'icons');
              },
              selectedColor: activeColor.withValues(alpha: 0.15),
              checkmarkColor: activeColor,
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _activeType == 'icons' ? activeColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                  width: _activeType == 'icons' ? 1.5 : 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              showCheckmark: false,
              label: const Text('Emojis'),
              selected: _activeType == 'emojis',
              onSelected: (val) {
                if (val) setState(() => _activeType = 'emojis');
              },
              selectedColor: activeColor.withValues(alpha: 0.15),
              checkmarkColor: activeColor,
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _activeType == 'emojis' ? activeColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                  width: _activeType == 'emojis' ? 1.5 : 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: HabitsIcon.symbolGroups.length,
            itemBuilder: (context, idx) {
              final grp = HabitsIcon.symbolGroups[idx];
              final isSelected = _selectedGroupIndex == idx;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Text(grp.label),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedGroupIndex = idx);
                  },
                  selectedColor: activeColor.withValues(alpha: 0.15),
                  checkmarkColor: activeColor,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? activeColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                      width: isSelected ? 1.5 : 1,
                ),
              ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: HabitsIcon.symbolGroups[_selectedGroupIndex].concepts.length,
            itemBuilder: (context, idx) {
              final concept = HabitsIcon.symbolGroups[_selectedGroupIndex].concepts[idx];
              final HabitSymbol sym = _activeType == 'icons'
                  ? HabitSymbol.icon(concept.icon, concept.name)
                  : HabitSymbol.emoji(concept.emoji, concept.name);

              final isSelected = widget.selectedSymbol.value == sym.value;

              return GestureDetector(
                onTap: () => widget.onSymbolSelected(sym),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activeColor.withValues(alpha: 0.2)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? activeColor : theme.colorScheme.outline.withValues(alpha: 0.1),
                      width: isSelected ? 2.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: HabitIcon(
                      symbol: sym,
                      size: 24,
                      color: isSelected ? activeColor : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
