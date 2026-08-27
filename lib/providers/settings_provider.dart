import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show Locale;

class SettingsState {
  final bool showSuccessRate;
  final bool showCurrentStreak;
  final String language;
  final bool matchLauncherIcon;
  final String weekendDays;
  final String userName;
  final String occupation;
  final String biggestObstacle;
  final String selectedFont;

  SettingsState({
    required this.showSuccessRate,
    required this.showCurrentStreak,
    required this.language,
    required this.matchLauncherIcon,
    required this.weekendDays,
    required this.userName,
    required this.occupation,
    required this.biggestObstacle,
    required this.selectedFont,
  });

  Locale get locale => Locale(language);

  SettingsState copyWith({
    bool? showSuccessRate,
    bool? showCurrentStreak,
    String? language,
    bool? matchLauncherIcon,
    String? weekendDays,
    String? userName,
    String? occupation,
    String? biggestObstacle,
    String? selectedFont,
  }) {
    return SettingsState(
      showSuccessRate: showSuccessRate ?? this.showSuccessRate,
      showCurrentStreak: showCurrentStreak ?? this.showCurrentStreak,
      language: language ?? this.language,
      matchLauncherIcon: matchLauncherIcon ?? this.matchLauncherIcon,
      weekendDays: weekendDays ?? this.weekendDays,
      userName: userName ?? this.userName,
      occupation: occupation ?? this.occupation,
      biggestObstacle: biggestObstacle ?? this.biggestObstacle,
      selectedFont: selectedFont ?? this.selectedFont,
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
          language: 'en',
          matchLauncherIcon: (!kIsWeb && defaultTargetPlatform == TargetPlatform.android),
          weekendDays: 'Saturday & Sunday',
          userName: '',
          occupation: '',
          biggestObstacle: '',
          selectedFont: 'Outfit',
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final successRate = await SettingsService.getShowSuccessRate();
    final currentStreak = await SettingsService.getShowCurrentStreak();
    final lang = await SettingsService.getLanguage();
    final matchIcon = await SettingsService.getMatchLauncherIcon();
    final weekend = await SettingsService.getWeekendDays();
    final name = await SettingsService.getUserName();
    final occ = await SettingsService.getOccupation();
    final obstacle = await SettingsService.getBiggestObstacle();
    final fontName = await SettingsService.getSelectedFont();
    state = SettingsState(
      showSuccessRate: successRate,
      showCurrentStreak: currentStreak,
      language: lang,
      matchLauncherIcon: matchIcon,
      weekendDays: weekend,
      userName: name,
      occupation: occ,
      biggestObstacle: obstacle,
      selectedFont: fontName,
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

  Future<void> changeWeekendDays(String days) async {
    await SettingsService.setWeekendDays(days);
    state = state.copyWith(weekendDays: days);
  }


  Future<void> setUserName(String name) async {
    await SettingsService.setUserName(name);
    state = state.copyWith(userName: name);
  }

  Future<void> setOccupation(String value) async {
    await SettingsService.setOccupation(value);
    state = state.copyWith(occupation: value);
  }

  Future<void> setBiggestObstacle(String value) async {
    await SettingsService.setBiggestObstacle(value);
    state = state.copyWith(biggestObstacle: value);
  }

  Future<void> changeFont(String fontName) async {
    await SettingsService.setSelectedFont(fontName);
    state = state.copyWith(selectedFont: fontName);
  }

  Future<void> toggleMatchLauncherIcon(bool value) async {
    await SettingsService.setMatchLauncherIcon(value);
    state = state.copyWith(matchLauncherIcon: value);
    if (value) {
      final themeName = ref.read(themeProvider).themeName;
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final String targetIcon = themeName.toLowerCase() == 'system' ? 'Emerald' : themeName;
          await const MethodChannel('dev.wisamidris77.flux/launcher_icon')
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
