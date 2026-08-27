import 'package:flutter/material.dart';
import 'package:flux/l10n/generated/app_localizations.dart';

extension LocalizationsExtension on BuildContext {
  L10n get l10n => L10n.of(this)!;
}

extension LatinNumbersExtension on String {
  String toLatinNumbers() {
    const arab = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const latn = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String ret = this;
    for (int i = 0; i < 10; i++) {
      ret = ret.replaceAll(arab[i], latn[i]);
    }
    return ret;
  }
}
