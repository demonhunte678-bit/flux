import 'package:flutter/material.dart';
import 'package:flux/core/services/settings_service.dart';
import 'package:flux/core/services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;
  String _language = 'English';
  bool _showSuccessRate = true;
  bool _showCurrentStreak = true;
  String _selectedTheme = 'Green';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    _language = await SettingsService.getLanguage();
    _showSuccessRate = await SettingsService.getShowSuccessRate();
    _showCurrentStreak = await SettingsService.getShowCurrentStreak();
    _selectedTheme = await ThemeService.getCurrentTheme();
    _isDarkMode = await SettingsService.isDarkMode();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Appearance',
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Toggle dark or light theme',
                value: _isDarkMode,
                onChanged: (value) async {
                  setState(() => _isDarkMode = value);
                  await SettingsService.setDarkMode(value);
                  if (ThemeService.onThemeChanged != null) {
                    ThemeService.onThemeChanged!();
                  }
                },
                icon: _isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildColorGrid(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Display Preferences',
            children: [
              _buildSwitchTile(
                title: 'Show Success Rate',
                subtitle: 'Show percentage rates in the app',
                value: _showSuccessRate,
                onChanged: (value) async {
                  setState(() => _showSuccessRate = value);
                  await SettingsService.setShowSuccessRate(value);
                },
                icon: Icons.percent_rounded,
              ),
              _buildSwitchTile(
                title: 'Show Streak Days',
                subtitle: 'Show daily streaks in the app',
                value: _showCurrentStreak,
                onChanged: (value) async {
                  setState(() => _showCurrentStreak = value);
                  await SettingsService.setShowCurrentStreak(value);
                },
                icon: Icons.local_fire_department_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'General',
            children: [
              _buildNavigationTile(
                title: 'Language',
                subtitle: _language,
                icon: Icons.language_outlined,
                onTap: _showLanguageSelector,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isLast = index == children.length - 1;
              return Column(
                children: [
                  child,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildColorGrid() {
    final colors = ThemeService.accentColors;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = colors[index];
          final color = item.color;
          final name = item.colorName;
          final isSelected = _selectedTheme.toLowerCase() == name.toLowerCase();

          return GestureDetector(
            onTap: () async {
              setState(() {
                _selectedTheme = name;
              });
              await ThemeService.setCurrentTheme(name);
              if (ThemeService.onThemeChanged != null) {
                ThemeService.onThemeChanged!();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (_isDarkMode ? Colors.white : Colors.black87)
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: isDarkColor(color) ? Colors.white : Colors.black87,
                      size: 16,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  bool isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Arabic'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _language,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _language = value);
                  SettingsService.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
