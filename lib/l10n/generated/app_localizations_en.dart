// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flux';

  @override
  String get todayTab => 'Today';

  @override
  String get dashboardTab => 'Dashboard';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get settingsTab => 'Settings';

  @override
  String get editEntryNotesValue => 'Edit Entry Notes/Value';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get pauseHabit => 'Pause Habit';

  @override
  String get resumeHabit => 'Resume Habit';

  @override
  String get archiveHabit => 'Archive Habit';

  @override
  String get restoreHabit => 'Restore Habit';

  @override
  String get deletePermanently => 'Delete Permanently';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String areYouSureDeleteHabit(String habitName) {
    return 'Are you sure you want to permanently delete \"$habitName\"? This action cannot be undone.';
  }

  @override
  String get areYouSureDeleteEntry =>
      'Are you sure you want to delete this entry?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get editHabitSubtitle =>
      'Change name, schedule, limit/goal, icon, and colors';

  @override
  String get pauseHabitSubtitle =>
      'Temporarily stop tracking without affecting streaks';

  @override
  String get resumeHabitSubtitle => 'Continue tracking this habit';

  @override
  String get archiveHabitSubtitle =>
      'Hide it from the main list but keep the data';

  @override
  String get restoreHabitSubtitle => 'Bring it back to the active list';

  @override
  String get deletePermanentlySubtitle => 'This cannot be undone';

  @override
  String get manageHabit => 'Manage Habit';

  @override
  String whatWouldYouDoWith(String habitName) {
    return 'What would you like to do with \"$habitName\"?';
  }

  @override
  String failedToExportReport(String error) {
    return 'Failed to export report: $error';
  }

  @override
  String get habitNotFound => 'Habit not found or deleted.';

  @override
  String get exportCsvReport => 'Export CSV Report';

  @override
  String get historyLogs => 'History Logs';

  @override
  String frequencyAndUnit(String frequency, String unit) {
    return 'Frequency: $frequency • Unit: $unit';
  }

  @override
  String slipUpStreakBanner(String streakVal) {
    return 'Don\'t let one slip-up stop you from reaching your $streakVal-day streak goal!';
  }

  @override
  String slipUpSuccessBanner(String successVal) {
    return 'Don\'t let one slip-up stop you from reaching your $successVal% success rate goal!';
  }

  @override
  String get slipUpGenericBanner =>
      '1 slip-up doesn\'t erase your progress. Let\'s start fresh and make today a win!';

  @override
  String get youCanGetIt => 'You can get it!';

  @override
  String get noActiveGoalSet => 'No Active Goal Set';

  @override
  String get noActiveGoalSubtitle =>
      'Tap here to set a target streak or success rate to stay motivated!';

  @override
  String get achieved => 'Achieved!';

  @override
  String reachedPercent(String percent) {
    return '$percent% reached';
  }

  @override
  String daysLeft(String days) {
    return '$days days left';
  }

  @override
  String completionsGoal(String value) {
    return 'Completions Goal: $value times';
  }

  @override
  String streakGoal(String value) {
    return 'Streak Goal: $value Days';
  }

  @override
  String successRateGoal(String value) {
    return 'Success Rate Goal: $value%';
  }

  @override
  String progressLabelDays(String current, String target) {
    return '$current of $target days';
  }

  @override
  String progressLabelPercentage(String current, String target) {
    return '$current% of $target%';
  }

  @override
  String progressLabelCompletions(String current, String target) {
    return '$current of $target completions';
  }

  @override
  String get trends => 'Trends';

  @override
  String get valueTrends => 'Value Trends';

  @override
  String get values => 'Values';

  @override
  String get successRateTrends => 'Success Rate Trends';

  @override
  String get successRatePercent => 'Success Rate (%)';

  @override
  String get streakTrends => 'Streak Trends';

  @override
  String get streaks => 'Streaks';

  @override
  String get currentStreaks => 'Current Streaks';

  @override
  String get daysLabel => 'Days';

  @override
  String get distribution => 'Distribution';

  @override
  String get heatmap => 'Heatmap';

  @override
  String get insights => 'Insights';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get last90Days => 'Last 90 Days';

  @override
  String get thisYear => 'This Year';

  @override
  String get allTime => 'All Time';

  @override
  String get customRange => 'Custom Range';

  @override
  String get activityHeatmap => 'Activity Heatmap';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get toggleDarkLight => 'Toggle dark or light theme';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get matchLauncherIcon => 'Match Launcher Icon';

  @override
  String get matchLauncherIconSubtitle =>
      'Sync home screen icon with theme color';

  @override
  String get displayPreferences => 'Display Preferences';

  @override
  String get showSuccessRate => 'Show Success Rate';

  @override
  String get showSuccessRateSubtitle => 'Show percentage rates in the app';

  @override
  String get showStreakDays => 'Show Streak Days';

  @override
  String get showStreakDaysSubtitle => 'Show daily streaks in the app';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get backupRestoreSubtitle => 'Export or import your habit database';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get backupStorageFolder => 'Backup Storage Folder';

  @override
  String get noFolderSet =>
      'No folder set (e.g. create and pick \"flux backups\" outside Flux)';

  @override
  String get selectBackupFolder => 'Select Backup Folder';

  @override
  String get changeFolder => 'Change Folder';

  @override
  String get autoDailyBackup => 'Automatic Daily Backup';

  @override
  String get autoDailyBackupSubtitle =>
      'Creates a backup file automatically when you open Flux once per day.';

  @override
  String get exportNow => 'Export Now';

  @override
  String get browseFile => 'Browse File';

  @override
  String get availableBackups => 'Available Backups';

  @override
  String get noBackupFound => 'No backup files found in this folder.';

  @override
  String get restore => 'Restore';

  @override
  String get restoreDatabaseTitle => 'Restore Database?';

  @override
  String get restoreDatabaseConfirm =>
      'This will restore all your habits and entries from this backup file. Current data will be replaced.';

  @override
  String get restoreDatabaseOverwrite =>
      'This will overwrite all your current habits and entries with the selected backup file. This action cannot be undone.';

  @override
  String backupFolderSet(String path) {
    return 'Backup folder set to: $path';
  }

  @override
  String get backupExportedSuccessfully => 'Backup exported successfully!';

  @override
  String get databaseImportedSuccessfully => 'Database imported successfully!';

  @override
  String get exportFailedLocation => 'Export failed: Location not chosen.';

  @override
  String get successRate => 'Success Rate';

  @override
  String get todaySuccessRate => 'Today\'s Success Rate';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String bestStreakDays(String days) {
    return '$days Days';
  }

  @override
  String bestStreakHabitOn(String habitName) {
    return 'on $habitName';
  }

  @override
  String get dailySuccessHistory => 'Daily Success Rate History';

  @override
  String errorLoadingHabits(String error) {
    return 'Error loading habits: $error';
  }

  @override
  String get onboardSetupTitle => 'Flux Setup';

  @override
  String get back => 'Back';

  @override
  String get complete => 'Complete';

  @override
  String get next => 'Next';

  @override
  String get identityStepName => 'Identity';

  @override
  String get questStepName => 'Change Goal';

  @override
  String get welcomeStepName => 'Welcome';

  @override
  String get welcomeTitle => 'Welcome to Flux';

  @override
  String get welcomeSubtitle =>
      'Choose how you want to get started with tracking your habits.';

  @override
  String get guidedSetup => 'Guided Setup';

  @override
  String get guidedSetupDesc =>
      'Answer 5 quick questions to customize your recommendation style';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get restoreBackupDesc =>
      'Import your existing database and history logs';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get quickStartDesc =>
      'Skip setup entirely and create your habits from scratch';

  @override
  String get namePrompt => 'What is your name? (Optional)';

  @override
  String get nameHint => 'Enter your name...';

  @override
  String get occupationPrompt => 'What is your daily occupation? (Optional)';

  @override
  String get questTitle => 'What are you trying to change?';

  @override
  String get questSubtitle => 'This determines your recommendation style.';

  @override
  String get breakHabits => 'Break Bad Habits';

  @override
  String get breakHabitsDesc =>
      'I want to avoid triggers, limit distractions, or stop bad routines.';

  @override
  String get createHabits => 'Creating Habits';

  @override
  String get createHabitsDesc =>
      'I want to establish new daily activities, positive routines, or targets.';

  @override
  String get bothHabits => 'Don\'t Know / Both';

  @override
  String get bothHabitsDesc =>
      'I want to build a mix of positive additions and avoid slips.';

  @override
  String get areasTitle => 'What are you trying to change in your life?';

  @override
  String get areasSubtitle =>
      'Choose the focus areas that matter to you right now.';

  @override
  String get areasStepName => 'Focus Areas';

  @override
  String get preferencesTitle => 'Experience & Tracking Style';

  @override
  String get preferencesSubtitle => 'Customize how you track your habits.';

  @override
  String get preferencesStepName => 'Preferences';

  @override
  String get starterPackTitle => 'Choose your starting habits';

  @override
  String get starterPackSubtitle =>
      'Starting small is the secret to 90-day consistency. Choose 1 to 3 habits.';

  @override
  String get starterPackStepName => 'Starter Habits';

  @override
  String get starterHabitsWarn =>
      'Starting small (1-3 habits) dramatically increases your chance of long-term success!';

  @override
  String get generatingSuggestions => 'Generating custom suggestions...';

  @override
  String get completeTitle => 'Your Journey Begins';

  @override
  String get completeSubtitle =>
      'Imagine opening Flux 100 days from now and seeing every single promise you\'ve kept.';

  @override
  String get completeStepName => 'Complete';

  @override
  String get completeRoadmap => 'Your Personalized Roadmap:';

  @override
  String completeName(String name) {
    return 'Name: $name';
  }

  @override
  String completeOccupation(String occupation) {
    return 'Occupation: $occupation';
  }

  @override
  String completeFocusAreas(String areas) {
    return 'Focus areas: $areas';
  }

  @override
  String completeSeeding(String count) {
    return 'Seeding: $count starter habits';
  }

  @override
  String get never => 'Never';

  @override
  String get aLittle => 'A little';

  @override
  String get regularly => 'Regularly';

  @override
  String get trackedBeforePrompt => 'Have you tracked habits before?';

  @override
  String get measureProgressPrompt => 'How do you prefer to measure progress?';

  @override
  String get streaksFocus => 'Streaks Focus';

  @override
  String get streaksFocusDesc =>
      'Counts consecutive days you keep the habit alive.';

  @override
  String get percentagesFocus => 'Percentages Focus';

  @override
  String get percentagesFocusDesc =>
      'Shows your overall consistency percentage over time.';

  @override
  String get newHabit => 'New Habit';

  @override
  String get basicTab => 'Basic';

  @override
  String get scheduleTab => 'Schedule';

  @override
  String get detailsTab => 'Details';

  @override
  String get styleTab => 'Style';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get type => 'Type';

  @override
  String get checkDoneBased => 'Check (Done-based)';

  @override
  String get achieveSuccessBased => 'Achieve (Success-based)';

  @override
  String get avoidFailBased => 'Avoid (Failure-based)';

  @override
  String get check => 'Check';

  @override
  String get achieve => 'Achieve';

  @override
  String get avoid => 'Avoid';

  @override
  String get weekendDays => 'Weekend Days';

  @override
  String get selectDays => 'Select Days';

  @override
  String get frequency => 'Frequency';

  @override
  String get analyticsDashboard => 'Analytics Dashboard';

  @override
  String get frequencyHint => 'e.g., 3';

  @override
  String get saturdaySunday => 'Saturday & Sunday';

  @override
  String get fridaySaturday => 'Friday & Saturday';

  @override
  String get thursdayFriday => 'Thursday & Friday';

  @override
  String get unitOfMeasurement => 'Unit of Measurement';

  @override
  String get customUnitName => 'Custom Unit Name';

  @override
  String get customUnitHint => 'e.g., cups, sets, chapters';

  @override
  String get maxLimitOptional => 'Maximum Limit (Optional)';

  @override
  String get targetValueOptional => 'Target Value (Optional)';

  @override
  String get setGoalOptional => 'Set a Goal (Optional)';

  @override
  String get setGoalDesc =>
      'Set a target streak, completion rate, or total count to keep yourself motivated.';

  @override
  String get goalMetric => 'Goal Metric';

  @override
  String get totalCompletions => 'Total Completions';

  @override
  String get quickTemplates => 'Quick Templates';

  @override
  String get targetStreakDays => 'Target Streak (Days)';

  @override
  String get targetSuccessRatePercent => 'Target Success Rate (%)';

  @override
  String get targetCompletions => 'Target Completions';

  @override
  String get noActiveGoal => 'No active goal';

  @override
  String get bestStreakDaysMetric => 'Best Streak (Days)';

  @override
  String get successRatePercentMetric => 'Success Rate (%)';

  @override
  String get streakHint => 'e.g., 90 (days clean)';

  @override
  String get percentageHint => 'e.g., 80 (percent success)';

  @override
  String get completionsHint => 'e.g., 100 (times)';

  @override
  String daysCleanTemplate(String count) {
    return '$count Days Clean';
  }

  @override
  String successPercentTemplate(String count) {
    return '$count% Success';
  }

  @override
  String daysStreakTemplate(String count) {
    return '$count Days Streak';
  }

  @override
  String completionsTemplate(String count) {
    return '$count Completions';
  }

  @override
  String get icon => 'Icon';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get name => 'Name';

  @override
  String get nameHintPlaceholder => 'e.g., Read Books, Workout';

  @override
  String get notes => 'Notes';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get notesHintOptional => 'Optional description or notes';

  @override
  String get category => 'Category';

  @override
  String get newCategoryOptional => 'New Category (Optional)';

  @override
  String get newCategoryHint => 'e.g., Fitness, Learning, Health';

  @override
  String get daily => 'Daily';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get customDays => 'Custom Days';

  @override
  String get xTimesPerWeek => 'X / Week';

  @override
  String get xTimesPerMonth => 'X / Month';

  @override
  String get timesPerWeek => 'Times per week';

  @override
  String get timesPerMonth => 'Times per month';

  @override
  String get countTimes => 'Count/Times';

  @override
  String get minutes => 'Minutes';

  @override
  String get hours => 'Hours';

  @override
  String get pages => 'Pages';

  @override
  String get kilometers => 'Kilometers';

  @override
  String get miles => 'Miles';

  @override
  String get grams => 'Grams';

  @override
  String get pounds => 'Pounds';

  @override
  String get dollars => 'Dollars';

  @override
  String get custom => 'Custom';

  @override
  String get maximumLimit => 'Maximum Limit';

  @override
  String get dailyTarget => 'Daily Target';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get maxLimitHint => 'e.g., 0 (no failures allowed)';

  @override
  String get targetValueHint => 'e.g., 30 (read 30 pages)';

  @override
  String get targetAmountHint => 'e.g., 10 (meditate 10 minutes)';

  @override
  String skippingDate(String date) {
    return 'Skipping $date';
  }

  @override
  String get trackFailure => 'Track Failure';

  @override
  String get trackProgress => 'Track Progress';

  @override
  String get markDone => 'Mark as Done';

  @override
  String get trackSuccess => 'Track Success';

  @override
  String get markCompletion => 'Mark Completion';

  @override
  String get date => 'Date';

  @override
  String get entryExistsForDay => 'An entry already exists for this day.';

  @override
  String get noHabitsForToday => 'No habits for today';

  @override
  String get createHabitToGetStarted => 'Create a habit to get started!';

  @override
  String get skipThisDay => 'Skip this day?';

  @override
  String get skipThisDaySubtitle =>
      'Won\'t break your streak or affect statistics';

  @override
  String get didYouCompleteToday => 'Did you complete this habit today?';

  @override
  String get completedCheck => 'Completed ✓';

  @override
  String get notCompletedCross => 'Not Completed ✗';

  @override
  String get targetGoal => 'Target Goal';

  @override
  String get progressStatus => 'Progress Status';

  @override
  String get whySkippingToday => 'Why are you skipping today?';

  @override
  String get whySkippingHint => 'e.g., sick, traveling, planned rest day...';

  @override
  String get skipDay => 'Skip Day';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get withinLimit => 'Within limit ✓';

  @override
  String overLimitBy(String amount) {
    return 'Over limit by $amount';
  }

  @override
  String get targetReached => 'Target reached! ✓';

  @override
  String needMore(String amount) {
    return 'Need $amount more';
  }

  @override
  String get goalAchieved => 'Goal achieved! ✓';

  @override
  String get progressTowardsGoal => 'Progress towards goal';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get startJourneyTitle => 'Start Your Journey!';

  @override
  String get startJourneySubtitle =>
      'A blank slate is the beginning of greatness.';

  @override
  String get startJourneyMsg =>
      'No habits tracked yet. Today is the perfect day to build new muscle! I believe in you! 💪';

  @override
  String get stayStrongTitle => 'Stay Strong!';

  @override
  String get stayStrongSubtitle => 'Every setback is a setup for a comeback.';

  @override
  String get stayStrongMsg =>
      'You are strong, you can get more than 10%. I believe in you! Let\'s crush the next check! 🏋️‍♂️';

  @override
  String get keepBuildingTitle => 'Keep Building!';

  @override
  String get keepBuildingSubtitle => 'Real growth takes time.';

  @override
  String get keepBuildingMsg =>
      'Progress is progress! Keep building that muscle. You\'re getting stronger every single day! ⚡';

  @override
  String get consistencyPaysTitle => 'Consistency pays off!';

  @override
  String get consistencyPaysSubtitle => 'You\'re building momentum.';

  @override
  String get consistencyPaysMsg =>
      'Outstanding consistency! You are building habits like a champion! Keep pushing! 🔥';

  @override
  String get legendaryConsistencyTitle => 'Legendary Consistency!';

  @override
  String get legendaryConsistencySubtitle => 'Absolute royalty.';

  @override
  String get legendaryConsistencyMsg =>
      'Phenomenal success! You are absolute royalty. A legend in the making! 👑';

  @override
  String get occStudent => 'Student';

  @override
  String get occWorking => 'Working';

  @override
  String get occShiftWorker => 'Shift Worker';

  @override
  String get occParent => 'Parent';

  @override
  String get occRetired => 'Retired';

  @override
  String get occOther => 'Other';

  @override
  String get areaHealth => 'Health';

  @override
  String get areaGrowth => 'Growth';

  @override
  String get areaFinances => 'Finance';

  @override
  String get areaMental => 'Mind';

  @override
  String get areaHome => 'Home';

  @override
  String get areaSleep => 'Sleep';

  @override
  String get areaRelationships => 'Social';

  @override
  String get weekdaysMonFri => 'Weekdays (Mon-Fri)';

  @override
  String get weekdaysSunThu => 'Weekdays (Sun-Thu)';

  @override
  String get weekdaysSatWed => 'Weekdays (Sat-Wed)';

  @override
  String get weekendsSatSun => 'Weekends (Sat-Sun)';

  @override
  String get weekendsFriSat => 'Weekends (Fri-Sat)';

  @override
  String get weekendsThuFri => 'Weekends (Thu-Fri)';

  @override
  String get unknown => 'Unknown';

  @override
  String get triggerHint => 'What triggered this? Any insights...';

  @override
  String get enterValue => 'Enter value';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get value => 'Value';

  @override
  String get amount => 'Amount';

  @override
  String get reset => 'Reset';

  @override
  String get skippedDay => 'Skipped day';

  @override
  String get habitCorrelations => 'Habit Correlations';

  @override
  String get habitCorrelationsDesc =>
      'Shows which habits tend to succeed or fail together. A coefficient close to 1.0 means they occur together, while -1.0 means one succeeds when the other fails.';

  @override
  String get notEnoughDataCorrelations =>
      'Not enough data to calculate correlations yet';

  @override
  String get habit1 => 'Habit 1';

  @override
  String get habit2 => 'Habit 2';

  @override
  String get strength => 'Strength';

  @override
  String get performanceInsights => 'Performance Insights';

  @override
  String get notEnoughDataInsights => 'Add more entries to generate insights!';

  @override
  String get bestPerformer => 'Best Performer';

  @override
  String bestPerformerDesc(String habitName, String rate) {
    return '$habitName has $rate% success rate';
  }

  @override
  String get mostConsistent => 'Most Consistent';

  @override
  String mostConsistentDesc(String habitName, String streak) {
    return '$habitName has a $streak-day streak';
  }

  @override
  String get mostActiveDay => 'Most Active Day';

  @override
  String mostActiveDayDesc(String dayName, String count) {
    return '$dayName with $count entries';
  }

  @override
  String get recommendations => 'Recommendations';

  @override
  String get notEnoughDataRecommendations =>
      'Keep tracking to receive recommendations!';

  @override
  String strugglingHabitRec(String habitName) {
    return 'Consider reviewing $habitName - try adjusting the target or frequency';
  }

  @override
  String staleHabitRec(String habitName) {
    return 'You haven\'t logged $habitName recently - consider adding an entry';
  }

  @override
  String correlationRec(String habit1, String habit2) {
    return '$habit1 and $habit2 work well together - consider doing them consecutively';
  }

  @override
  String get aggregateActivityHeatmap => 'Aggregate Activity Heatmap';

  @override
  String get noEntries => 'No entries';

  @override
  String succeededFailures(String actual, String limit) {
    return 'Succeeded ($actual/$limit failures)';
  }

  @override
  String failedFailures(String actual, String limit) {
    return 'Failed ($actual/$limit failures)';
  }

  @override
  String completedUnit(String actual, String target, String unit) {
    return '$actual/$target $unit completed';
  }

  @override
  String habitsCompleted(String successes, String total) {
    return '$successes/$total habits completed';
  }

  @override
  String get selectFont => 'Select Font';

  @override
  String get searchFonts => 'Search fonts...';

  @override
  String get font => 'Font';
}
