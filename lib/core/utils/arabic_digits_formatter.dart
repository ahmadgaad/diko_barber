import 'package:flutter/services.dart';

/// Converts Arabic-Indic (٠-٩) and Extended Arabic-Indic (۰-۹) digits to
/// their ASCII equivalents (0-9) so numeric fields always store English digits.
class ArabicDigitsFormatter extends TextInputFormatter {
  const ArabicDigitsFormatter();

  static const _arabicBase = 0x0660;       // ٠
  static const _extendedArabicBase = 0x06F0; // ۰

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final converted = newValue.text.replaceAllMapped(
      RegExp(r'[٠-٩۰-۹]'),
      (m) {
        final code = m[0]!.codeUnitAt(0);
        if (code >= _extendedArabicBase) {
          return (code - _extendedArabicBase).toString();
        }
        return (code - _arabicBase).toString();
      },
    );

    if (converted == newValue.text) return newValue;

    return newValue.copyWith(
      text: converted,
      selection: TextSelection.collapsed(offset: converted.length),
    );
  }
}
