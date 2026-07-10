import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class SettingsState {
  final bool showSuccessRate;
  final bool showCurrentStreak;
  final String language;

  SettingsState({
    required this.showSuccessRate,
    required this.showCurrentStreak,
    required this.language,
  });

  SettingsState copyWith({
    bool? showSuccessRate,
    bool? showCurrentStreak,
    String? language,
  }) {
    return SettingsState(
      showSuccessRate: showSuccessRate ?? this.showSuccessRate,
      showCurrentStreak: showCurrentStreak ?? this.showCurrentStreak,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
    : super(
        SettingsState(
          showSuccessRate: true,
          showCurrentStreak: true,
          language: 'English',
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final successRate = await SettingsService.getShowSuccessRate();
    final currentStreak = await SettingsService.getShowCurrentStreak();
    final lang = await SettingsService.getLanguage();
    state = SettingsState(
      showSuccessRate: successRate,
      showCurrentStreak: currentStreak,
      language: lang,
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
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);
