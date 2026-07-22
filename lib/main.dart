import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  KeyboardService().initialize();
  final isFirstLaunch = await SettingsService.isFirstLaunch();
  await BackupService.performDailyAutoBackupIfEnabled();

  runApp(ProviderScope(child: HabitTrackerApp(isFirstLaunch: isFirstLaunch)));
}

class HabitTrackerApp extends ConsumerWidget {
  final bool isFirstLaunch;

  const HabitTrackerApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flux',
      theme: ThemeService.createTheme(
        themeName: themeState.themeName,
        isDarkMode: false,
      ),
      darkTheme: ThemeService.createTheme(
        themeName: themeState.themeName,
        isDarkMode: true,
      ),
      themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: isFirstLaunch
          ? OnboardingPage(
              onComplete: () {
                _completeOnboarding();
              },
            )
          : const AppShell(),
    );
  }

  void _completeOnboarding() async {
    await SettingsService.setFirstLaunch(false);
    await SettingsService.setOnboardingCompleted(true);
  }
}
