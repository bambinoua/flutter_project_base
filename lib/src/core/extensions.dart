import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'basic_types.dart';
import 'date.dart';

extension Int on int {
  static const int min32bitValue = 0x80000000;
  static const int max32bitValue = 0x7fffffff;
  static const int min64bitValue =
      kIsWeb ? -9007199254740991 /* -(2^53 - 1) */ : 0x8000000000000000;
  static const int max64bitValue =
      kIsWeb ? 9007199254740991 /* 2^53 – 1 */ : 0x8000000000000000;

  /// Adds `value` to this number.
  int plus(int value) => this + value;

  /// Subtracts `value` from this number.
  int minus(int value) => this - value;

  /// Multily `value` by this number.
  int multiplyBy(int value) => this * value;

  /// Divides this number by `value`.
  double divideBy(int value) => this / value;

  /// Format number as string with leading zeros.
  String withLeadingZeros([int pad = 0]) {
    assert(!pad.isNegative);
    return toString().padLeft(pad, '0');
  }
}

extension Double on double {
  /// Adds `value` to this number.
  double plus(double value) => this + value;

  /// Subtracts `value` from this number.
  double minus(double value) => this - value;

  /// Multily `value` by this number.
  double multiplyBy(double value) => this * value;

  /// Divides this number by `value`.
  double divideBy(double value) => this * value;
}

extension Strings on String {
  /// The string with normalized whitespaces.
  ///
  /// ```dart
  /// final trimmed = 'Dart  is\t\tfun\n'.trimInner();
  /// print(trimmed); // 'Dart is fun'
  /// ```
  String trimInner() => replaceAll(RegExp(r'\s+'), ' ');

  /// Make a string's first character uppercase.
  String upperCapitalizeFirst() =>
      this[0].toUpperCase() + substring(1).toLowerCase();

  /// Uppercase the first character of each word in a string.
  String upperCapitalizeWords() => splitMapJoin(RegExp(r'\b'),
      onNonMatch: (match) => upperCapitalizeFirst());

  /// Returns the width of this [String] in pixels.
  double widthInPixels(TextStyle style,
      {TextDirection textDirection = TextDirection.ltr}) {
    final textPainer = TextPainter(
        text: TextSpan(text: this, style: style), textDirection: textDirection)
      ..layout();
    return textPainer.width;
  }
}

extension Lists<T> on List<T> {
  /// Returns the last index of this [List].
  int get lastIndex => isEmpty ? -1 : length - 1;

  /// Returns new array which is a copy of this list.
  List<T> copyOf() => List<T>.from(this);

  /// Returns a list containing only distinct elements from this list.
  List<T> distinct() => toSet().toList();
}

extension NumIterable<T extends num> on Iterable<T> {
  /// Returns an average value of elements in this list.
  double get average {
    final sum = fold<T>(
        0 as T, (previousValue, element) => (previousValue + element) as T);
    return sum / length;
  }
}

extension FileSizeProps on FileSize {
  /// Represents a [FileSize] as `XX.XX Mb` [String]
  String formatSizeInBytesToScaledSize({int decimals = 0}) {
    assert(!decimals.isNegative);
    return Helper.formatSizeInBytesToScaledSize(this, decimals: decimals);
  }
}

extension SizeProps on Size {
  /// Returns the aspect ration of this [Size].
  double get aspectRatio => width / height;
}

extension DateTimeProps on DateTime {}

/// Executes `body` in a loop for specified `times`.
///
/// This sugar syntax for emulation of the following code:
/// ```dart
/// for (times) {
///   body();
/// }
/// ```
void forTimes(int times, VoidCallback body) {
  if (times > 0) {
    body();
    forTimes(times - 1, body);
  }
}

/// Schedule a callback for the end of this frame.

/// Does not request a new frame.
void didBuildWiget(VoidCallback callback) =>
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => callback());

/// Measures performance of `procedure`.
FutureOr<T> meter<T>(ValueGetter<FutureOr<T>> procedure, [String? name]) async {
  final stopwatch = Stopwatch()..start();
  final result = await procedure();
  stopwatch.stop();
  final duration = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(3);
  log('Duration: $duration sec', name: name ?? 'meter');
  return result;
}

/// Provides some helper functions.
class Helper {
  Helper._();

  /// Returns the `list` of type T from dynamic list safely.
  ///
  /// If `list` is null than empty [List] is returned.
  static List<T> safeList<T>(List<Object?>? list) =>
      List<T>.from(list ?? <T>[]);

  /// Returns the `map` of type T from dynamic list safely.
  ///
  /// If `map` is null than empty [Map] is returned.
  static Map<K, V> safeMap<K, V>(Map<Object, Object?>? map) =>
      Map<K, V>.from(map ?? <K, V>{});

  /// Returns the value of type T from JSON encoded `map` safely.
  ///
  /// If `map` is null than null is returned.
  static T? safeValue<T, V>(V? source, ConvertibleBuilder<T?, V?> builder,
          [T? defaultValue]) =>
      source != null ? builder(source) : defaultValue;

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
          (startColor.ri * (1 - grade) + grade * endColor.ri).round(),
          (startColor.gi * (1 - grade) + grade * endColor.gi).round(),
          (startColor.bi * (1 - grade) + grade * endColor.bi).round());
    });
  }
}

extension ColorComponents on Color {
  /// The integer of the alpha channel component.
  int get ai => _floatToInt8(a);

  /// The integer of the red color component.
  int get ri => _floatToInt8(r);

  /// The integer of the green color component.
  int get gi => _floatToInt8(g);

  /// The integer of the blue color component.
  int get bi => _floatToInt8(b);
}

int _floatToInt8(double value) {
  return (value * 255.0).round() & 0xff;
}
