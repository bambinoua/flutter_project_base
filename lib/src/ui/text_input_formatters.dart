import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Provides text input formatters.
abstract class TextInputFormatters {
  TextInputFormatters._();

  /// Converts all characters to upper case.
  static const uppercase = UppercaseTextInputFormatter();

  /// Formats string as European date `12.10.2022`.
  static final europeanDate = MaskTextInputFormatter(
    mask: '12.34.5678',
    filter: {
      '1': RegExp(r'[0-3]?'),
      '2': RegExp(r'[0-9]'),
      '3': RegExp(r'[0-1]?'),
      '4': RegExp(r'[0-2]'),
      '5': RegExp(r'[1-2]'),
      '6': RegExp(r'[0-9]'),
      '7': RegExp(r'[0-9]'),
      '8': RegExp(r'[0-9]'),
    },
  );
}

class UppercaseTextInputFormatter implements TextInputFormatter {
  const UppercaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
