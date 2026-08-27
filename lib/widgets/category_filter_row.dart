import 'package:flutter/material.dart';
import 'package:flux/data/models/category.dart';

class CategoryFilterRow extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?> onCategorySelected;

  const CategoryFilterRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedCategory == null,
            onSelected: (selected) {
              if (selected) onCategorySelected(null);
            },
          ),
          const SizedBox(width: 8),
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat.getLocalizedName(context)),
                selected: selectedCategory?.id == cat.id,
                onSelected: (selected) {
                  onCategorySelected(selected ? cat : null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
