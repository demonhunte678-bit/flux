import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flux/l10n/localized_string.dart';

abstract class OnboardStep {
  LocalizedString get stepName;
  LocalizedString? get title;
  LocalizedString? get subtitle;
  Widget buildContent(BuildContext context, WidgetRef ref, Color stepColor);
  bool canProceed(WidgetRef ref);
}
