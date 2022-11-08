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
