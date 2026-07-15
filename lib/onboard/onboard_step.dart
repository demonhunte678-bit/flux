import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class OnboardStep {
  String get stepName;
  String? get title;
  String? get subtitle;
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor);
  bool canProceed(WidgetRef ref);
}
