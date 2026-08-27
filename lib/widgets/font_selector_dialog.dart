import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/l10n/index.dart';

class FontSelectorDialog extends ConsumerStatefulWidget {
  final String currentFont;
  final ValueChanged<String> onFontSelected;

  const FontSelectorDialog({
    super.key,
    required this.currentFont,
    required this.onFontSelected,
  });

  @override
  ConsumerState<FontSelectorDialog> createState() => _FontSelectorDialogState();
}

class _FontSelectorDialogState extends ConsumerState<FontSelectorDialog> {
  late List<String> _allFonts;
  late List<String> _filteredFonts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Retrieve all supported Google Fonts
    _allFonts = GoogleFonts.asMap().keys.toList()..sort();
    _filteredFonts = _allFonts;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFonts = _allFonts
          .where((font) => font.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: bottomInset + 16,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            context.l10n.selectFont,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.searchFonts,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 16),
          // Font list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFonts.length,
              itemBuilder: (context, index) {
                final fontName = _filteredFonts[index];
                final isSelected = fontName == widget.currentFont;

                return ListTile(
                  title: Text(
                    fontName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    widget.onFontSelected(fontName);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
