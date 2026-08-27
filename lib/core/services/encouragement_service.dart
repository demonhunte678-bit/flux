import 'package:flutter/material.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

class EncouragementData {
  final String title;
  final String subtitle;
  final String message;
  final Color color;
  final IconData icon;

  const EncouragementData({
    required this.title,
    required this.subtitle,
    required this.message,
    required this.color,
    required this.icon,
  });
}

class EncouragementService {
  static EncouragementData getEncouragement(BuildContext context, double successRate, bool hasData) {
    if (!hasData) {
      return EncouragementData(
        title: L10n.of(context)!.startJourneyTitle,
        subtitle: L10n.of(context)!.startJourneySubtitle,
        message: L10n.of(context)!.startJourneyMsg,
        color: Colors.purple,
        icon: Icons.fitness_center,
      );
    }

    if (successRate < 10.0) {
      return EncouragementData(
        title: L10n.of(context)!.stayStrongTitle,
        subtitle: L10n.of(context)!.stayStrongSubtitle,
        message: L10n.of(context)!.stayStrongMsg,
        color: Colors.amber, // Legendary gold color
        icon: Icons.fitness_center, // Muscle icon
      );
    } else if (successRate >= 10.0 && successRate < 50.0) {
      return EncouragementData(
        title: L10n.of(context)!.keepBuildingTitle,
        subtitle: L10n.of(context)!.keepBuildingSubtitle,
        message: L10n.of(context)!.keepBuildingMsg,
        color: Colors.deepPurple,
        icon: Icons.fitness_center,
      );
    } else if (successRate >= 50.0 && successRate < 90.0) {
      return EncouragementData(
        title: L10n.of(context)!.consistencyPaysTitle,
        subtitle: L10n.of(context)!.consistencyPaysSubtitle,
        message: L10n.of(context)!.consistencyPaysMsg,
        color: Colors.green,
        icon: Icons.fitness_center,
      );
    } else {
      return EncouragementData(
        title: L10n.of(context)!.legendaryConsistencyTitle,
        subtitle: L10n.of(context)!.legendaryConsistencySubtitle,
        message: L10n.of(context)!.legendaryConsistencyMsg,
        color: Colors.amber.shade700,
        icon: Icons.fitness_center,
      );
    }
  }
}
