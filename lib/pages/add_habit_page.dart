import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flux/index.dart';

class AddHabitPage extends StatefulWidget {
  final Function(Habit) onSave;
  final Habit? habitToEdit;
  final bool isTemplate;

  const AddHabitPage({
    super.key,
    required this.onSave,
    this.habitToEdit,
    this.isTemplate = false,
  });

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _targetValueCtrl = TextEditingController();
  final _targetFrequencyCtrl = TextEditingController();
  final _customUnitCtrl = TextEditingController();
  final _goalValueCtrl = TextEditingController();
  final _symbolSearchCtrl = TextEditingController();

  Category? _selectedCategory;
  bool _isGoodHabit = true;
  bool _isChecklist = true;
  HabitSymbol _symbol = HabitsIcon.getSymbol(null);
  Color? _color;
  HabitFrequency _frequency = HabitFrequency.daily;
  final List<int> _customDays = [];
  WeekendDays _weekendDays = WeekendDays.saturdaySunday;
  GoalType? _goalType;
  bool _isSaving = false;

  HabitUnit _unit = HabitUnit.count;
  String _activeSymbolType = 'icons';
  int _selectedSymbolGroupIndex = 0;

  final List<Color> _presetColors = [
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFF9C27B0),
    const Color(0xFFFF9800),
    const Color(0xFFE91E63),
    const Color(0xFF00BCD4),
    const Color(0xFFFF5722),
    const Color(0xFF607D8B),
  ];

  final List<Category> _defaultCategories = [
    Category.health,
    Category.mental,
    Category.growth,
    Category.finances,
    Category.home,
    Category.sleep,
    Category.relationships,
  ];

  late List<Category> _categoriesList;

  @override
  void initState() {
    super.initState();
    _categoriesList = List.from(_defaultCategories);
    for (var cat in Category.customCategories.values) {
      if (!_categoriesList.any((c) => c.id == cat.id)) {
        _categoriesList.add(cat);
      }
    }
    _loadDefaults();

    _activeSymbolType = _symbol.type == HabitSymbolType.emoji ? 'emojis' : 'icons';
    for (int i = 0; i < HabitsIcon.symbolGroups.length; i++) {
      final grp = HabitsIcon.symbolGroups[i];
      final matches = grp.concepts.any((c) {
        if (_symbol.type == HabitSymbolType.icon) {
          return c.icon.codePoint == (_symbol.value as IconData).codePoint;
        } else {
          return c.emoji == (_symbol.value as String);
        }
      });
      if (matches) {
        _selectedSymbolGroupIndex = i;
        break;
      }
    }
  }

  void _loadDefaults() {
    if (widget.habitToEdit != null) {
      final habit = widget.habitToEdit!;
      _nameCtrl.text = habit.name;
      _notesCtrl.text = habit.notes ?? '';
      _selectedCategory = habit.category;
      if (_selectedCategory != null && !_categoriesList.any((c) => c.id == _selectedCategory!.id)) {
        _categoriesList.add(_selectedCategory!);
      }
      
      _isGoodHabit = habit.type == HabitType.good;
      _isChecklist = habit.trackingType == TrackingType.check;

      _symbol = habit.symbol;
      _color = habit.color;
      _frequency = habit.frequency;
      _customDays.clear();
      _customDays.addAll(habit.customDays);
      
      _unit = habit.unit;
      if (habit.unit == HabitUnit.custom) {
        _customUnitCtrl.text = habit.customUnit ?? '';
      }
      _targetValueCtrl.text = habit.targetValue?.toString() ?? '';
      _weekendDays = habit.weekendDays ?? WeekendDays.saturdaySunday;
      _goalType = habit.goalType;
      _goalValueCtrl.text = habit.goalValue?.toString() ?? '';
    }
  }



  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    _targetValueCtrl.dispose();
    _targetFrequencyCtrl.dispose();
    _customUnitCtrl.dispose();
    _goalValueCtrl.dispose();
    _symbolSearchCtrl.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    if (widget.habitToEdit != null) {
      final h = widget.habitToEdit!;
      return _nameCtrl.text != h.name ||
          _notesCtrl.text != (h.notes ?? '') ||
          _color != h.color ||
          _symbol.value != h.symbol.value;
    } else {
      return _nameCtrl.text.isNotEmpty || _notesCtrl.text.isNotEmpty;
    }
  }

  Future<bool> _showDiscardDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Keep Editing'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasUnsavedChanges(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.habitToEdit != null ? 'Edit Habit' : 'New Habit'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (Navigator.of(context).canPop()) {
                if (_hasUnsavedChanges()) {
                  final shouldPop = await _showDiscardDialog(context);
                  if (shouldPop && context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLivePreview(context),
                      const SizedBox(height: 24),

                      _buildSectionTitle(context, 'Basic Details'),
                      const SizedBox(height: 12),
                      _buildBasicFields(context),
                      const Divider(height: 32),

                      _buildSectionTitle(context, 'Routine Tracking'),
                      const SizedBox(height: 12),
                      _buildHabitTypeSection(context),
                      const Divider(height: 32),

                      _buildSectionTitle(context, 'Schedule'),
                      const SizedBox(height: 12),
                      _buildScheduleSection(context),
                      const Divider(height: 32),

                      _buildSectionTitle(context, 'Colors'),
                      const SizedBox(height: 12),
                      _buildColorSection(context),
                      const Divider(height: 32),

                      _buildSectionTitle(context, 'Symbols'),
                      const SizedBox(height: 12),
                      _buildInlineSymbolSection(context),
                      const Divider(height: 32),

                      _buildSectionTitle(context, 'Category'),
                      const SizedBox(height: 12),
                      _buildCategoriesSection(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Actions Row
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_hasUnsavedChanges()) {
                              final shouldPop = await _showDiscardDialog(context);
                              if (shouldPop && context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurfaceVariant,
                            side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _isSaving ? null : _saveHabit,
                          style: FilledButton.styleFrom(
                            backgroundColor: _color ?? theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  widget.habitToEdit != null ? 'Save Changes' : 'Create Habit',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildLivePreview(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = _color ?? theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: HabitIcon(symbol: _symbol, size: 32, color: cardColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameCtrl.text.isEmpty ? 'New Routine' : _nameCtrl.text,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_notesCtrl.text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _notesCtrl.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
                if (_selectedCategory != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _selectedCategory!.categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedCategory!.getLocalizedName(context),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory!.categoryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicFields(BuildContext context) {
    return Column(
      children: [
        CustomFormField(
          controller: _nameCtrl,
          labelText: 'Name',
          hintText: 'e.g., Drink water, Gym workout',
          prefixIcon: Icons.edit_outlined,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        CustomFormField(
          controller: _notesCtrl,
          labelText: 'Notes',
          hintText: 'Add an optional description',
          prefixIcon: Icons.note_alt_outlined,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildHabitTypeSection(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.habitToEdit != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: _color ?? theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Habit type and tracking method cannot be changed once a habit is created to protect your existing logs.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
        const Text('What type of habit is this?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectorCard(
                context,
                title: 'Good Habit',
                subtitle: 'Build a new routine',
                isSelected: _isGoodHabit,
                icon: Icons.add_circle_outline,
                onTap: isEditing ? null : () => setState(() => _isGoodHabit = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSelectorCard(
                context,
                title: 'Bad Habit',
                subtitle: 'Avoid or relapse system',
                isSelected: !_isGoodHabit,
                icon: Icons.remove_circle_outline,
                onTap: isEditing ? null : () => setState(() => _isGoodHabit = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('How do you want to track it?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectorCard(
                context,
                title: 'Check-off',
                subtitle: 'Completed / Incomplete',
                isSelected: _isChecklist,
                icon: Icons.check_circle_outline,
                onTap: isEditing ? null : () => setState(() => _isChecklist = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSelectorCard(
                context,
                title: 'Quantity',
                subtitle: 'Goal & metrics value',
                isSelected: !_isChecklist,
                icon: Icons.speed_outlined,
                onTap: isEditing ? null : () => setState(() => _isChecklist = false),
              ),
            ),
          ],
        ),
        if (!_isChecklist) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: CustomFormField(
                  controller: _targetValueCtrl,
                  labelText: _isGoodHabit ? 'Target value' : 'Max limit',
                  hintText: 'e.g., 8.0',
                  prefixIcon: Icons.adjust_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<HabitUnit>(
                  value: _unit,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  items: HabitUnit.values.map((unit) {
                    return DropdownMenuItem<HabitUnit>(
                      value: unit,
                      child: Text(unit.name[0].toUpperCase() + unit.name.substring(1)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _unit = val);
                    }
                  },
                ),
              ),
            ],
          ),
          if (_unit == HabitUnit.custom) ...[
            const SizedBox(height: 12),
            CustomFormField(
              controller: _customUnitCtrl,
              labelText: 'Custom unit name',
              hintText: 'e.g., cups, miles',
              prefixIcon: Icons.text_fields,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSelectorCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final cardColor = _color ?? theme.colorScheme.primary;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? cardColor.withValues(alpha: 0.08) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? cardColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: isSelected ? cardColor : theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? cardColor : theme.colorScheme.onSurface)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyLabel(BuildContext context, HabitFrequency freq) {
    final l10n = L10n.of(context)!;
    switch (freq) {
      case HabitFrequency.daily:
        return l10n.daily;
      case HabitFrequency.weekdays:
        return l10n.weekdays;
      case HabitFrequency.weekends:
        return l10n.weekends;
      case HabitFrequency.customDays:
        return l10n.customDays;
      case HabitFrequency.xTimesPerWeek:
        return l10n.xTimesPerWeek;
      case HabitFrequency.xTimesPerMonth:
        return l10n.xTimesPerMonth;
    }
  }

  Widget _buildScheduleSection(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = _color ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: HabitFrequency.values.map((freq) {
            final isSelected = _frequency == freq;
            return ChoiceChip(
              showCheckmark: false,
              label: Text(_getFrequencyLabel(context, freq)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _frequency = freq);
                }
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
            );
          }).toList(),
        ),
        if (_frequency == HabitFrequency.customDays) ...[
          const SizedBox(height: 16),
          const Text('Repeat on specific weekdays:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dayNum = index + 1;
              final isSelected = _customDays.contains(dayNum);
              final label = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
              return ChoiceChip(
                showCheckmark: false,
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _customDays.add(dayNum);
                    } else {
                      _customDays.remove(dayNum);
                    }
                  });
                },
                selectedColor: activeColor.withValues(alpha: 0.15),
                backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? activeColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
              );
            }),
          ),
        ],
        if (_frequency == HabitFrequency.xTimesPerWeek || _frequency == HabitFrequency.xTimesPerMonth) ...[
          const SizedBox(height: 16),
          CustomFormField(
            controller: _targetFrequencyCtrl,
            labelText: 'Target frequency count',
            hintText: 'e.g., 3',
            prefixIcon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }

  Widget _buildColorSection(BuildContext context) {
    return HabitColorPickerField(
      selectedColor: _color,
      onColorSelected: (col) => setState(() => _color = col),
      presetColors: _presetColors,
    );
  }

  Widget _buildInlineSymbolSection(BuildContext context) {
    return HabitSymbolPickerField(
      selectedSymbol: _symbol,
      onSymbolSelected: (sym) => setState(() => _symbol = sym),
      themeColor: _color,
    );
  }

  void _showAddCategorySheet(BuildContext context) {
    final theme = Theme.of(context);
    final nameCtrl = TextEditingController();
    Color catColor = _presetColors.first;
    HabitSymbol catSymbol = HabitsIcon.getSymbol(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Create Category',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: nameCtrl,
                      labelText: 'Category Name',
                      hintText: 'e.g., Fitness, Reading',
                      prefixIcon: Icons.label_outline,
                    ),
                    const SizedBox(height: 16),
                    const Text('Category Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    HabitColorPickerField(
                      selectedColor: catColor,
                      onColorSelected: (col) => setSheetState(() => catColor = col),
                      presetColors: _presetColors,
                    ),
                    const SizedBox(height: 16),
                    const Text('Category Icon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    HabitSymbolPickerField(
                      selectedSymbol: catSymbol,
                      onSymbolSelected: (sym) => setSheetState(() => catSymbol = sym),
                      themeColor: catColor,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: catColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;

                          final newId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                          final newCategory = Category(
                            id: newId,
                            name: name,
                            color: catColor,
                            iconSymbol: catSymbol,
                          );

                          await HabitsRepository.instance.saveCategory(newCategory);

                          setState(() {
                            _categoriesList.add(newCategory);
                            _selectedCategory = newCategory;
                          });

                          if (context.mounted) {
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Create Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._categoriesList.map((category) {
              final isSelected = _selectedCategory?.id == category.id;
              final catColor = category.categoryColor;
              return ChoiceChip(
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HabitIcon(
                      symbol: category.getIcon(),
                      size: 14,
                      color: isSelected ? catColor : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.getLocalizedName(context),
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
                    _selectedCategory = selected ? category : null;
                  });
                },
                selectedColor: catColor.withValues(alpha: 0.15),
                backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? catColor.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.15),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 14),
              label: const Text('Add Category'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
              ),
              onPressed: () => _showAddCategorySheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _saveHabit() {
    if (_isSaving) return;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    final double? resolvedTargetValue;
    if (_isChecklist) {
      resolvedTargetValue = _isGoodHabit ? null : 0.0;
    } else {
      resolvedTargetValue = _targetValueCtrl.text.isNotEmpty ? double.tryParse(_targetValueCtrl.text) : null;
    }

    final habit = Habit(
      id: (widget.habitToEdit != null && !widget.isTemplate) ? widget.habitToEdit!.id : const Uuid().v4(),
      name: name,
      type: _isGoodHabit ? HabitType.good : HabitType.bad,
      trackingType: _isChecklist ? TrackingType.check : TrackingType.quantity,
      displayMode: widget.habitToEdit?.displayMode ?? ReportDisplay.rate,
      symbol: _symbol,
      color: _color,
      category: _selectedCategory,
      frequency: _frequency,
      customDays: _frequency == HabitFrequency.customDays ? _customDays : [],
      targetValue: resolvedTargetValue,
      unit: _unit,
      customUnit: _unit == HabitUnit.custom ? _customUnitCtrl.text.trim() : null,
      weekendDays: _weekendDays,
      goalType: _goalType,
      goalValue: _goalValueCtrl.text.isNotEmpty ? double.tryParse(_goalValueCtrl.text) : null,
      entries: widget.habitToEdit?.entries ?? [],
    );

    widget.onSave(habit);
  }
}
