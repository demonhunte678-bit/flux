// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'فلوكس';

  @override
  String get todayTab => 'اليوم';

  @override
  String get dashboardTab => 'لوحة التحكم';

  @override
  String get analyticsTab => 'التحليلات';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get editEntryNotesValue => 'تعديل ملاحظات/قيمة السجل';

  @override
  String get deleteEntry => 'حذف السجل';

  @override
  String get editHabit => 'تعديل العادة';

  @override
  String get pauseHabit => 'إيقاف مؤقت للعادة';

  @override
  String get resumeHabit => 'استئناف العادة';

  @override
  String get archiveHabit => 'أرشفة العادة';

  @override
  String get restoreHabit => 'استعادة العادة';

  @override
  String get deletePermanently => 'حذف نهائي';

  @override
  String get confirmDeletion => 'تأكيد الحذف';

  @override
  String areYouSureDeleteHabit(String habitName) {
    return 'هل أنت متأكد أنك تريد حذف العادة \"$habitName\" بشكل نهائي؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get areYouSureDeleteEntry => 'هل أنت متأكد أنك تريد حذف هذا السجل؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get editHabitSubtitle =>
      'تغيير الاسم، والجدول، والحد/الهدف، والأيقونة، والألوان';

  @override
  String get pauseHabitSubtitle =>
      'إيقاف التتبع مؤقتًا دون التأثير على السلاسل المتتالية';

  @override
  String get resumeHabitSubtitle => 'متابعة تتبع هذه العادة';

  @override
  String get archiveHabitSubtitle =>
      'إخفاء العادة من القائمة الرئيسية مع الاحتفاظ بالبيانات';

  @override
  String get restoreHabitSubtitle => 'إعادتها إلى قائمة العادات النشطة';

  @override
  String get deletePermanentlySubtitle => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get manageHabit => 'إدارة العادة';

  @override
  String whatWouldYouDoWith(String habitName) {
    return 'ماذا تريد أن تفعل بالعادة \"$habitName\"؟';
  }

  @override
  String failedToExportReport(String error) {
    return 'فشل تصدير التقرير: $error';
  }

  @override
  String get habitNotFound => 'العادة غير موجودة أو تم حذفها.';

  @override
  String get exportCsvReport => 'تصدير تقرير CSV';

  @override
  String get historyLogs => 'سجلات التاريخ';

  @override
  String frequencyAndUnit(String frequency, String unit) {
    return 'التكرار: $frequency • الوحدة: $unit';
  }

  @override
  String slipUpStreakBanner(String streakVal) {
    return 'لا تدع هفوة واحدة تمنعك من الوصول إلى هدف سلسلة $streakVal أيام المتتالية!';
  }

  @override
  String slipUpSuccessBanner(String successVal) {
    return 'لا تدع هفوة واحدة تمنعك من الوصول إلى هدف معدل نجاح $successVal%!';
  }

  @override
  String get slipUpGenericBanner =>
      'هفوة واحدة لا تمحو تقدمك. فلنبدأ من جديد ونجعل اليوم فوزًا!';

  @override
  String get youCanGetIt => 'يمكنك تحقيق ذلك!';

  @override
  String get noActiveGoalSet => 'لم يتم تحديد هدف نشط';

  @override
  String get noActiveGoalSubtitle =>
      'انقر هنا لتحديد سلسلة مستهدفة أو معدل نجاح للبقاء متحفزًا!';

  @override
  String get achieved => 'تم التحقيق!';

  @override
  String reachedPercent(String percent) {
    return 'تم الوصول إلى $percent%';
  }

  @override
  String daysLeft(String days) {
    return 'متبقي $days أيام';
  }

  @override
  String completionsGoal(String value) {
    return 'هدف التكرارات: $value مرات';
  }

  @override
  String streakGoal(String value) {
    return 'هدف السلسلة: $value أيام متتالية';
  }

  @override
  String successRateGoal(String value) {
    return 'هدف معدل النجاح: $value%';
  }

  @override
  String progressLabelDays(String current, String target) {
    return '$current من $target أيام';
  }

  @override
  String progressLabelPercentage(String current, String target) {
    return '$current% من $target%';
  }

  @override
  String progressLabelCompletions(String current, String target) {
    return '$current من $target مرات إنجاز';
  }

  @override
  String get trends => 'الاتجاهات';

  @override
  String get valueTrends => 'اتجاهات القيم';

  @override
  String get values => 'القيم';

  @override
  String get successRateTrends => 'اتجاهات معدل النجاح';

  @override
  String get successRatePercent => 'معدل النجاح (%)';

  @override
  String get streakTrends => 'اتجاهات السلسلة المتتالية';

  @override
  String get streaks => 'السلاسل المتتالية';

  @override
  String get currentStreaks => 'السلاسل الحالية';

  @override
  String get daysLabel => 'أيام';

  @override
  String get distribution => 'التوزيع';

  @override
  String get heatmap => 'خريطة الحرارة';

  @override
  String get insights => 'الرؤى والتحليلات';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get last30Days => 'آخر 30 يومًا';

  @override
  String get last90Days => 'آخر 90 يومًا';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get allTime => 'كل الأوقات';

  @override
  String get customRange => 'نطاق مخصص';

  @override
  String get activityHeatmap => 'خريطة حرارة النشاط';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get toggleDarkLight => 'التبديل بين الوضع الداكن والفاتح';

  @override
  String get themeColor => 'لون المظهر';

  @override
  String get matchLauncherIcon => 'مطابقة أيقونة المشغل';

  @override
  String get matchLauncherIconSubtitle =>
      'مزامنة أيقونة الشاشة الرئيسية مع لون المظهر';

  @override
  String get displayPreferences => 'تفضيلات العرض';

  @override
  String get showSuccessRate => 'إظهار معدل النجاح';

  @override
  String get showSuccessRateSubtitle => 'إظهار النسب المئوية للنجاح في التطبيق';

  @override
  String get showStreakDays => 'إظهار أيام السلسلة';

  @override
  String get showStreakDaysSubtitle => 'إظهار السلاسل اليومية في التطبيق';

  @override
  String get general => 'عام';

  @override
  String get language => 'اللغة';

  @override
  String get backupRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupRestoreSubtitle => 'تصدير أو استيراد قاعدة بيانات عاداتك';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get backupStorageFolder => 'مجلد تخزين النسخ الاحتياطي';

  @override
  String get noFolderSet =>
      'لم يتم تعيين مجلد (على سبيل المثال، قم بإنشاء واختيار مجلد \"flux backups\" خارج التطبيق)';

  @override
  String get selectBackupFolder => 'اختر مجلد النسخ الاحتياطي';

  @override
  String get changeFolder => 'تغيير المجلد';

  @override
  String get autoDailyBackup => 'نسخ احتياطي يومي تلقائي';

  @override
  String get autoDailyBackupSubtitle =>
      'ينشئ ملف نسخة احتياطية تلقائيًا مرة واحدة يوميًا عند فتح فلوكس.';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get browseFile => 'تصفح الملف';

  @override
  String get availableBackups => 'النسخ الاحتياطية المتاحة';

  @override
  String get noBackupFound =>
      'لم يتم العثور على ملفات نسخ احتياطي في هذا المجلد.';

  @override
  String get restore => 'استعادة';

  @override
  String get restoreDatabaseTitle => 'استعادة قاعدة البيانات؟';

  @override
  String get restoreDatabaseConfirm =>
      'سيؤدي هذا إلى استعادة جميع عاداتك وسجلاتك من ملف النسخ الاحتياطي هذا. سيتم استبدال البيانات الحالية.';

  @override
  String get restoreDatabaseOverwrite =>
      'سيؤدي هذا إلى الكتابة فوق جميع عاداتك وسجلاتك الحالية بملف النسخ الاحتياطي المحدد. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String backupFolderSet(String path) {
    return 'تم تعيين مجلد النسخ الاحتياطي إلى: $path';
  }

  @override
  String get backupExportedSuccessfully => 'تم تصدير النسخة الاحتياطية بنجاح!';

  @override
  String get databaseImportedSuccessfully => 'تم استيراد قاعدة البيانات بنجاح!';

  @override
  String get exportFailedLocation => 'فشل التصدير: لم يتم اختيار الموقع.';

  @override
  String get successRate => 'معدل النجاح';

  @override
  String get todaySuccessRate => 'معدل نجاح اليوم';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String bestStreakDays(String days) {
    return '$days أيام';
  }

  @override
  String bestStreakHabitOn(String habitName) {
    return 'في عادتك \"$habitName\"';
  }

  @override
  String get dailySuccessHistory => 'سجل معدل النجاح اليومي';

  @override
  String errorLoadingHabits(String error) {
    return 'خطأ في تحميل العادات: $error';
  }

  @override
  String get onboardSetupTitle => 'إعداد فلوكس';

  @override
  String get back => 'السابق';

  @override
  String get complete => 'إنهاء';

  @override
  String get next => 'التالي';

  @override
  String get identityStepName => 'الهوية';

  @override
  String get questStepName => 'هدف التغيير';

  @override
  String get welcomeStepName => 'مرحبًا';

  @override
  String get welcomeTitle => 'مرحبًا بك في فلوكس';

  @override
  String get welcomeSubtitle => 'اختر الطريقة التي تفضلها لبدء تتبع عاداتك.';

  @override
  String get guidedSetup => 'الإعداد الإرشادي';

  @override
  String get guidedSetupDesc =>
      'أجب عن 5 أسئلة سريعة لتخصيص أسلوب التوصيات المناسب لك';

  @override
  String get restoreBackup => 'استعادة النسخة الاحتياطية';

  @override
  String get restoreBackupDesc =>
      'قم باستيراد قاعدة البيانات الحالية وسجل التتبع الخاص بك';

  @override
  String get quickStart => 'البدء السريع';

  @override
  String get quickStartDesc => 'تخطى الإعداد بالكامل وابدأ بإنشاء عاداتك بنفسك';

  @override
  String get namePrompt => 'ما هو اسمك؟ (اختياري)';

  @override
  String get nameHint => 'أدخل اسمك...';

  @override
  String get occupationPrompt => 'ما هي مهنتك اليومية؟ (اختياري)';

  @override
  String get questTitle => 'ما الذي تحاول تغييره؟';

  @override
  String get questSubtitle => 'هذا يحدد أسلوب التوصيات المناسب لك.';

  @override
  String get breakHabits => 'التخلص من العادات السيئة';

  @override
  String get breakHabitsDesc =>
      'أريد تجنب المثيرات، أو الحد من المشتتات، أو التوقف عن السلوكيات السلبية.';

  @override
  String get createHabits => 'بناء عادات جديدة';

  @override
  String get createHabitsDesc =>
      'أريد تأسيس أنشطة يومية جديدة، أو روتين إيجابي، أو تحقيق أهداف معينة.';

  @override
  String get bothHabits => 'لا أعلم / كلاهما';

  @override
  String get bothHabitsDesc =>
      'أريد بناء مزيج من الإضافات الإيجابية وتجنب الهفوات.';

  @override
  String get areasTitle => 'ما الذي تحاول تغييره في حياتك؟';

  @override
  String get areasSubtitle => 'اختر مجالات التركيز التي تهمك في الوقت الحالي.';

  @override
  String get areasStepName => 'مجالات التركيز';

  @override
  String get preferencesTitle => 'أسلوب التتبع والخبرة';

  @override
  String get preferencesSubtitle => 'تخصيص طريقة تتبع عاداتك.';

  @override
  String get preferencesStepName => 'التفضيلات';

  @override
  String get starterPackTitle => 'اختر عاداتك البدائية';

  @override
  String get starterPackSubtitle =>
      'البدء بخطوات صغيرة هو سر الاستمرارية لـ 90 يومًا. اختر من 1 إلى 3 عادات.';

  @override
  String get starterPackStepName => 'عادات البداية';

  @override
  String get starterHabitsWarn =>
      'البدء بصغير (1-3 عادات) يزيد بشكل كبير من فرصة نجاحك على المدى الطويل!';

  @override
  String get generatingSuggestions => 'جاري إنشاء اقتراحات مخصصة...';

  @override
  String get completeTitle => 'رحلتك تبدأ الآن';

  @override
  String get completeSubtitle =>
      'تخيل أنك تفتح فلوكس بعد 100 يوم من الآن وترى كل وعد قطعته على نفسك وقد أوفيت به.';

  @override
  String get completeStepName => 'إنهاء';

  @override
  String get completeRoadmap => 'خريطة طريقك المخصصة:';

  @override
  String completeName(String name) {
    return 'الاسم: $name';
  }

  @override
  String completeOccupation(String occupation) {
    return 'المهنة: $occupation';
  }

  @override
  String completeFocusAreas(String areas) {
    return 'مجالات التركيز: $areas';
  }

  @override
  String completeSeeding(String count) {
    return 'البداية بـ: $count عادات أولية';
  }

  @override
  String get never => 'أبدًا';

  @override
  String get aLittle => 'قليلاً';

  @override
  String get regularly => 'بانتظام';

  @override
  String get trackedBeforePrompt => 'هل قمت بتتبع العادات من قبل؟';

  @override
  String get measureProgressPrompt => 'كيف تفضل قياس مدى تقدمك؟';

  @override
  String get streaksFocus => 'التركيز على السلاسل المتتالية';

  @override
  String get streaksFocusDesc =>
      'يحسب الأيام المتتالية التي تحافظ فيها على العادة نشطة.';

  @override
  String get percentagesFocus => 'التركيز على النسب المئوية';

  @override
  String get percentagesFocusDesc =>
      'يظهر النسبة المئوية لاتساقك العام بمرور الوقت.';

  @override
  String get newHabit => 'عادة جديدة';

  @override
  String get basicTab => 'أساسي';

  @override
  String get scheduleTab => 'الجدول';

  @override
  String get detailsTab => 'التفاصيل';

  @override
  String get styleTab => 'المظهر';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get createHabit => 'إنشاء عادة';

  @override
  String get type => 'النوع';

  @override
  String get checkDoneBased => 'تحقق (تعتمد على الإنجاز)';

  @override
  String get achieveSuccessBased => 'تحقيق (تعتمد على النجاح الرقمي)';

  @override
  String get avoidFailBased => 'تجنب (تعتمد على الفشل)';

  @override
  String get check => 'تحقق';

  @override
  String get achieve => 'تحقيق';

  @override
  String get avoid => 'تجنب';

  @override
  String get weekendDays => 'أيام عطلة نهاية الأسبوع';

  @override
  String get selectDays => 'اختر الأيام';

  @override
  String get frequency => 'التكرار';

  @override
  String get analyticsDashboard => 'لوحة التحليلات';

  @override
  String get frequencyHint => 'مثال: 3';

  @override
  String get saturdaySunday => 'السبت والأحد';

  @override
  String get fridaySaturday => 'الجمعة والسبت';

  @override
  String get thursdayFriday => 'الخميس والجمعة';

  @override
  String get unitOfMeasurement => 'وحدة القياس';

  @override
  String get customUnitName => 'اسم وحدة مخصصة';

  @override
  String get customUnitHint => 'مثال: أكواب، مجموعات، فصول';

  @override
  String get maxLimitOptional => 'الحد الأقصى (اختياري)';

  @override
  String get targetValueOptional => 'القيمة المستهدفة (اختياري)';

  @override
  String get setGoalOptional => 'تحديد هدف (اختياري)';

  @override
  String get setGoalDesc =>
      'حدد سلسلة مستهدفة، أو معدل إنجاز، أو عددًا إجماليًا لإنجاز العادات للبقاء متحفزًا.';

  @override
  String get goalMetric => 'مقياس الهدف';

  @override
  String get totalCompletions => 'إجمالي مرات الإنجاز';

  @override
  String get quickTemplates => 'قوالب سريعة';

  @override
  String get targetStreakDays => 'السلسلة المستهدفة (أيام)';

  @override
  String get targetSuccessRatePercent => 'معدل النجاح المستهدف (%)';

  @override
  String get targetCompletions => 'مرات الإنجاز المستهدفة';

  @override
  String get noActiveGoal => 'لا يوجد هدف نشط';

  @override
  String get bestStreakDaysMetric => 'أفضل سلسلة (أيام)';

  @override
  String get successRatePercentMetric => 'معدل النجاح (%)';

  @override
  String get streakHint => 'مثال: 90 (يومًا من الالتزام)';

  @override
  String get percentageHint => 'مثال: 80 (بالمائة نجاح)';

  @override
  String get completionsHint => 'مثال: 100 (مرة إنجاز)';

  @override
  String daysCleanTemplate(String count) {
    return '$count أيام التزام';
  }

  @override
  String successPercentTemplate(String count) {
    return '$count% نجاح';
  }

  @override
  String daysStreakTemplate(String count) {
    return 'سلسلة $count أيام';
  }

  @override
  String completionsTemplate(String count) {
    return '$count مرات إنجاز';
  }

  @override
  String get icon => 'الأيقونة';

  @override
  String get colorTheme => 'لون المظهر';

  @override
  String get name => 'الاسم';

  @override
  String get nameHintPlaceholder => 'مثال: قراءة الكتب، ممارسة الرياضة';

  @override
  String get notes => 'الملاحظات';

  @override
  String get notesOptional => 'الملاحظات (اختياري)';

  @override
  String get notesHintOptional => 'وصف أو ملاحظات اختيارية';

  @override
  String get category => 'التصنيف';

  @override
  String get newCategoryOptional => 'تصنيف جديد (اختياري)';

  @override
  String get newCategoryHint => 'مثال: رياضة، تعلم، صحة';

  @override
  String get daily => 'يوميًا';

  @override
  String get weekdays => 'أيام العمل';

  @override
  String get weekends => 'عطلة نهاية الأسبوع';

  @override
  String get customDays => 'أيام مخصصة';

  @override
  String get xTimesPerWeek => 'عدد مرات / أسبوع';

  @override
  String get xTimesPerMonth => 'عدد مرات / شهر';

  @override
  String get timesPerWeek => 'مرات في الأسبوع';

  @override
  String get timesPerMonth => 'مرات في الشهر';

  @override
  String get countTimes => 'عدد/مرات';

  @override
  String get minutes => 'دقائق';

  @override
  String get hours => 'ساعات';

  @override
  String get pages => 'صفحات';

  @override
  String get kilometers => 'كيلومترات';

  @override
  String get miles => 'أميال';

  @override
  String get grams => 'جرامات';

  @override
  String get pounds => 'أرطال';

  @override
  String get dollars => 'دولارات';

  @override
  String get custom => 'مخصص';

  @override
  String get maximumLimit => 'الحد الأقصى';

  @override
  String get dailyTarget => 'الهدف اليومي';

  @override
  String get targetAmount => 'الكمية المستهدفة';

  @override
  String get maxLimitHint => 'مثال: 0 (لا يُسمح بأي فشل)';

  @override
  String get targetValueHint => 'مثال: 30 (قراءة 30 صفحة)';

  @override
  String get targetAmountHint => 'مثال: 10 (تأمل 10 دقائق)';

  @override
  String skippingDate(String date) {
    return 'تخطي يوم $date';
  }

  @override
  String get trackFailure => 'تتبع الفشل';

  @override
  String get trackProgress => 'تتبع التقدم';

  @override
  String get markDone => 'تعليم كمكتمل';

  @override
  String get trackSuccess => 'تتبع النجاح';

  @override
  String get markCompletion => 'تسجيل الإنجاز';

  @override
  String get date => 'التاريخ';

  @override
  String get entryExistsForDay => 'يوجد سجل بالفعل لهذا اليوم.';

  @override
  String get noHabitsForToday => 'لا توجد عادات اليوم';

  @override
  String get createHabitToGetStarted => 'أنشئ عادة جديدة للبدء!';

  @override
  String get skipThisDay => 'تخطي هذا اليوم؟';

  @override
  String get skipThisDaySubtitle =>
      'لن يكسر سلسلتك المتتالية أو يؤثر على إحصاءاتك';

  @override
  String get didYouCompleteToday => 'هل أكملت هذه العادة اليوم؟';

  @override
  String get completedCheck => 'مكتمل ✓';

  @override
  String get notCompletedCross => 'غير مكتمل ✗';

  @override
  String get targetGoal => 'الهدف المستهدف';

  @override
  String get progressStatus => 'حالة التقدم';

  @override
  String get whySkippingToday => 'لماذا تتخطى اليوم؟';

  @override
  String get whySkippingHint => 'مثال: مريض، مسافر، يوم راحة مخطط له...';

  @override
  String get skipDay => 'تخطي اليوم';

  @override
  String get saveEntry => 'حفظ السجل';

  @override
  String get withinLimit => 'ضمن الحد ✓';

  @override
  String overLimitBy(String amount) {
    return 'تجاوز الحد بمقدار $amount';
  }

  @override
  String get targetReached => 'تم الوصول للهدف! ✓';

  @override
  String needMore(String amount) {
    return 'بحاجة لـ $amount إضافية';
  }

  @override
  String get goalAchieved => 'تم تحقيق الهدف! ✓';

  @override
  String get progressTowardsGoal => 'التقدم نحو الهدف';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get startJourneyTitle => 'ابدأ رحلتك!';

  @override
  String get startJourneySubtitle => 'الصفحة البيضاء هي بداية العظمة.';

  @override
  String get startJourneyMsg =>
      'لم يتم تتبع أي عادات بعد. اليوم هو اليوم المثالي لبناء قوة جديدة! أنا أؤمن بك! 💪';

  @override
  String get stayStrongTitle => 'كن قويًا!';

  @override
  String get stayStrongSubtitle => 'كل عقبة هي فرصة للعودة بقوة أكبر.';

  @override
  String get stayStrongMsg =>
      'أنت قوي، يمكنك تحقيق أكثر من 10%. أنا أؤمن بك! لنحطم التحدي القادم! 🏋️‍♂️';

  @override
  String get keepBuildingTitle => 'واصل البناء!';

  @override
  String get keepBuildingSubtitle => 'النمو الحقيقي يستغرق وقتًا.';

  @override
  String get keepBuildingMsg =>
      'التقدم هو تقدم! استمر في بناء تلك القوة. أنت تصبح أقوى كل يوم! ⚡';

  @override
  String get consistencyPaysTitle => 'الاستمرارية تؤتي ثمارها!';

  @override
  String get consistencyPaysSubtitle => 'أنت تبني زخمًا رائعًا.';

  @override
  String get consistencyPaysMsg =>
      'استمرارية مذهلة! أنت تبني عاداتك كالبطل! واصل التقدم! 🔥';

  @override
  String get legendaryConsistencyTitle => 'استمرارية أسطورية!';

  @override
  String get legendaryConsistencySubtitle => 'ملكية مطلقة.';

  @override
  String get legendaryConsistencyMsg =>
      'نجاح استثنائي! أنت ملك في الالتزام. أسطورة تولد الآن! 👑';

  @override
  String get occStudent => 'طالب';

  @override
  String get occWorking => 'يعمل';

  @override
  String get occShiftWorker => 'عامل بنظام المناوبات';

  @override
  String get occParent => 'والد/والدة';

  @override
  String get occRetired => 'متقاعد';

  @override
  String get occOther => 'أخرى';

  @override
  String get areaHealth => 'اللياقة البدنية والصحة';

  @override
  String get areaGrowth => 'التعلم والإنتاجية';

  @override
  String get areaFinances => 'المالية';

  @override
  String get areaMental => 'اليقظة الذهنية والصحة النفسية';

  @override
  String get areaHome => 'الروتين والتنظيم المنزلي';

  @override
  String get areaSleep => 'النوم';

  @override
  String get areaRelationships => 'العلاقات الاجتماعية';

  @override
  String get weekdaysMonFri => 'أيام العمل (الإثنين - الجمعة)';

  @override
  String get weekdaysSunThu => 'أيام العمل (الأحد - الخميس)';

  @override
  String get weekdaysSatWed => 'أيام العمل (السبت - الأربعاء)';

  @override
  String get weekendsSatSun => 'عطلة نهاية الأسبوع (السبت - الأحد)';

  @override
  String get weekendsFriSat => 'عطلة نهاية الأسبوع (الجمعة - السبت)';

  @override
  String get weekendsThuFri => 'عطلة نهاية الأسبوع (الخميس - الجمعة)';

  @override
  String get unknown => 'غير معروف';

  @override
  String get triggerHint => 'ما الذي أدى إلى ذلك؟ أي أفكار...';

  @override
  String get enterValue => 'أدخل القيمة';

  @override
  String get enterAmount => 'أدخل الكمية';

  @override
  String get value => 'القيمة';

  @override
  String get amount => 'الكمية';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get skippedDay => 'يوم متخطى';

  @override
  String get habitCorrelations => 'ارتباطات العادات';

  @override
  String get habitCorrelationsDesc =>
      'يوضح العادات التي تميل إلى النجاح أو الفشل معًا. معامل الارتباط القريب من 1.0 يعني حدوثهما معًا، بينما -1.0 يعني نجاح إحداهما وفشل الأخرى.';

  @override
  String get notEnoughDataCorrelations =>
      'لا تتوفر بيانات كافية لحساب الارتباطات بعد';

  @override
  String get habit1 => 'العادة 1';

  @override
  String get habit2 => 'العادة 2';

  @override
  String get strength => 'القوة';

  @override
  String get performanceInsights => 'رؤى الأداء';

  @override
  String get notEnoughDataInsights =>
      'أضف المزيد من السجلات لإنشاء الرؤى والتحليلات!';

  @override
  String get bestPerformer => 'الأفضل أداءً';

  @override
  String bestPerformerDesc(String habitName, String rate) {
    return 'عادة $habitName حققت نسبة نجاح $rate%';
  }

  @override
  String get mostConsistent => 'الأكثر التزامًا';

  @override
  String mostConsistentDesc(String habitName, String streak) {
    return 'عادة $habitName مستمرة في سلسلة منذ $streak يومًا';
  }

  @override
  String get mostActiveDay => 'اليوم الأكثر نشاطًا';

  @override
  String mostActiveDayDesc(String dayName, String count) {
    return 'يوم $dayName مع $count من السجلات';
  }

  @override
  String get recommendations => 'التوصيات والترشيحات';

  @override
  String get notEnoughDataRecommendations =>
      'واصل التتبع لتلقي التوصيات المخصصة لك!';

  @override
  String strugglingHabitRec(String habitName) {
    return 'فكر في مراجعة عادة $habitName - حاول ضبط الهدف أو التكرار';
  }

  @override
  String staleHabitRec(String habitName) {
    return 'لم تقم بتسجيل عادة $habitName مؤخرًا - فكر في إضافة سجل جديد';
  }

  @override
  String correlationRec(String habit1, String habit2) {
    return 'عادة $habit1 وعادة $habit2 تسيران معًا بشكل جيد - فكر في القيام بهما بالتوالي';
  }

  @override
  String get aggregateActivityHeatmap => 'خريطة حرارة النشاط الإجمالي';

  @override
  String get noEntries => 'لا توجد سجلات';

  @override
  String succeededFailures(String actual, String limit) {
    return 'نجح ($actual/$limit إخفاقات)';
  }

  @override
  String failedFailures(String actual, String limit) {
    return 'فشل ($actual/$limit إخفاقات)';
  }

  @override
  String completedUnit(String actual, String target, String unit) {
    return 'تم إنجاز $actual/$target $unit';
  }

  @override
  String habitsCompleted(String successes, String total) {
    return 'تم إنجاز $successes/$total من العادات';
  }

  @override
  String get selectFont => 'اختر الخط';

  @override
  String get searchFonts => 'البحث عن الخطوط...';

  @override
  String get font => 'الخط';
}
