import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/pages/backup_import_page.dart';
import '../../l10n/localizations_extension.dart';
import '../onboard_step.dart';
import 'package:flux/l10n/localized_string.dart';

class WelcomeStep implements OnboardStep {
  final VoidCallback onSkip;
  final VoidCallback onNext;

  WelcomeStep({required this.onSkip, required this.onNext});

  @override
  LocalizedString get stepName => LocalizedString((l) => l.welcomeStepName);

  @override
  LocalizedString? get title => LocalizedString((l) => l.welcomeTitle);

  @override
  LocalizedString? get subtitle => LocalizedString((l) => l.welcomeSubtitle);

  @override
  bool canProceed(WidgetRef ref) {
    return true;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildChoiceCard(
            context,
            title: context.l10n.guidedSetup,
            desc: context.l10n.guidedSetupDesc,
            icon: Icons.auto_awesome,
            color: stepColor,
            onTap: onNext,
          ),
          const SizedBox(height: 16),
          _buildChoiceCard(
            context,
            title: context.l10n.restoreBackup,
            desc: context.l10n.restoreBackupDesc,
            icon: Icons.backup_outlined,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BackupImportPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildChoiceCard(
            context,
            title: context.l10n.quickStart,
            desc: context.l10n.quickStartDesc,
            icon: Icons.flash_on_outlined,
            color: Colors.orange,
            onTap: onSkip,
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
