import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackupState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  BackupState({this.isLoading = false, this.errorMessage, this.successMessage});
}

class BackupNotifier extends StateNotifier<BackupState> {
  final Ref ref;
  BackupNotifier(this.ref) : super(BackupState());

  Future<bool> exportDatabase() async {
    state = BackupState(isLoading: true);
    try {
      final success = await BackupService.createDatabaseBackup();
      if (success) {
        state = BackupState(successMessage: 'Backup exported successfully!');
        return true;
      } else {
        state = BackupState(
          errorMessage: 'Export failed: Location not chosen.',
        );
        return false;
      }
    } catch (e) {
      state = BackupState(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> importDatabase() async {
    state = BackupState(isLoading: true);
    try {
      final result = await BackupService.importDatabaseBackup();
      if (result.success) {
        state = BackupState(successMessage: 'Database imported successfully!');
        // Refresh habits list automatically
        ref.read(habitsProvider.notifier).loadHabits();
        return true;
      } else {
        state = BackupState(errorMessage: result.errors.join(', '));
        return false;
      }
    } catch (e) {
      state = BackupState(errorMessage: e.toString());
      return false;
    }
  }
}

final backupProvider = StateNotifierProvider<BackupNotifier, BackupState>((
  ref,
) {
  return BackupNotifier(ref);
});
