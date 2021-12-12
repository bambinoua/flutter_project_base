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

  /// Returns the value of type T from JSON encoded `map` safely.
  ///
  /// If `map` is null than null is returned.
  static T? safeValue<T>(
          Json? map, DependendValueProvider<T, Json> valueProvider,
          [T? defaultValue]) =>
      map != null ? valueProvider(map) : defaultValue;

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
  static const foregroundBlack = '\x1B[30m';
  static const foregroundRed = '\x1B[31m';
  static const foregroundGreen = '\x1B[32m';
  static const foregroundYellow = '\x1B[33m';
  static const foregroundBlue = '\x1B[34m';
  static const foregroundMagenta = '\x1B[35m';
  static const foregroundCyan = '\x1B[36m';
  static const foregroundWhite = '\x1B[37m';
  static const foregroundBrightBlack = '\x1B[90m';
  static const foregroundBrightRed = '\x1B[91m';
  static const foregroundBrightGreen = '\x1B[92m';
  static const foregroundBrightYellow = '\x1B[93m';
  static const foregroundBrightBlue = '\x1B[94m';
  static const foregroundBrightMagenta = '\x1B[95m';
  static const foregroundBrightCyan = '\x1B[96m';
  static const foregroundBrightWhite = '\x1B[97m';

  static const backgroundBlack = '\x1B[40m';
  static const backgroundRed = '\x1B[41m';
  static const backgroundGreen = '\x1B[42m';
  static const backgroundYellow = '\x1B[43m';
  static const backgroundBlue = '\x1B[44m';
  static const backgroundMagenta = '\x1B[45m';
  static const backgroundCyan = '\x1B[46m';
  static const backgroundWhite = '\x1B[47m';
  static const backgroundBrightBlack = '\x1B[100m';
  static const backgroundBrightRed = '\x1B[101m';
  static const backgroundBrightGreen = '\x1B[102m';
  static const backgroundBrightYellow = '\x1B[103m';
  static const backgroundBrightBlue = '\x1B[104m';
  static const backgroundBrightMagenta = '\x1B[105m';
  static const backgroundBrightCyan = '\x1B[106m';
  static const backgroundBrightWhite = '\x1B[107m';
}

extension FileSizeExtension on FileSize {
  String formatSizeInBytesToScaledSize({int decimals = 0}) =>
      Helper.formatSizeInBytesToScaledSize(this, decimals: decimals);
}
