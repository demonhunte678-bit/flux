import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

class BackupState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isAutoBackupEnabled;
  final String? backupFolderPath;
  final List<BackupFileInfo> availableBackups;

  BackupState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isAutoBackupEnabled = false,
    this.backupFolderPath,
    this.availableBackups = const [],
  });

  BackupState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isAutoBackupEnabled,
    String? backupFolderPath,
    List<BackupFileInfo>? availableBackups,
  }) {
    return BackupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isAutoBackupEnabled: isAutoBackupEnabled ?? this.isAutoBackupEnabled,
      backupFolderPath: backupFolderPath ?? this.backupFolderPath,
      availableBackups: availableBackups ?? this.availableBackups,
    );
  }
}

class BackupNotifier extends StateNotifier<BackupState> {
  final Ref ref;
  BackupNotifier(this.ref) : super(BackupState()) {
    loadSettingsAndBackups();
  }

  Future<void> loadSettingsAndBackups() async {
    final autoBackup = await SettingsService.isAutoBackupEnabled();
    final folderPath = await SettingsService.getBackupFolderPath();
    final backups = await BackupService.listAvailableBackups(folderPath: folderPath);

    state = state.copyWith(
      isAutoBackupEnabled: autoBackup,
      backupFolderPath: folderPath,
      availableBackups: backups,
    );
  }

  Future<bool> setBackupFolder() async {
    try {
      final path = await BackupService.selectBackupFolder();
      if (path != null) {
        await SettingsService.setBackupFolderPath(path);
        await loadSettingsAndBackups();
        state = state.copyWith(
          successMessage: 'Backup folder set to: $path',
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> toggleAutoBackup(bool enabled) async {
    if (enabled && (state.backupFolderPath == null || state.backupFolderPath!.isEmpty)) {
      final success = await setBackupFolder();
      if (!success) return;
    }
    await SettingsService.setAutoBackupEnabled(enabled);
    if (enabled) {
      await BackupService.performDailyAutoBackupIfEnabled();
    }
    await loadSettingsAndBackups();
  }

  Future<bool> exportDatabase() async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await BackupService.createDatabaseBackup(
        targetFolderPath: state.backupFolderPath,
      );
      if (success) {
        await loadSettingsAndBackups();
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Backup exported successfully!',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Export failed: Location not chosen.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> importDatabase({String? filePath}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await BackupService.importDatabaseBackup(filePath: filePath);
      if (result.success) {
        ref.read(habitsProvider.notifier).loadHabits();
        await loadSettingsAndBackups();
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Database imported successfully!',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.errors.join(', '),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final backupProvider = StateNotifierProvider<BackupNotifier, BackupState>((
  ref,
) {
  return BackupNotifier(ref);
});
