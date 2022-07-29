import 'package:charcode/charcode.dart';
import 'package:meta/meta.dart';

/// HTML entities.
@sealed
class HtmlEntity {
  HtmlEntity._();

  /// bullet (black small circle) ('•')
  static final bull = String.fromCharCode($bull);

  /// copyright symbol ('©')
  static final copy = String.fromCharCode($copy);

  /// black diamond suit ('♦')
  static final diamond = String.fromCharCode($diams);

  /// em dash ('—')
  static final mdash = String.fromCharCode($mdash);
}

/// Colos ANSI codes.
@sealed
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

@sealed
class RegularExpressions {
  RegularExpressions._();

  /// Whether string formatted as ISO-8601 datetime.
  ///
  /// Example: 2022-02-22T10:10:10.100Z
  static final dateIso8601 = RegExp(
      r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,6})?Z?$',
      caseSensitive: false);

  /// Whether string is a numeric.
  static final numeric = RegExp(r'^-?\d*\.?\d*$');
}
