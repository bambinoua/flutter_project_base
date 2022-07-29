import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import '../../flutter_project_base.dart';

/// [int] extensions.
extension IntFormatters on int {
  /// Format number as string with leading zeros.
  String withLeadingZeros([int pad = 0]) {
    assert(!pad.isNegative);
    return toString().padLeft(pad, '0');
  }
}

extension FileSizeExtension on FileSize {
  /// Represents a [FileSize] as `XX.XX Mb` [String]
  String formatSizeInBytesToScaledSize({int decimals = 0}) {
    assert(!decimals.isNegative);
    return Helper.formatSizeInBytesToScaledSize(this, decimals: decimals);
  }
}

extension SizeAspectRatio on Size {
  /// Returns the aspect ration of this [Size].
  double get aspectRatio => width / height;
}

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
          (startColor.red * (1 - grade) + grade * endColor.red).round(),
          (startColor.green * (1 - grade) + grade * endColor.green).round(),
          (startColor.blue * (1 - grade) + grade * endColor.blue).round());
    });
  }
}
