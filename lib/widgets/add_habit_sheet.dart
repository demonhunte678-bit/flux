import 'package:flutter/material.dart';
import 'package:flux/index.dart';

class AddHabitSheet extends StatefulWidget {
  final Function(Habit) onSave;
  final List<String> existingCategories;

  const AddHabitSheet({
    super.key,
    required this.onSave,
    this.existingCategories = const [],
  });

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet>
    with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _targetValueCtrl = TextEditingController();
  final _targetFrequencyCtrl = TextEditingController();
  final _customUnitCtrl = TextEditingController();

  HabitType _type = HabitType.DoneBased;
  IconData _icon = Icons.star;
  Color? _color;
  HabitFrequency _frequency = HabitFrequency.Daily;
  HabitUnit _unit = HabitUnit.Count;
  final List<int> _customDays = [];
  String? _selectedCategory;

  late TabController _tabController;

  final _icons = [
    Icons.star,
    Icons.fitness_center,
    Icons.book,
    Icons.brush,
    Icons.run_circle,
    Icons.water_drop,
    Icons.food_bank,
    Icons.bed,
    Icons.emoji_emotions,
    Icons.self_improvement,
    Icons.music_note,
    Icons.code,
    Icons.sports_basketball,
    Icons.smoking_rooms,
    Icons.local_drink,
    Icons.monitor,
    Icons.health_and_safety,
    Icons.directions_run,
    Icons.dark_mode,
    Icons.light_mode,
    Icons.pets,
    Icons.nature,
    Icons.volunteer_activism,
    Icons.school,
    Icons.alarm,
    Icons.piano,
    Icons.savings,
    Icons.attach_money,
  ];

  final List<Color> _colorOptions = [
    const Color(0xFF1DB954),
    const Color(0xFF2196F3),
    const Color(0xFFF44336),
    const Color(0xFFFF9800),
    const Color(0xFF9C27B0),
    const Color(0xFF795548),
    const Color(0xFF607D8B),
    const Color(0xFF009688),
    const Color(0xFFE91E63),
    const Color(0xFF4CAF50),
    const Color(0xFF673AB7),
    const Color(0xFFFF5722),
  ];

  final List<String> _weekDays = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDefaults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    _categoryCtrl.dispose();
    _targetValueCtrl.dispose();
    _targetFrequencyCtrl.dispose();
    _customUnitCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDefaults() async {
    _type = await SettingsService.getDefaultHabitType();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final themeColor = _color ?? baseTheme.colorScheme.primary;
    final themeData = (() {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: themeColor,
        brightness: baseTheme.brightness,
      );
      return baseTheme.copyWith(
        primaryColor: themeColor,
        scaffoldBackgroundColor: colorScheme.surface,
        colorScheme: colorScheme,
      );
    })();

