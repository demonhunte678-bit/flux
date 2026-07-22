import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/core/index.dart';
import 'package:flux/data/index.dart';

class BackupImportPage extends ConsumerWidget {
  const BackupImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupState = ref.watch(backupProvider);

    ref.listen<BackupState>(backupProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Backup & Restore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: backupState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.folder_special_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Backup Storage Folder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupState.backupFolderPath ??
                                'No folder set (e.g. create and pick "flux backups" outside Flux)',
                            style: TextStyle(
                              fontSize: 13,
                              color: backupState.backupFolderPath != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.grey,
                              fontWeight: backupState.backupFolderPath != null
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              ref.read(backupProvider.notifier).setBackupFolder();
                            },
                            icon: const Icon(Icons.folder_open_rounded),
                            label: Text(
                              backupState.backupFolderPath == null
                                  ? 'Select Backup Folder'
                                  : 'Change Folder',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: SwitchListTile(
                      value: backupState.isAutoBackupEnabled,
                      onChanged: (enabled) {
                        ref.read(backupProvider.notifier).toggleAutoBackup(enabled);
                      },
                      title: const Text(
                        'Automatic Daily Backup',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Creates a backup file automatically when you open Flux once per day.',
                        style: TextStyle(fontSize: 12),
                      ),
                      secondary: Icon(
                        Icons.sync_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ref.read(backupProvider.notifier).exportDatabase();
                          },
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Export Now'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmAndImport(context, ref, null),
                          icon: const Icon(Icons.upload_file_rounded),
                          label: const Text('Browse File'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Backups',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () {
                          ref.read(backupProvider.notifier).loadSettingsAndBackups();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (backupState.availableBackups.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No backup files found in this folder.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: backupState.availableBackups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final backup = backupState.availableBackups[index];
                        final dateStr =
                            '${backup.modified.year}-${backup.modified.month.toString().padLeft(2, '0')}-${backup.modified.day.toString().padLeft(2, '0')} ${backup.modified.hour.toString().padLeft(2, '0')}:${backup.modified.minute.toString().padLeft(2, '0')}';

                        return Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.storage_rounded, color: Colors.blue),
                            title: Text(
                              backup.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '$dateStr • ${backup.formattedSize} • ${backup.habitCount} Habits',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: TextButton(
                              onPressed: () => _confirmAndImport(context, ref, backup.path),
                              child: const Text('Restore'),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  void _confirmAndImport(
    BuildContext context,
    WidgetRef ref,
    String? filePath,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Database?'),
        content: Text(
          filePath != null
              ? 'This will restore all your habits and entries from this backup file. Current data will be replaced.'
              : 'This will overwrite all your current habits and entries with the selected backup file. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(backupProvider.notifier).importDatabase(filePath: filePath);
    }
  }
}
