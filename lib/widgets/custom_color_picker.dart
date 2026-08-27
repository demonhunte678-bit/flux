import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const CustomColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late Color _pickerColor;

  @override
  void initState() {
    super.initState();
    _pickerColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Pick a Color'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _pickerColor,
          onColorChanged: (color) {
            setState(() => _pickerColor = color);
          },
          colorPickerWidth: 260,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: false,
          displayThumbColor: true,
          paletteType: PaletteType.hsv,
          labelTypes: const [],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onColorSelected(_pickerColor);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _pickerColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
