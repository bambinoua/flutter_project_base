import 'package:charcode/charcode.dart';
import 'package:flutter_project_base/src/basic_types.dart';

/// Provides some helper functions.
abstract class Helper {
  Helper._();

  /// Returns the `list` of type T from dynamic list safely.
  ///
  /// If `list` is null than empty list is returned.
  static List<T> safeList<T>(List? list) => List<T>.from(list ?? <T>[]);

  /// Returns the instance of type T from `map` safely.
  ///
  /// If `map` is null than null is returned.
  static T? safeInstance<T>(Map<String, dynamic>? map,
          GenericTypeProvider<T, Map<String, dynamic>> constructor,
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
}

/// Provides some usefull HTML entities
class Char {
  Char._();

  /// bullet (black small circle) ('•')
  static final bull = String.fromCharCode($bull);

  /// copyright symbol ('©')
  static final copy = String.fromCharCode($copy);

  /// black diamond suit ('♦')
  static final diamond = String.fromCharCode($diams);

  /// em dash ('—')
  static final mdash = String.fromCharCode($mdash);
}

extension FileSizeExtension on FileSize {
  String formatSizeInBytesToScaledSize({int decimals = 0}) =>
      Helper.formatSizeInBytesToScaledSize(this, decimals: decimals);
}
