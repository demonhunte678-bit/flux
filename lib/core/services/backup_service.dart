import 'dart:io';
import 'package:flux/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

class BackupService {
  static const String _dbBackupFileName = 'flux_db_backup';

  // Create database backup with file save dialog
  static Future<bool> createDatabaseBackup({String? customName}) async {
    try {
      if (Platform.isAndroid) {
        final permission = await Permission.storage.request();
        if (!permission.isGranted) {
          throw Exception('Storage permission required to save backup');
        }
      }

      final timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());
      final filename = customName ?? '${_dbBackupFileName}_$timestamp.db';
      final dbPath = await DataService.exportToSql();

      String? selectedDirectory;

      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getExternalStorageDirectory();
        selectedDirectory =
            directory?.path ?? (await getApplicationDocumentsDirectory()).path;
      } else {
        selectedDirectory = await FilePicker.getDirectoryPath(
          dialogTitle: 'Choose backup location',
        );
      }

      if (selectedDirectory == null) {
        throw Exception('No location selected for backup');
      }

      final sourceFile = File(dbPath);
      final targetFile = File('$selectedDirectory/$filename');
      await sourceFile.copy(targetFile.path);

      return true;
    } catch (e) {
      throw Exception('Failed to create database backup: $e');
    }
  }

  // Import database backup with file picker dialog
  static Future<ImportBackupResult> importDatabaseBackup() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
        dialogTitle: 'Select database backup file to import',
      );

      if (result == null || result.files.single.path == null) {
        throw Exception('No file selected');
      }

      final filePath = result.files.single.path!;

      // Perform database validation before importing
      final validation = await validateBackup(filePath);
      if (!validation.isValid) {
        throw Exception(
          'Selected file is not a valid database backup: ${validation.issues.join(", ")}',
        );
      }

      await DataService.importFromDatabase(filePath);

      return ImportBackupResult(
        success: true,
        errors: [],
        fileName: result.files.single.name,
      );
    } catch (e) {
      return ImportBackupResult(
        success: false,
        errors: [e.toString()],
        fileName: null,
      );
    }
  }

  // Validate backup file
  static Future<BackupValidationResult> validateBackup(String filePath) async {
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
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getExternalStorageDirectory();
      return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  // List available backups in default directory
  static Future<List<BackupFileInfo>> listAvailableBackups() async {
    try {
      final backupDir = await getBackupDirectory();
      final directory = Directory(backupDir);

      if (!await directory.exists()) {
        return [];
      }

      final files = await directory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.db'))
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
