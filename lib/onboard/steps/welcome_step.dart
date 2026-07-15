import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
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
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: stepColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.explore,
            size: 60,
            color: stepColor,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Welcome to Flux!',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Let's build amazing habits together! Choose your path to get started with personalized recommendations.",
          style: TextStyle(
            color: Colors.grey[600],
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

  Widget _buildOptionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color stepColor,
    bool isPrimary = false,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary ? stepColor : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        side: BorderSide(
          color: isPrimary ? Colors.transparent : Colors.grey.withValues(alpha: 0.2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isPrimary ? Colors.white.withValues(alpha: 0.7) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
