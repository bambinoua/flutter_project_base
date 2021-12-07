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
