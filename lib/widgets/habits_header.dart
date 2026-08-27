import 'package:flutter/material.dart';
import 'package:flux/core/index.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

class HabitsHeader extends StatelessWidget {
  final double overallSuccessRate;
  final bool hasHabits;
  final VoidCallback? onExploreTap;

  const HabitsHeader({
    super.key,
    required this.overallSuccessRate,
    required this.hasHabits,
    this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    final encouragement = EncouragementService.getEncouragement(
      context,
      overallSuccessRate,
      hasHabits,
    );
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_getGreeting(context)},",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  encouragement.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onExploreTap != null) ...[
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: onExploreTap,
              icon: Icon(Icons.explore_outlined, size: 16, color: theme.colorScheme.primary),
              label: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return L10n.of(context)!.goodMorning;
    if (hour < 17) return L10n.of(context)!.goodAfternoon;
    return L10n.of(context)!.goodEvening;
  }
}
