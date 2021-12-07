import 'package:charcode/charcode.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_project_base/src/basic_types.dart';
import 'package:flutter_project_base/src/core/date.dart';

/// Provides some helper functions.
class Helper {
  Helper._();

  /// Returns the `list` of type T from dynamic list safely.
  ///
  /// If `list` is null than empty list is returned.
  static List<T> safeList<T>(List? list) => List<T>.from(list ?? <T>[]);

  /// Returns the instance of type T from `map` safely.
  ///
  /// If `map` is null than null is returned.
  static T? safeInstance<T>(Map<String, dynamic>? map,
          InstanceProviderV<T, Map<String, dynamic>> constructor,
          [T? defaultInstance]) =>
      map != null ? constructor(map) : defaultInstance;

  /// Returns the instance of [Date] type from `formattedString` safely.
  ///
  /// If `formattedString` is null than null is returned.
  static Date? safeDate(String? formattedString) =>
      Date.tryParse(formattedString ?? '');

  /// Returns the instance of [DateTime] type from `formattedString` safely.
  ///
  /// If `formattedString` is null than null is returned.
  static DateTime? safeDateTime(String? formattedString) =>
      DateTime.tryParse(formattedString ?? '');

  /// Converts file `size` in bytes into larger representation.
  static String formatSizeInBytesToScaledSize(num size, {int decimals = 0}) {
    var sizeRatio = 0;
    var convertedSize = size;
    while (convertedSize > 1024) {
      convertedSize /= 1024;
      sizeRatio += 1;
    }

    final formattedConvertedSize = sizeRatio == 0
        ? convertedSize.toString()
        : convertedSize.toStringAsFixed(decimals);
    return '$formattedConvertedSize ${abbreviations[sizeRatio]}';
  }

  static const abbreviations = ['bytes', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb'];

  /// Generates the list from `length` colors which starts from
  /// `startColor` and ends with `endColor`.
  ///
  /// The length must be greater than 0.
  static List<Color> generate(Color startColor, Color endColor, int length) {
    assert(length > 0, 'The length of gradient pallette cannot be zero.');
    return List.generate(length, (index) {
      final grade = index / length;
      return Color.fromARGB(
          255,
          (startColor.red * (1 - grade) + grade * endColor.red).round(),
          (startColor.green * (1 - grade) + grade * endColor.green).round(),
          (startColor.blue * (1 - grade) + grade * endColor.blue).round());
    });
  }
}

/// HTML entities.
class HtmlEntity {
  HtmlEntity._();

  static final bull = String.fromCharCode($bull);
  static final copy = String.fromCharCode($copy);
  static final diamond = String.fromCharCode($diams);
  static final mdash = String.fromCharCode($mdash);
}

/// Colos ANSI codes.
class ColorAnsiCode {
  ColorAnsiCode._();

  static const reset = '\x1B[0m';
  static const black = '\x1B[30m';
  static const white = '\x1B[37m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
}

extension FileSizeExtension on FileSize {
  String formatSizeInBytesToScaledSize({int decimals = 0}) =>
      Helper.formatSizeInBytesToScaledSize(this, decimals: decimals);
}
