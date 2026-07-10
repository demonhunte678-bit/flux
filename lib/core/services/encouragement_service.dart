import 'package:flutter/material.dart';

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
  static EncouragementData getEncouragement(double successRate, bool hasData) {
    if (!hasData) {
      return const EncouragementData(
        title: "Start Your Journey!",
        subtitle: "A blank slate is the beginning of greatness.",
        message:
            "No habits tracked yet. Today is the perfect day to build new muscle! I believe in you! 💪",
        color: Colors.purple,
        icon: Icons.fitness_center,
      );
    }

    if (successRate < 10.0) {
      return const EncouragementData(
        title: "Stay Strong!",
        subtitle: "Every setback is a setup for a comeback.",
        message:
            "You are strong, you can get more than 10%. I believe in you! Let's crush the next check! 🏋️‍♂️",
        color: Colors.amber, // Legendary gold color
        icon: Icons.fitness_center, // Muscle icon
      );
    } else if (successRate >= 10.0 && successRate < 50.0) {
      return const EncouragementData(
        title: "Keep Building!",
        subtitle: "Real growth takes time.",
        message:
            "Progress is progress! Keep building that muscle. You're getting stronger every single day! ⚡",
        color: Colors.deepPurple,
        icon: Icons.fitness_center,
      );
    } else if (successRate >= 50.0 && successRate < 90.0) {
      return const EncouragementData(
        title: "Consistency pays off!",
        subtitle: "You're building momentum.",
        message:
            "Outstanding consistency! You are building habits like a champion! Keep pushing! 🔥",
        color: Colors.green,
        icon: Icons.fitness_center,
      );
    } else {
      return EncouragementData(
        title: "Legendary Consistency!",
        subtitle: "Absolute royalty.",
        message:
            "Phenomenal success! You are absolute royalty. A legend in the making! 👑",
        color: Colors.amber.shade700,
        icon: Icons.fitness_center,
      );
    }
  }
}
