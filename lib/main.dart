import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:flux/index.dart';import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
    
  KeyboardService().initialize();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;
  
  runApp(ProviderScope(
    child: HabitTrackerApp(isFirstLaunch: isFirstLaunch),
  ));
}

class HabitTrackerApp extends ConsumerWidget {
  final bool isFirstLaunch;

  const HabitTrackerApp({
    super.key,
    required this.isFirstLaunch,
  });

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
              onComplete: (themePreference) {
                if (themePreference != null) {
                  ref.read(themeProvider.notifier).selectTheme(themePreference);
                }
                _completeOnboarding(context);
              },
            )
          : const HomePage(),
    );
  }

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }
}
