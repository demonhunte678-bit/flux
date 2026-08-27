import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Flux'**
  String get appName;

  /// No description provided for @todayTab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTab;

  /// No description provided for @dashboardTab.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTab;

  /// No description provided for @analyticsTab.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @editEntryNotesValue.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry Notes/Value'**
  String get editEntryNotesValue;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit Habit'**
  String get editHabit;

  /// No description provided for @pauseHabit.
  ///
  /// In en, this message translates to:
  /// **'Pause Habit'**
  String get pauseHabit;

  /// No description provided for @resumeHabit.
  ///
  /// In en, this message translates to:
  /// **'Resume Habit'**
  String get resumeHabit;

  /// No description provided for @archiveHabit.
  ///
  /// In en, this message translates to:
  /// **'Archive Habit'**
  String get archiveHabit;

  /// No description provided for @restoreHabit.
  ///
  /// In en, this message translates to:
  /// **'Restore Habit'**
  String get restoreHabit;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @areYouSureDeleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete \"{habitName}\"? This action cannot be undone.'**
  String areYouSureDeleteHabit(String habitName);

  /// No description provided for @areYouSureDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?'**
  String get areYouSureDeleteEntry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editHabitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change name, schedule, limit/goal, icon, and colors'**
  String get editHabitSubtitle;

  /// No description provided for @pauseHabitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Temporarily stop tracking without affecting streaks'**
  String get pauseHabitSubtitle;

  /// No description provided for @resumeHabitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue tracking this habit'**
  String get resumeHabitSubtitle;

  /// No description provided for @archiveHabitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide it from the main list but keep the data'**
  String get archiveHabitSubtitle;

  /// No description provided for @restoreHabitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring it back to the active list'**
  String get restoreHabitSubtitle;

  /// No description provided for @deletePermanentlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone'**
  String get deletePermanentlySubtitle;

  /// No description provided for @manageHabit.
  ///
  /// In en, this message translates to:
  /// **'Manage Habit'**
  String get manageHabit;

  /// No description provided for @whatWouldYouDoWith.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do with \"{habitName}\"?'**
  String whatWouldYouDoWith(String habitName);

  /// No description provided for @failedToExportReport.
  ///
  /// In en, this message translates to:
  /// **'Failed to export report: {error}'**
  String failedToExportReport(String error);

  /// No description provided for @habitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Habit not found or deleted.'**
  String get habitNotFound;

  /// No description provided for @exportCsvReport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV Report'**
  String get exportCsvReport;

  /// No description provided for @historyLogs.
  ///
  /// In en, this message translates to:
  /// **'History Logs'**
  String get historyLogs;

  /// No description provided for @frequencyAndUnit.
  ///
  /// In en, this message translates to:
  /// **'Frequency: {frequency} • Unit: {unit}'**
  String frequencyAndUnit(String frequency, String unit);

  /// No description provided for @slipUpStreakBanner.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let one slip-up stop you from reaching your {streakVal}-day streak goal!'**
  String slipUpStreakBanner(String streakVal);

  /// No description provided for @slipUpSuccessBanner.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let one slip-up stop you from reaching your {successVal}% success rate goal!'**
  String slipUpSuccessBanner(String successVal);

  /// No description provided for @slipUpGenericBanner.
  ///
  /// In en, this message translates to:
  /// **'1 slip-up doesn\'t erase your progress. Let\'s start fresh and make today a win!'**
  String get slipUpGenericBanner;

  /// No description provided for @youCanGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can get it!'**
  String get youCanGetIt;

  /// No description provided for @noActiveGoalSet.
  ///
  /// In en, this message translates to:
  /// **'No Active Goal Set'**
  String get noActiveGoalSet;

  /// No description provided for @noActiveGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap here to set a target streak or success rate to stay motivated!'**
  String get noActiveGoalSubtitle;

  /// No description provided for @achieved.
  ///
  /// In en, this message translates to:
  /// **'Achieved!'**
  String get achieved;

  /// No description provided for @reachedPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% reached'**
  String reachedPercent(String percent);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(String days);

  /// No description provided for @completionsGoal.
  ///
  /// In en, this message translates to:
  /// **'Completions Goal: {value} times'**
  String completionsGoal(String value);

  /// No description provided for @streakGoal.
  ///
  /// In en, this message translates to:
  /// **'Streak Goal: {value} Days'**
  String streakGoal(String value);

  /// No description provided for @successRateGoal.
  ///
  /// In en, this message translates to:
  /// **'Success Rate Goal: {value}%'**
  String successRateGoal(String value);

  /// No description provided for @progressLabelDays.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} days'**
  String progressLabelDays(String current, String target);

  /// No description provided for @progressLabelPercentage.
  ///
  /// In en, this message translates to:
  /// **'{current}% of {target}%'**
  String progressLabelPercentage(String current, String target);

  /// No description provided for @progressLabelCompletions.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} completions'**
  String progressLabelCompletions(String current, String target);

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @valueTrends.
  ///
  /// In en, this message translates to:
  /// **'Value Trends'**
  String get valueTrends;

  /// No description provided for @values.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get values;

  /// No description provided for @successRateTrends.
  ///
  /// In en, this message translates to:
  /// **'Success Rate Trends'**
  String get successRateTrends;

  /// No description provided for @successRatePercent.
  ///
  /// In en, this message translates to:
  /// **'Success Rate (%)'**
  String get successRatePercent;

  /// No description provided for @streakTrends.
  ///
  /// In en, this message translates to:
  /// **'Streak Trends'**
  String get streakTrends;

  /// No description provided for @streaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get streaks;

  /// No description provided for @currentStreaks.
  ///
  /// In en, this message translates to:
  /// **'Current Streaks'**
  String get currentStreaks;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysLabel;

  /// No description provided for @distribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get distribution;

  /// No description provided for @heatmap.
  ///
  /// In en, this message translates to:
  /// **'Heatmap'**
  String get heatmap;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get last90Days;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @activityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Activity Heatmap'**
  String get activityHeatmap;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @toggleDarkLight.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark or light theme'**
  String get toggleDarkLight;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @matchLauncherIcon.
  ///
  /// In en, this message translates to:
  /// **'Match Launcher Icon'**
  String get matchLauncherIcon;

  /// No description provided for @matchLauncherIconSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync home screen icon with theme color'**
  String get matchLauncherIconSubtitle;

  /// No description provided for @displayPreferences.
  ///
  /// In en, this message translates to:
  /// **'Display Preferences'**
  String get displayPreferences;

  /// No description provided for @showSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Show Success Rate'**
  String get showSuccessRate;

  /// No description provided for @showSuccessRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show percentage rates in the app'**
  String get showSuccessRateSubtitle;

  /// No description provided for @showStreakDays.
  ///
  /// In en, this message translates to:
  /// **'Show Streak Days'**
  String get showStreakDays;

  /// No description provided for @showStreakDaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show daily streaks in the app'**
  String get showStreakDaysSubtitle;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export or import your habit database'**
  String get backupRestoreSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @backupStorageFolder.
  ///
  /// In en, this message translates to:
  /// **'Backup Storage Folder'**
  String get backupStorageFolder;

  /// No description provided for @noFolderSet.
  ///
  /// In en, this message translates to:
  /// **'No folder set (e.g. create and pick \"flux backups\" outside Flux)'**
  String get noFolderSet;

  /// No description provided for @selectBackupFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Backup Folder'**
  String get selectBackupFolder;

  /// No description provided for @changeFolder.
  ///
  /// In en, this message translates to:
  /// **'Change Folder'**
  String get changeFolder;

  /// No description provided for @autoDailyBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic Daily Backup'**
  String get autoDailyBackup;

  /// No description provided for @autoDailyBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Creates a backup file automatically when you open Flux once per day.'**
  String get autoDailyBackupSubtitle;

  /// No description provided for @exportNow.
  ///
  /// In en, this message translates to:
  /// **'Export Now'**
  String get exportNow;

  /// No description provided for @browseFile.
  ///
  /// In en, this message translates to:
  /// **'Browse File'**
  String get browseFile;

  /// No description provided for @availableBackups.
  ///
  /// In en, this message translates to:
  /// **'Available Backups'**
  String get availableBackups;

  /// No description provided for @noBackupFound.
  ///
  /// In en, this message translates to:
  /// **'No backup files found in this folder.'**
  String get noBackupFound;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Database?'**
  String get restoreDatabaseTitle;

  /// No description provided for @restoreDatabaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will restore all your habits and entries from this backup file. Current data will be replaced.'**
  String get restoreDatabaseConfirm;

  /// No description provided for @restoreDatabaseOverwrite.
  ///
  /// In en, this message translates to:
  /// **'This will overwrite all your current habits and entries with the selected backup file. This action cannot be undone.'**
  String get restoreDatabaseOverwrite;

  /// No description provided for @backupFolderSet.
  ///
  /// In en, this message translates to:
  /// **'Backup folder set to: {path}'**
  String backupFolderSet(String path);

  /// No description provided for @backupExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup exported successfully!'**
  String get backupExportedSuccessfully;

  /// No description provided for @databaseImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Database imported successfully!'**
  String get databaseImportedSuccessfully;

  /// No description provided for @exportFailedLocation.
  ///
  /// In en, this message translates to:
  /// **'Export failed: Location not chosen.'**
  String get exportFailedLocation;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @todaySuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Success Rate'**
  String get todaySuccessRate;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @bestStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} Days'**
  String bestStreakDays(String days);

  /// No description provided for @bestStreakHabitOn.
  ///
  /// In en, this message translates to:
  /// **'on {habitName}'**
  String bestStreakHabitOn(String habitName);

  /// No description provided for @dailySuccessHistory.
  ///
  /// In en, this message translates to:
  /// **'Daily Success Rate History'**
  String get dailySuccessHistory;

  /// No description provided for @errorLoadingHabits.
  ///
  /// In en, this message translates to:
  /// **'Error loading habits: {error}'**
  String errorLoadingHabits(String error);

  /// No description provided for @onboardSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Flux Setup'**
  String get onboardSetupTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @identityStepName.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identityStepName;

  /// No description provided for @questStepName.
  ///
  /// In en, this message translates to:
  /// **'Change Goal'**
  String get questStepName;

  /// No description provided for @welcomeStepName.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeStepName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flux'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to get started with tracking your habits.'**
  String get welcomeSubtitle;

  /// No description provided for @guidedSetup.
  ///
  /// In en, this message translates to:
  /// **'Guided Setup'**
  String get guidedSetup;

  /// No description provided for @guidedSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Answer 5 quick questions to customize your recommendation style'**
  String get guidedSetupDesc;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Import your existing database and history logs'**
  String get restoreBackupDesc;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// No description provided for @quickStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Skip setup entirely and create your habits from scratch'**
  String get quickStartDesc;

  /// No description provided for @namePrompt.
  ///
  /// In en, this message translates to:
  /// **'What is your name? (Optional)'**
  String get namePrompt;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name...'**
  String get nameHint;

  /// No description provided for @occupationPrompt.
  ///
  /// In en, this message translates to:
  /// **'What is your daily occupation? (Optional)'**
  String get occupationPrompt;

  /// No description provided for @questTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you trying to change?'**
  String get questTitle;

  /// No description provided for @questSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This determines your recommendation style.'**
  String get questSubtitle;

  /// No description provided for @breakHabits.
  ///
  /// In en, this message translates to:
  /// **'Break Bad Habits'**
  String get breakHabits;

  /// No description provided for @breakHabitsDesc.
  ///
  /// In en, this message translates to:
  /// **'I want to avoid triggers, limit distractions, or stop bad routines.'**
  String get breakHabitsDesc;

  /// No description provided for @createHabits.
  ///
  /// In en, this message translates to:
  /// **'Creating Habits'**
  String get createHabits;

  /// No description provided for @createHabitsDesc.
  ///
  /// In en, this message translates to:
  /// **'I want to establish new daily activities, positive routines, or targets.'**
  String get createHabitsDesc;

  /// No description provided for @bothHabits.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Know / Both'**
  String get bothHabits;

  /// No description provided for @bothHabitsDesc.
  ///
  /// In en, this message translates to:
  /// **'I want to build a mix of positive additions and avoid slips.'**
  String get bothHabitsDesc;

  /// No description provided for @areasTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you trying to change in your life?'**
  String get areasTitle;

  /// No description provided for @areasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the focus areas that matter to you right now.'**
  String get areasSubtitle;

  /// No description provided for @areasStepName.
  ///
  /// In en, this message translates to:
  /// **'Focus Areas'**
  String get areasStepName;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Experience & Tracking Style'**
  String get preferencesTitle;

  /// No description provided for @preferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize how you track your habits.'**
  String get preferencesSubtitle;

  /// No description provided for @preferencesStepName.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesStepName;

  /// No description provided for @starterPackTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your starting habits'**
  String get starterPackTitle;

  /// No description provided for @starterPackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Starting small is the secret to 90-day consistency. Choose 1 to 3 habits.'**
  String get starterPackSubtitle;

  /// No description provided for @starterPackStepName.
  ///
  /// In en, this message translates to:
  /// **'Starter Habits'**
  String get starterPackStepName;

  /// No description provided for @starterHabitsWarn.
  ///
  /// In en, this message translates to:
  /// **'Starting small (1-3 habits) dramatically increases your chance of long-term success!'**
  String get starterHabitsWarn;

  /// No description provided for @generatingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Generating custom suggestions...'**
  String get generatingSuggestions;

  /// No description provided for @completeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Journey Begins'**
  String get completeTitle;

  /// No description provided for @completeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Imagine opening Flux 100 days from now and seeing every single promise you\'ve kept.'**
  String get completeSubtitle;

  /// No description provided for @completeStepName.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeStepName;

  /// No description provided for @completeRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Your Personalized Roadmap:'**
  String get completeRoadmap;

  /// No description provided for @completeName.
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String completeName(String name);

  /// No description provided for @completeOccupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation: {occupation}'**
  String completeOccupation(String occupation);

  /// No description provided for @completeFocusAreas.
  ///
  /// In en, this message translates to:
  /// **'Focus areas: {areas}'**
  String completeFocusAreas(String areas);

  /// No description provided for @completeSeeding.
  ///
  /// In en, this message translates to:
  /// **'Seeding: {count} starter habits'**
  String completeSeeding(String count);

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @aLittle.
  ///
  /// In en, this message translates to:
  /// **'A little'**
  String get aLittle;

  /// No description provided for @regularly.
  ///
  /// In en, this message translates to:
  /// **'Regularly'**
  String get regularly;

  /// No description provided for @trackedBeforePrompt.
  ///
  /// In en, this message translates to:
  /// **'Have you tracked habits before?'**
  String get trackedBeforePrompt;

  /// No description provided for @measureProgressPrompt.
  ///
  /// In en, this message translates to:
  /// **'How do you prefer to measure progress?'**
  String get measureProgressPrompt;

  /// No description provided for @streaksFocus.
  ///
  /// In en, this message translates to:
  /// **'Streaks Focus'**
  String get streaksFocus;

  /// No description provided for @streaksFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'Counts consecutive days you keep the habit alive.'**
  String get streaksFocusDesc;

  /// No description provided for @percentagesFocus.
  ///
  /// In en, this message translates to:
  /// **'Percentages Focus'**
  String get percentagesFocus;

  /// No description provided for @percentagesFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows your overall consistency percentage over time.'**
  String get percentagesFocusDesc;

  /// No description provided for @newHabit.
  ///
  /// In en, this message translates to:
  /// **'New Habit'**
  String get newHabit;

  /// No description provided for @basicTab.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basicTab;

  /// No description provided for @scheduleTab.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTab;

  /// No description provided for @detailsTab.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTab;

  /// No description provided for @styleTab.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get styleTab;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @createHabit.
  ///
  /// In en, this message translates to:
  /// **'Create Habit'**
  String get createHabit;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @checkDoneBased.
  ///
  /// In en, this message translates to:
  /// **'Check (Done-based)'**
  String get checkDoneBased;

  /// No description provided for @achieveSuccessBased.
  ///
  /// In en, this message translates to:
  /// **'Achieve (Success-based)'**
  String get achieveSuccessBased;

  /// No description provided for @avoidFailBased.
  ///
  /// In en, this message translates to:
  /// **'Avoid (Failure-based)'**
  String get avoidFailBased;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @achieve.
  ///
  /// In en, this message translates to:
  /// **'Achieve'**
  String get achieve;

  /// No description provided for @avoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get avoid;

  /// No description provided for @weekendDays.
  ///
  /// In en, this message translates to:
  /// **'Weekend Days'**
  String get weekendDays;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Select Days'**
  String get selectDays;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @analyticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get analyticsDashboard;

  /// No description provided for @frequencyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 3'**
  String get frequencyHint;

  /// No description provided for @saturdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Saturday & Sunday'**
  String get saturdaySunday;

  /// No description provided for @fridaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Friday & Saturday'**
  String get fridaySaturday;

  /// No description provided for @thursdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Thursday & Friday'**
  String get thursdayFriday;

  /// No description provided for @unitOfMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Unit of Measurement'**
  String get unitOfMeasurement;

  /// No description provided for @customUnitName.
  ///
  /// In en, this message translates to:
  /// **'Custom Unit Name'**
  String get customUnitName;

  /// No description provided for @customUnitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., cups, sets, chapters'**
  String get customUnitHint;

  /// No description provided for @maxLimitOptional.
  ///
  /// In en, this message translates to:
  /// **'Maximum Limit (Optional)'**
  String get maxLimitOptional;

  /// No description provided for @targetValueOptional.
  ///
  /// In en, this message translates to:
  /// **'Target Value (Optional)'**
  String get targetValueOptional;

  /// No description provided for @setGoalOptional.
  ///
  /// In en, this message translates to:
  /// **'Set a Goal (Optional)'**
  String get setGoalOptional;

  /// No description provided for @setGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a target streak, completion rate, or total count to keep yourself motivated.'**
  String get setGoalDesc;

  /// No description provided for @goalMetric.
  ///
  /// In en, this message translates to:
  /// **'Goal Metric'**
  String get goalMetric;

  /// No description provided for @totalCompletions.
  ///
  /// In en, this message translates to:
  /// **'Total Completions'**
  String get totalCompletions;

  /// No description provided for @quickTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick Templates'**
  String get quickTemplates;

  /// No description provided for @targetStreakDays.
  ///
  /// In en, this message translates to:
  /// **'Target Streak (Days)'**
  String get targetStreakDays;

  /// No description provided for @targetSuccessRatePercent.
  ///
  /// In en, this message translates to:
  /// **'Target Success Rate (%)'**
  String get targetSuccessRatePercent;

  /// No description provided for @targetCompletions.
  ///
  /// In en, this message translates to:
  /// **'Target Completions'**
  String get targetCompletions;

  /// No description provided for @noActiveGoal.
  ///
  /// In en, this message translates to:
  /// **'No active goal'**
  String get noActiveGoal;

  /// No description provided for @bestStreakDaysMetric.
  ///
  /// In en, this message translates to:
  /// **'Best Streak (Days)'**
  String get bestStreakDaysMetric;

  /// No description provided for @successRatePercentMetric.
  ///
  /// In en, this message translates to:
  /// **'Success Rate (%)'**
  String get successRatePercentMetric;

  /// No description provided for @streakHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 90 (days clean)'**
  String get streakHint;

  /// No description provided for @percentageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 80 (percent success)'**
  String get percentageHint;

  /// No description provided for @completionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100 (times)'**
  String get completionsHint;

  /// No description provided for @daysCleanTemplate.
  ///
  /// In en, this message translates to:
  /// **'{count} Days Clean'**
  String daysCleanTemplate(String count);

  /// No description provided for @successPercentTemplate.
  ///
  /// In en, this message translates to:
  /// **'{count}% Success'**
  String successPercentTemplate(String count);

  /// No description provided for @daysStreakTemplate.
  ///
  /// In en, this message translates to:
  /// **'{count} Days Streak'**
  String daysStreakTemplate(String count);

  /// No description provided for @completionsTemplate.
  ///
  /// In en, this message translates to:
  /// **'{count} Completions'**
  String completionsTemplate(String count);

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameHintPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Read Books, Workout'**
  String get nameHintPlaceholder;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @notesHintOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional description or notes'**
  String get notesHintOptional;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @newCategoryOptional.
  ///
  /// In en, this message translates to:
  /// **'New Category (Optional)'**
  String get newCategoryOptional;

  /// No description provided for @newCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Fitness, Learning, Health'**
  String get newCategoryHint;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @weekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get weekends;

  /// No description provided for @customDays.
  ///
  /// In en, this message translates to:
  /// **'Custom Days'**
  String get customDays;

  /// No description provided for @xTimesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'X / Week'**
  String get xTimesPerWeek;

  /// No description provided for @xTimesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'X / Month'**
  String get xTimesPerMonth;

  /// No description provided for @timesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Times per week'**
  String get timesPerWeek;

  /// No description provided for @timesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Times per month'**
  String get timesPerMonth;

  /// No description provided for @countTimes.
  ///
  /// In en, this message translates to:
  /// **'Count/Times'**
  String get countTimes;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @pounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get pounds;

  /// No description provided for @dollars.
  ///
  /// In en, this message translates to:
  /// **'Dollars'**
  String get dollars;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @maximumLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum Limit'**
  String get maximumLimit;

  /// No description provided for @dailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTarget;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @maxLimitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 0 (no failures allowed)'**
  String get maxLimitHint;

  /// No description provided for @targetValueHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 30 (read 30 pages)'**
  String get targetValueHint;

  /// No description provided for @targetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 10 (meditate 10 minutes)'**
  String get targetAmountHint;

  /// No description provided for @skippingDate.
  ///
  /// In en, this message translates to:
  /// **'Skipping {date}'**
  String skippingDate(String date);

  /// No description provided for @trackFailure.
  ///
  /// In en, this message translates to:
  /// **'Track Failure'**
  String get trackFailure;

  /// No description provided for @trackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get trackProgress;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as Done'**
  String get markDone;

  /// No description provided for @trackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Track Success'**
  String get trackSuccess;

  /// No description provided for @markCompletion.
  ///
  /// In en, this message translates to:
  /// **'Mark Completion'**
  String get markCompletion;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @entryExistsForDay.
  ///
  /// In en, this message translates to:
  /// **'An entry already exists for this day.'**
  String get entryExistsForDay;

  /// No description provided for @noHabitsForToday.
  ///
  /// In en, this message translates to:
  /// **'No habits for today'**
  String get noHabitsForToday;

  /// No description provided for @createHabitToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create a habit to get started!'**
  String get createHabitToGetStarted;

  /// No description provided for @skipThisDay.
  ///
  /// In en, this message translates to:
  /// **'Skip this day?'**
  String get skipThisDay;

  /// No description provided for @skipThisDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Won\'t break your streak or affect statistics'**
  String get skipThisDaySubtitle;

  /// No description provided for @didYouCompleteToday.
  ///
  /// In en, this message translates to:
  /// **'Did you complete this habit today?'**
  String get didYouCompleteToday;

  /// No description provided for @completedCheck.
  ///
  /// In en, this message translates to:
  /// **'Completed ✓'**
  String get completedCheck;

  /// No description provided for @notCompletedCross.
  ///
  /// In en, this message translates to:
  /// **'Not Completed ✗'**
  String get notCompletedCross;

  /// No description provided for @targetGoal.
  ///
  /// In en, this message translates to:
  /// **'Target Goal'**
  String get targetGoal;

  /// No description provided for @progressStatus.
  ///
  /// In en, this message translates to:
  /// **'Progress Status'**
  String get progressStatus;

  /// No description provided for @whySkippingToday.
  ///
  /// In en, this message translates to:
  /// **'Why are you skipping today?'**
  String get whySkippingToday;

  /// No description provided for @whySkippingHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., sick, traveling, planned rest day...'**
  String get whySkippingHint;

  /// No description provided for @skipDay.
  ///
  /// In en, this message translates to:
  /// **'Skip Day'**
  String get skipDay;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Entry'**
  String get saveEntry;

  /// No description provided for @withinLimit.
  ///
  /// In en, this message translates to:
  /// **'Within limit ✓'**
  String get withinLimit;

  /// No description provided for @overLimitBy.
  ///
  /// In en, this message translates to:
  /// **'Over limit by {amount}'**
  String overLimitBy(String amount);

  /// No description provided for @targetReached.
  ///
  /// In en, this message translates to:
  /// **'Target reached! ✓'**
  String get targetReached;

  /// No description provided for @needMore.
  ///
  /// In en, this message translates to:
  /// **'Need {amount} more'**
  String needMore(String amount);

  /// No description provided for @goalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved! ✓'**
  String get goalAchieved;

  /// No description provided for @progressTowardsGoal.
  ///
  /// In en, this message translates to:
  /// **'Progress towards goal'**
  String get progressTowardsGoal;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @startJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey!'**
  String get startJourneyTitle;

  /// No description provided for @startJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A blank slate is the beginning of greatness.'**
  String get startJourneySubtitle;

  /// No description provided for @startJourneyMsg.
  ///
  /// In en, this message translates to:
  /// **'No habits tracked yet. Today is the perfect day to build new muscle! I believe in you! 💪'**
  String get startJourneyMsg;

  /// No description provided for @stayStrongTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Strong!'**
  String get stayStrongTitle;

  /// No description provided for @stayStrongSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every setback is a setup for a comeback.'**
  String get stayStrongSubtitle;

  /// No description provided for @stayStrongMsg.
  ///
  /// In en, this message translates to:
  /// **'You are strong, you can get more than 10%. I believe in you! Let\'s crush the next check! 🏋️‍♂️'**
  String get stayStrongMsg;

  /// No description provided for @keepBuildingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Building!'**
  String get keepBuildingTitle;

  /// No description provided for @keepBuildingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real growth takes time.'**
  String get keepBuildingSubtitle;

  /// No description provided for @keepBuildingMsg.
  ///
  /// In en, this message translates to:
  /// **'Progress is progress! Keep building that muscle. You\'re getting stronger every single day! ⚡'**
  String get keepBuildingMsg;

  /// No description provided for @consistencyPaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Consistency pays off!'**
  String get consistencyPaysTitle;

  /// No description provided for @consistencyPaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re building momentum.'**
  String get consistencyPaysSubtitle;

  /// No description provided for @consistencyPaysMsg.
  ///
  /// In en, this message translates to:
  /// **'Outstanding consistency! You are building habits like a champion! Keep pushing! 🔥'**
  String get consistencyPaysMsg;

  /// No description provided for @legendaryConsistencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Legendary Consistency!'**
  String get legendaryConsistencyTitle;

  /// No description provided for @legendaryConsistencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Absolute royalty.'**
  String get legendaryConsistencySubtitle;

  /// No description provided for @legendaryConsistencyMsg.
  ///
  /// In en, this message translates to:
  /// **'Phenomenal success! You are absolute royalty. A legend in the making! 👑'**
  String get legendaryConsistencyMsg;

  /// No description provided for @occStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get occStudent;

  /// No description provided for @occWorking.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get occWorking;

  /// No description provided for @occShiftWorker.
  ///
  /// In en, this message translates to:
  /// **'Shift Worker'**
  String get occShiftWorker;

  /// No description provided for @occParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get occParent;

  /// No description provided for @occRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get occRetired;

  /// No description provided for @occOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get occOther;

  /// No description provided for @areaHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get areaHealth;

  /// No description provided for @areaGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get areaGrowth;

  /// No description provided for @areaFinances.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get areaFinances;

  /// No description provided for @areaMental.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get areaMental;

  /// No description provided for @areaHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get areaHome;

  /// No description provided for @areaSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get areaSleep;

  /// No description provided for @areaRelationships.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get areaRelationships;

  /// No description provided for @weekdaysMonFri.
  ///
  /// In en, this message translates to:
  /// **'Weekdays (Mon-Fri)'**
  String get weekdaysMonFri;

  /// No description provided for @weekdaysSunThu.
  ///
  /// In en, this message translates to:
  /// **'Weekdays (Sun-Thu)'**
  String get weekdaysSunThu;

  /// No description provided for @weekdaysSatWed.
  ///
  /// In en, this message translates to:
  /// **'Weekdays (Sat-Wed)'**
  String get weekdaysSatWed;

  /// No description provided for @weekendsSatSun.
  ///
  /// In en, this message translates to:
  /// **'Weekends (Sat-Sun)'**
  String get weekendsSatSun;

  /// No description provided for @weekendsFriSat.
  ///
  /// In en, this message translates to:
  /// **'Weekends (Fri-Sat)'**
  String get weekendsFriSat;

  /// No description provided for @weekendsThuFri.
  ///
  /// In en, this message translates to:
  /// **'Weekends (Thu-Fri)'**
  String get weekendsThuFri;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @triggerHint.
  ///
  /// In en, this message translates to:
  /// **'What triggered this? Any insights...'**
  String get triggerHint;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @skippedDay.
  ///
  /// In en, this message translates to:
  /// **'Skipped day'**
  String get skippedDay;

  /// No description provided for @habitCorrelations.
  ///
  /// In en, this message translates to:
  /// **'Habit Correlations'**
  String get habitCorrelations;

  /// No description provided for @habitCorrelationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows which habits tend to succeed or fail together. A coefficient close to 1.0 means they occur together, while -1.0 means one succeeds when the other fails.'**
  String get habitCorrelationsDesc;

  /// No description provided for @notEnoughDataCorrelations.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to calculate correlations yet'**
  String get notEnoughDataCorrelations;

  /// No description provided for @habit1.
  ///
  /// In en, this message translates to:
  /// **'Habit 1'**
  String get habit1;

  /// No description provided for @habit2.
  ///
  /// In en, this message translates to:
  /// **'Habit 2'**
  String get habit2;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @performanceInsights.
  ///
  /// In en, this message translates to:
  /// **'Performance Insights'**
  String get performanceInsights;

  /// No description provided for @notEnoughDataInsights.
  ///
  /// In en, this message translates to:
  /// **'Add more entries to generate insights!'**
  String get notEnoughDataInsights;

  /// No description provided for @bestPerformer.
  ///
  /// In en, this message translates to:
  /// **'Best Performer'**
  String get bestPerformer;

  /// No description provided for @bestPerformerDesc.
  ///
  /// In en, this message translates to:
  /// **'{habitName} has {rate}% success rate'**
  String bestPerformerDesc(String habitName, String rate);

  /// No description provided for @mostConsistent.
  ///
  /// In en, this message translates to:
  /// **'Most Consistent'**
  String get mostConsistent;

  /// No description provided for @mostConsistentDesc.
  ///
  /// In en, this message translates to:
  /// **'{habitName} has a {streak}-day streak'**
  String mostConsistentDesc(String habitName, String streak);

  /// No description provided for @mostActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Active Day'**
  String get mostActiveDay;

  /// No description provided for @mostActiveDayDesc.
  ///
  /// In en, this message translates to:
  /// **'{dayName} with {count} entries'**
  String mostActiveDayDesc(String dayName, String count);

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @notEnoughDataRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking to receive recommendations!'**
  String get notEnoughDataRecommendations;

  /// No description provided for @strugglingHabitRec.
  ///
  /// In en, this message translates to:
  /// **'Consider reviewing {habitName} - try adjusting the target or frequency'**
  String strugglingHabitRec(String habitName);

  /// No description provided for @staleHabitRec.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t logged {habitName} recently - consider adding an entry'**
  String staleHabitRec(String habitName);

  /// No description provided for @correlationRec.
  ///
  /// In en, this message translates to:
  /// **'{habit1} and {habit2} work well together - consider doing them consecutively'**
  String correlationRec(String habit1, String habit2);

  /// No description provided for @aggregateActivityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Aggregate Activity Heatmap'**
  String get aggregateActivityHeatmap;

  /// No description provided for @noEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries'**
  String get noEntries;

  /// No description provided for @succeededFailures.
  ///
  /// In en, this message translates to:
  /// **'Succeeded ({actual}/{limit} failures)'**
  String succeededFailures(String actual, String limit);

  /// No description provided for @failedFailures.
  ///
  /// In en, this message translates to:
  /// **'Failed ({actual}/{limit} failures)'**
  String failedFailures(String actual, String limit);

  /// No description provided for @completedUnit.
  ///
  /// In en, this message translates to:
  /// **'{actual}/{target} {unit} completed'**
  String completedUnit(String actual, String target, String unit);

  /// No description provided for @habitsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{successes}/{total} habits completed'**
  String habitsCompleted(String successes, String total);

  /// No description provided for @selectFont.
  ///
  /// In en, this message translates to:
  /// **'Select Font'**
  String get selectFont;

  /// No description provided for @searchFonts.
  ///
  /// In en, this message translates to:
  /// **'Search fonts...'**
  String get searchFonts;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
