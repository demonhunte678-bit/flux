import 'package:flutter/material.dart';
import 'package:flux/index.dart';
import 'package:flux/pages/add_habit_page.dart';

class HabitTemplate {
  final String name;
  final Category category;
  final IconData icon;
  final Color color;
  final HabitFrequency frequency;
  final double? targetValue;
  final HabitUnit unit;
  final String? customUnit;
  final List<int> customDays;
  final int? targetFrequency;

  HabitTemplate({
    required this.name,
    required this.category,
    required this.icon,
    required this.color,
    this.frequency = HabitFrequency.daily,
    this.targetValue,
    this.unit = HabitUnit.count,
    this.customUnit,
    this.customDays = const [],
    this.targetFrequency,
  });

  Habit toHabit() {
    return Habit(
      id: '',
      name: name,
      type: HabitType.good,
      trackingType: targetValue != null ? TrackingType.quantity : TrackingType.check,
      displayMode: ReportDisplay.rate,
      symbol: HabitsIcon.getSymbol(icon.codePoint),
      color: color,
      category: category,
      frequency: frequency,
      customDays: customDays,
      targetFrequency: targetFrequency,
      targetValue: targetValue,
      unit: unit,
      customUnit: customUnit,
    );
  }
}

class HabitTemplatesSheet extends StatefulWidget {
  final Function(Habit) onSave;

  const HabitTemplatesSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<HabitTemplatesSheet> createState() => _HabitTemplatesSheetState();
}

class _HabitTemplatesSheetState extends State<HabitTemplatesSheet> {
  Category? _selectedCategory;
  final List<Category> _categories = [
    Category.health,
    Category.mental,
    Category.growth,
    Category.finances,
    Category.home,
    Category.sleep,
    Category.relationships,
  ];

  late final List<HabitTemplate> _templates = [
    // Health & Fitness
    HabitTemplate(name: 'Workout', category: Category.health, icon: Icons.fitness_center, color: Colors.teal, targetValue: 30, unit: HabitUnit.minutes),
    HabitTemplate(name: 'Morning Walk', category: Category.health, icon: Icons.directions_walk, color: Colors.green, targetValue: 20, unit: HabitUnit.minutes),
    HabitTemplate(name: 'Drink Water', category: Category.health, icon: Icons.local_drink, color: Colors.blue, targetValue: 8, unit: HabitUnit.count),
    HabitTemplate(name: 'Eat Fruit', category: Category.health, icon: Icons.apple, color: Colors.red),
    HabitTemplate(name: 'Stretch Daily', category: Category.health, icon: Icons.accessibility_new, color: Colors.teal, targetValue: 10, unit: HabitUnit.minutes),

    // Mindfulness & Mental Health
    HabitTemplate(name: 'Meditate', category: Category.mental, icon: Icons.spa, color: Colors.purple, targetValue: 15, unit: HabitUnit.minutes),
    HabitTemplate(name: 'Journal', category: Category.mental, icon: Icons.edit_note, color: Colors.deepPurple),
    HabitTemplate(name: 'Practice Gratitude', category: Category.mental, icon: Icons.sentiment_satisfied, color: Colors.amber),
    HabitTemplate(name: 'Deep Breathing', category: Category.mental, icon: Icons.air, color: Colors.cyan, targetValue: 5, unit: HabitUnit.minutes),

    // Growth & Learning
    HabitTemplate(name: 'Read Books', category: Category.growth, icon: Icons.book, color: Colors.orange, targetValue: 20, unit: HabitUnit.pages),
    HabitTemplate(name: 'Learn Coding', category: Category.growth, icon: Icons.code, color: Colors.indigo, targetValue: 30, unit: HabitUnit.minutes),
    HabitTemplate(name: 'Review Goals', category: Category.growth, icon: Icons.adjust, color: Colors.redAccent, frequency: HabitFrequency.weekdays),
    HabitTemplate(name: 'Learn Language', category: Category.growth, icon: Icons.translate, color: Colors.amber, targetValue: 15, unit: HabitUnit.minutes),

    // Finances
    HabitTemplate(name: 'Track Expenses', category: Category.finances, icon: Icons.attach_money, color: Colors.green),
    HabitTemplate(name: 'Save Money', category: Category.finances, icon: Icons.savings, color: Colors.amber, frequency: HabitFrequency.weekends),
    HabitTemplate(name: 'No Impulse Buying', category: Category.finances, icon: Icons.money_off, color: Colors.red),

    // Home & Organization
    HabitTemplate(name: 'Tidy Up Room', category: Category.home, icon: Icons.cleaning_services, color: Colors.blueGrey, targetValue: 15, unit: HabitUnit.minutes),
    HabitTemplate(name: 'Water Plants', category: Category.home, icon: Icons.local_florist, color: Colors.lightGreen, frequency: HabitFrequency.customDays, customDays: [1, 4]), // Mon, Thu

    // Sleep
    HabitTemplate(name: 'Sleep 8 Hours', category: Category.sleep, icon: Icons.bedtime, color: Colors.indigoAccent, targetValue: 8, unit: HabitUnit.hours),
    HabitTemplate(name: 'No Screen in Bed', category: Category.sleep, icon: Icons.phonelink_off, color: Colors.deepOrange),

    // Relationships
    HabitTemplate(name: 'Call a Loved One', category: Category.relationships, icon: Icons.phone_in_talk, color: Colors.pink, frequency: HabitFrequency.weekends),
    HabitTemplate(name: 'Express Appreciation', category: Category.relationships, icon: Icons.favorite, color: Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _selectedCategory == null
        ? _templates
        : _templates.where((t) => t.category.id == _selectedCategory!.id).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle & Header
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore Templates',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Category Filters
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = null);
                  },
                ),
                const SizedBox(width: 8),
                ..._categories.map((cat) {
                  final isSelected = _selectedCategory?.id == cat.id;
                  final catColor = cat.categoryColor;
                  final theme = Theme.of(context);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      showCheckmark: false,
                      label: Row(
                        children: [
                          HabitIcon(
                            symbol: cat.getIcon(),
                            size: 14,
                            color: isSelected ? catColor : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat.getLocalizedName(context),
                            style: TextStyle(
                              color: isSelected ? catColor : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                      selectedColor: catColor.withValues(alpha: 0.15),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                      checkmarkColor: catColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? catColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 24),

          // Grid list of templates
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final template = filtered[index];
                return _buildTemplateCard(template, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(HabitTemplate template, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      color: template.color.withValues(alpha: 0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _useTemplate(template),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: template.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(template.icon, color: template.color, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: template.category.categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      template.category.getLocalizedName(context),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: template.category.categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                template.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                template.frequency == HabitFrequency.daily ? 'Every day' : 'Flexible schedule',
                style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _useTemplate(HabitTemplate template) {
    Navigator.pop(context); // Close templates sheet
    
    // Open AddHabitPage pre-filled
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddHabitPage(
          isTemplate: true,
          habitToEdit: template.toHabit(),
          onSave: widget.onSave,
        ),
      ),
    );
  }
}
