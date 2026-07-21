import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SettingsState {
  final bool showSuccessRate;
  final bool showCurrentStreak;
  final String language;
  final bool matchLauncherIcon;

  SettingsState({
    required this.showSuccessRate,
    required this.showCurrentStreak,
    required this.language,
    required this.matchLauncherIcon,
  });

  SettingsState copyWith({
    bool? showSuccessRate,
    bool? showCurrentStreak,
    String? language,
    bool? matchLauncherIcon,
  }) {
    return SettingsState(
      showSuccessRate: showSuccessRate ?? this.showSuccessRate,
      showCurrentStreak: showCurrentStreak ?? this.showCurrentStreak,
      language: language ?? this.language,
      matchLauncherIcon: matchLauncherIcon ?? this.matchLauncherIcon,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref)
    : super(
        SettingsState(
          showSuccessRate: true,
          showCurrentStreak: true,
          language: 'English',
          matchLauncherIcon: (!kIsWeb && defaultTargetPlatform == TargetPlatform.android),
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final successRate = await SettingsService.getShowSuccessRate();
    final currentStreak = await SettingsService.getShowCurrentStreak();
    final lang = await SettingsService.getLanguage();
    final matchIcon = await SettingsService.getMatchLauncherIcon();
    state = SettingsState(
      showSuccessRate: successRate,
      showCurrentStreak: currentStreak,
      language: lang,
      matchLauncherIcon: matchIcon,
    );
  }

  Future<void> toggleShowSuccessRate(bool value) async {
    await SettingsService.setShowSuccessRate(value);
    state = state.copyWith(showSuccessRate: value);
  }

  Future<void> toggleShowCurrentStreak(bool value) async {
    await SettingsService.setShowCurrentStreak(value);
    state = state.copyWith(showCurrentStreak: value);
  }

  Future<void> changeLanguage(String language) async {
    await SettingsService.setLanguage(language);
    state = state.copyWith(language: language);
  }

  Future<void> toggleMatchLauncherIcon(bool value) async {
    await SettingsService.setMatchLauncherIcon(value);
    state = state.copyWith(matchLauncherIcon: value);
    if (value) {
      final themeName = ref.read(themeProvider).themeName;
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final String targetIcon = themeName.toLowerCase() == 'system' ? 'Emerald' : themeName;
          await const MethodChannel('com.wisamidris.flux/launcher_icon')
              .invokeMethod('changeIcon', {'iconName': targetIcon});
        } catch (e) {
          // Ignore error in non-android platforms or if fails
        }
      }
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier(ref);
  },
);