    return Theme(
      data: themeData,
      child: Builder(
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'New Habit',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Basic'),
                    Tab(text: 'Schedule'),
                    Tab(text: 'Details'),
                    Tab(text: 'Style'),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBasicTab(context),
                      _buildScheduleTab(context),
                      _buildDetailsTab(context),
                      _buildStyleTab(context),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.tonal(
                    onPressed: _createHabit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Habit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildBasicTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(context),
          const SizedBox(height: 16),
          _buildNotesField(context),
          const SizedBox(height: 16),
          _buildCategoryField(context),
          const SizedBox(height: 24),
          Text(
            'Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<HabitType>(
              segments: const [
                ButtonSegment<HabitType>(
                  value: HabitType.DoneBased,
                  label: Text('Check'),
                  icon: Icon(Icons.check_circle_outline),
                ),
                ButtonSegment<HabitType>(
                  value: HabitType.SuccessBased,
                  label: Text('Achieve'),
                  icon: Icon(Icons.emoji_events_outlined),
                ),
                ButtonSegment<HabitType>(
                  value: HabitType.FailBased,
                  label: Text('Avoid'),
                  icon: Icon(Icons.block_outlined),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<HabitType> selected) {
                setState(() {
                  _type = selected.first;
                });
              },
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                selectedForegroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequency',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          _buildFrequencySelector(context),
          if (_frequency == HabitFrequency.CustomDays) ...[
            const SizedBox(height: 20),
            _buildCustomDaysSelector(context),
          ],
          if (_frequency == HabitFrequency.XTimesPerWeek ||
              _frequency == HabitFrequency.XTimesPerMonth) ...[
            const SizedBox(height: 20),
            _buildTargetFrequencyField(context),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unit of Measurement',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          _buildUnitSelector(context),
          if (_unit == HabitUnit.Custom) ...[
            const SizedBox(height: 16),
            CustomFormField(
              controller: _customUnitCtrl,
              labelText: 'Custom Unit Name',
              hintText: 'e.g., cups, sets, chapters',
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Target Value (Optional)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          CustomFormField(
            controller: _targetValueCtrl,
            labelText: _getTargetLabel(),
            hintText: _getTargetHint(),
            suffixText: _getUnitName(),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Icon',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          _buildIconSelector(context),
          const SizedBox(height: 24),
          Text(
            'Color Theme',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          _buildColorSelector(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return CustomFormField(
      controller: _nameCtrl,
      labelText: 'Name',
      hintText: 'e.g., Read Books, Workout',
      prefixIcon: Icons.edit,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return CustomFormField(
      controller: _notesCtrl,
      labelText: 'Notes',
      hintText: 'Optional description or notes',
      prefixIcon: Icons.note_alt_outlined,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 10),
        if (widget.existingCategories.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.existingCategories
                .map(
                  (category) => ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                        _categoryCtrl.text = selected ? category : '';
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black87,
                      fontWeight: _selectedCategory == category
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        CustomFormField(
          controller: _categoryCtrl,
          labelText: 'New Category (Optional)',
          hintText: 'e.g., Fitness, Learning, Health',
          prefixIcon: Icons.category_outlined,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() => _selectedCategory = null);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFrequencySelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: HabitFrequency.values.map((frequency) {
        final isSelected = _frequency == frequency;
        return ChoiceChip(
          label: Text(_getFrequencyLabel(frequency)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _frequency = frequency;
                if (frequency != HabitFrequency.CustomDays) {
                  _customDays.clear();
                }
              });
            }
          },
          selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          checkmarkColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomDaysSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Days',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List.generate(7, (index) {
            final isSelected = _customDays.contains(index);
            return FilterChip(
              label: Text(_weekDays[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _customDays.add(index);
                  } else {
                    _customDays.remove(index);
                  }
                });
              },
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTargetFrequencyField(BuildContext context) {
    return CustomFormField(
      controller: _targetFrequencyCtrl,
      labelText: _frequency == HabitFrequency.XTimesPerWeek
          ? 'Times per week'
          : 'Times per month',
      hintText: 'e.g., 3',
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildUnitSelector(BuildContext context) {
    return DropdownButtonFormField<HabitUnit>(
      value: _unit,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: HabitUnit.values.map((unit) {
        return DropdownMenuItem(
          value: unit,
          child: Text(_getUnitDisplayName(unit)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _unit = value!;
        });
      },
    );
  }

  Widget _buildIconSelector(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          final icon = _icons[index];
          final isSelected = _icon == icon;

          return IconButton.filledTonal(
            onPressed: () => setState(() => _icon = icon),
            isSelected: isSelected,
            icon: Icon(icon, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    final themePrimary = Theme.of(context).colorScheme.primary;
    final List<Color?> colorOptionsWithNull = [null, ..._colorOptions];

    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorOptionsWithNull.length,
        itemBuilder: (context, index) {
          final color = colorOptionsWithNull[index];
          final isSelected = (color == null && _color == null) ||
              (color != null && _color != null && _color!.toARGB32() == color.toARGB32());
          final displayColor = color ?? themePrimary;

          return GestureDetector(
            onTap: () => setState(() => _color = color),
            child: Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: displayColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: displayColor.withValues(alpha: 0.3),
                    blurRadius: isSelected ? 6 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: displayColor.computeLuminance() < 0.5
                          ? Colors.white
                          : Colors.black87,
                      size: 16,
                    )
                  : (color == null
                      ? Icon(
                          Icons.palette_outlined,
                          color: displayColor.computeLuminance() < 0.5
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.black54,
                          size: 16,
                        )
                      : null),
            ),
          );
        },
      ),
    );
  }

  String _getFrequencyLabel(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.Daily:
        return 'Daily';
      case HabitFrequency.Weekdays:
        return 'Weekdays';
      case HabitFrequency.Weekends:
        return 'Weekends';
      case HabitFrequency.CustomDays:
        return 'Custom Days';
      case HabitFrequency.XTimesPerWeek:
        return 'X / Week';
      case HabitFrequency.XTimesPerMonth:
        return 'X / Month';
    }
  }

  String _getUnitDisplayName(HabitUnit unit) {
    switch (unit) {
      case HabitUnit.Count:
        return 'Count/Times';
      case HabitUnit.Minutes:
        return 'Minutes';
      case HabitUnit.Hours:
        return 'Hours';
      case HabitUnit.Pages:
        return 'Pages';
      case HabitUnit.Kilometers:
        return 'Kilometers';
      case HabitUnit.Miles:
        return 'Miles';
      case HabitUnit.Grams:
        return 'Grams';
      case HabitUnit.Pounds:
        return 'Pounds';
      case HabitUnit.Dollars:
        return 'Dollars';
      case HabitUnit.Custom:
        return 'Custom';
    }
  }

  String _getTargetLabel() {
    switch (_type) {
      case HabitType.FailBased:
        return 'Maximum Limit';
      case HabitType.SuccessBased:
        return 'Daily Target';
      case HabitType.DoneBased:
        return 'Target Amount';
    }
  }

  String _getTargetHint() {
    switch (_type) {
      case HabitType.FailBased:
        return 'e.g., 2 (max 2 failures)';
      case HabitType.SuccessBased:
        return 'e.g., 30 (read 30 pages)';
      case HabitType.DoneBased:
        return 'e.g., 10 (meditate 10 minutes)';
    }
  }

  String _getUnitName() {
    if (_unit == HabitUnit.Custom && _customUnitCtrl.text.isNotEmpty) {
      return _customUnitCtrl.text;
    }
    return _getUnitDisplayName(_unit);
  }

  void _createHabit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final category = _selectedCategory ??
        (_categoryCtrl.text.trim().isNotEmpty
            ? _categoryCtrl.text.trim()
            : null);

    final targetValue = _targetValueCtrl.text.isNotEmpty
        ? double.tryParse(_targetValueCtrl.text)
        : null;

    final targetFrequency = (_frequency == HabitFrequency.XTimesPerWeek ||
            _frequency == HabitFrequency.XTimesPerMonth) &&
        _targetFrequencyCtrl.text.isNotEmpty
        ? int.tryParse(_targetFrequencyCtrl.text)
        : null;

    final customUnit = _unit == HabitUnit.Custom
        ? _customUnitCtrl.text.trim()
        : null;

    widget.onSave(
      Habit(
        name: name,
        type: _type,
        icon: _icon,
        color: _color,
        notes: _notesCtrl.text.trim().isNotEmpty
            ? _notesCtrl.text.trim()
            : null,
        category: category,
        frequency: _frequency,
        customDays: _frequency == HabitFrequency.CustomDays ? _customDays : [],
        targetFrequency: targetFrequency,
        targetValue: targetValue,
        unit: _unit,
        customUnit: customUnit,
      ),
    );
  }
}
