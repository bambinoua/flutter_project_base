import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

/// [int] extensions.
extension ints on int {
  /// Format number as string with leading zeros.
  String withLeadingZeros([int pad = 0]) {
    assert(!pad.isNegative);
    return toString().padLeft(pad, '0');
  }
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

/// Measures performance of `procedure`.
FutureOr<T> meter<T>(ValueGetter<FutureOr<T>> procedure, [String? name]) async {
  final stopwatch = Stopwatch()..start();
  final result = await procedure();
  stopwatch.stop();
  final duration = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(3);
  log('Duration: $duration sec', name: name ?? 'meter');
  return result;
}
