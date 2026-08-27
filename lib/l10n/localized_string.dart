import 'package:flutter/material.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

export 'package:flux/l10n/generated/app_localizations.dart';

class LocalizedString {
  final String Function(L10n) _resolve;

  const LocalizedString(this._resolve);

  String of(BuildContext context) {
    return _resolve(L10n.of(context)!);
  }
}
