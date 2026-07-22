import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flux/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

class BackupService {
  static const String _dbBackupFileName = 'flux_backup';

  // Select custom folder for backups
  static Future<String?> selectBackupFolder() async {
    final String? selectedDirectory = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select Backup Folder (e.g. flux backups)',
    );
    if (selectedDirectory != null) {
      await SettingsService.setBackupFolderPath(selectedDirectory);
    }
    return selectedDirectory;
  }

  // Create ZIP backup containing DB and shared_prefs.json
  static Future<bool> createDatabaseBackup({String? targetFolderPath, String? customName}) async {
    try {
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final filename = customName ?? '${_dbBackupFileName}_$timestamp.zip';
      final dbPath = await DataService.exportToSql();
      final prefsFile = await PathService.getSharedPrefsFile();

      String? selectedDirectory = targetFolderPath ?? await SettingsService.getBackupFolderPath();

      if (selectedDirectory == null || selectedDirectory.isEmpty) {
        selectedDirectory = await FilePicker.getDirectoryPath(
          dialogTitle: 'Choose backup location',
        );
      }

      if (selectedDirectory == null || selectedDirectory.isEmpty) {
        throw Exception('No location selected for backup');
      }

      final dir = Directory(selectedDirectory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Create ZIP Archive
      final archive = Archive();

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        final dbBytes = await dbFile.readAsBytes();
        archive.addFile(ArchiveFile('flux_habits_drift.db', dbBytes.length, dbBytes));
      }

      if (await prefsFile.exists()) {
        final prefsBytes = await prefsFile.readAsBytes();
        archive.addFile(ArchiveFile('shared_prefs.json', prefsBytes.length, prefsBytes));
      }

      final encoder = ZipEncoder();
      final zipData = encoder.encode(archive);

      if (zipData == null) {
        throw Exception('Failed to encode backup zip file');
      }

      final targetFile = File('$selectedDirectory/$filename');
      await targetFile.writeAsBytes(zipData);

      return true;
    } catch (e) {
      throw Exception('Failed to create backup zip: $e');
    }
  }

  // Perform daily auto backup if enabled and configured
  static Future<void> performDailyAutoBackupIfEnabled() async {
    final isEnabled = await SettingsService.isAutoBackupEnabled();
    if (!isEnabled) return;

    final folderPath = await SettingsService.getBackupFolderPath();
    if (folderPath == null || folderPath.isEmpty) return;

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastBackupDate = await SettingsService.getLastAutoBackupDate();
    if (lastBackupDate == todayStr) return;

    try {
      await createDatabaseBackup(
        targetFolderPath: folderPath,
        customName: '${_dbBackupFileName}_auto_$todayStr.zip',
      );
      await SettingsService.setLastAutoBackupDate(todayStr);
    } catch (e) {
      print('Auto backup error: $e');
    }
  }

  // Import database & settings from backup file (.zip or legacy .db)
  static Future<ImportBackupResult> importDatabaseBackup({String? filePath}) async {
    try {
      String? selectedPath = filePath;
      String? fileName;

      if (selectedPath == null) {
        FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['zip', 'db'],
          dialogTitle: 'Select Flux backup file (.zip or .db) to import',
        );

        if (result == null || result.files.single.path == null) {
          throw Exception('No file selected');
        }

        selectedPath = result.files.single.path!;
        fileName = result.files.single.name;
      } else {
        fileName = File(selectedPath).uri.pathSegments.last;
      }

      final file = File(selectedPath);
      if (!await file.exists()) {
        throw Exception('Backup file does not exist');
      }

      if (selectedPath.endsWith('.zip')) {
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        ArchiveFile? dbArchiveFile;
        ArchiveFile? prefsArchiveFile;

        for (final entry in archive) {
          if (entry.name == 'flux_habits_drift.db' || entry.name.endsWith('.db')) {
            dbArchiveFile = entry;
          } else if (entry.name == 'shared_prefs.json' || entry.name.endsWith('.json')) {
            prefsArchiveFile = entry;
          }
        }

        if (dbArchiveFile == null) {
          throw Exception('No database file found in backup ZIP archive.');
        }

        // Unpack database to temporary location and restore
        final tempDir = await getTemporaryDirectory();
        final tempDbFile = File('${tempDir.path}/temp_restore_db.db');
        await tempDbFile.writeAsBytes(dbArchiveFile.content as List<int>);

        final validation = await validateBackup(tempDbFile.path);
        if (!validation.isValid) {
          throw Exception('Invalid database contained in ZIP: ${validation.issues.join(", ")}');
        }

        await DataService.importFromDatabase(tempDbFile.path);
        await tempDbFile.delete();

        // Restore settings JSON if present
        if (prefsArchiveFile != null) {
          final targetPrefsFile = await PathService.getSharedPrefsFile();
          if (!await targetPrefsFile.parent.exists()) {
            await targetPrefsFile.parent.create(recursive: true);
          }
          await targetPrefsFile.writeAsBytes(prefsArchiveFile.content as List<int>);
          await SettingsService.reloadSettings();
        }
      } else {
        // Legacy .db file support
        final validation = await validateBackup(selectedPath);
        if (!validation.isValid) {
          throw Exception('Selected file is not a valid database backup: ${validation.issues.join(", ")}');
        }
        await DataService.importFromDatabase(selectedPath);
      }

      return ImportBackupResult(
        success: true,
        errors: [],
        fileName: fileName,
      );
    } catch (e) {
      return ImportBackupResult(
        success: false,
        errors: [e.toString()],
        fileName: null,
      );
    }
  }

  // Validate backup file (.zip or .db)
  static Future<BackupValidationResult> validateBackup(String filePath) async {
    try {
      if (filePath.endsWith('.zip')) {
        final bytes = await File(filePath).readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        final dbArchiveFile = archive.firstWhere(
          (e) => e.name == 'flux_habits_drift.db' || e.name.endsWith('.db'),
          orElse: () => ArchiveFile('', 0, []),
        );

        if (dbArchiveFile.size == 0) {
          return BackupValidationResult(
            isValid: false,
            issues: ['ZIP does not contain database file'],
            habitCount: 0,
          );
        }

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/validate_temp.db');
        await tempFile.writeAsBytes(dbArchiveFile.content as List<int>);
        final res = await _validateDbFile(tempFile.path);
        await tempFile.delete();
        return res;
      } else {
        return await _validateDbFile(filePath);
      }
    } catch (e) {
      return BackupValidationResult(
        isValid: false,
        issues: ['Could not read backup archive: $e'],
        habitCount: 0,
      );
    }
  }

  static Future<BackupValidationResult> _validateDbFile(String filePath) async {
    try {
      final db = sql.sqlite3.open(filePath);
      final tables = db.select(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='habits'",
      );
      final isValid = tables.isNotEmpty;
      int habitCount = 0;

      if (isValid) {
        final countResult = db.select("SELECT count(*) as cnt FROM habits");
        if (countResult.isNotEmpty) {
          habitCount = countResult.first['cnt'] as int;
        }
      }

      db.dispose();
      return BackupValidationResult(
        isValid: isValid,
        issues: isValid ? [] : ['Not a valid Flux database'],
        habitCount: habitCount,
      );
    } catch (e) {
      return BackupValidationResult(
        isValid: false,
        issues: ['Could not open database file: $e'],
        habitCount: 0,
      );
    }
  }

  // Get backup directory
  static Future<String> getBackupDirectory() async {
    final customFolder = await SettingsService.getBackupFolderPath();
    if (customFolder != null && customFolder.isNotEmpty) {
      return customFolder;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getExternalStorageDirectory();
      return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  // List available backups in default or configured directory (.zip and .db)
  static Future<List<BackupFileInfo>> listAvailableBackups({String? folderPath}) async {
    try {
      final backupDir = folderPath ?? await getBackupDirectory();
      final directory = Directory(backupDir);

      if (!await directory.exists()) {
        return [];
      }

      final files = await directory
          .list()
          .where((entity) => entity is File && (entity.path.endsWith('.zip') || entity.path.endsWith('.db')))
          .cast<File>()
          .toList();

      List<BackupFileInfo> backups = [];

      for (final file in files) {
        try {
          final validation = await validateBackup(file.path);
          if (!validation.isValid) continue;

          final stats = await file.stat();

          backups.add(
            BackupFileInfo(
              name: file.uri.pathSegments.last,
              path: file.path,
              size: stats.size,
              modified: stats.modified,
              isValid: validation.isValid,
              habitCount: validation.habitCount,
            ),
          );
        } catch (e) {
          // Skip invalid files
        }
      }

      // Sort by modification date, newest first
      backups.sort((a, b) => b.modified.compareTo(a.modified));

      return backups;
    } catch (e) {
      return [];
    }
  }
}

// Result classes
class ImportBackupResult {
  final bool success;
  final List<String> errors;
  final String? fileName;

  ImportBackupResult({
    required this.success,
    required this.errors,
    this.fileName,
  });

  bool get hasErrors => errors.isNotEmpty;
}

class BackupValidationResult {
  final bool isValid;
  final List<String> issues;
  final int habitCount;

  BackupValidationResult({
    required this.isValid,
    required this.issues,
    required this.habitCount,
  });
}

class BackupFileInfo {
  final String name;
  final String path;
  final int size;
  final DateTime modified;
  final bool isValid;
  final int habitCount;

  BackupFileInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.modified,
    required this.isValid,
    required this.habitCount,
  });

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
