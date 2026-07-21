import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';
import '../onboard_step.dart';

class WelcomeStep implements OnboardStep {
  final VoidCallback onSkip;
  final VoidCallback onNext;

  WelcomeStep({required this.onSkip, required this.onNext});

  @override
  String get stepName => 'Welcome';

  @override
  String? get title => null;

  @override
  String? get subtitle => null;

  @override
  bool canProceed(WidgetRef ref) => true;

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FluxLogo(size: 120, showBackground: true),
        const SizedBox(height: 32),
        Text(
          'Welcome to Flux!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Your journey to building better habits starts here.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                context,
                title: 'Quick Start',
                subtitle: 'Set up manually',
                icon: Icons.flash_on,
                onTap: onSkip,
                stepColor: stepColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOptionButton(
                context,
                title: 'Guided Setup',
                subtitle: 'Recommended',
                icon: Icons.map,
                onTap: onNext,
                isPrimary: true,
                stepColor: stepColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color stepColor,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary
            ? stepColor
            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        foregroundColor: isPrimary
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        side: BorderSide(
          color: isPrimary
              ? Colors.transparent
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: isPrimary ? null : stepColor,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isPrimary
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
