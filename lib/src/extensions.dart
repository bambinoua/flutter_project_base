/// [int] extensions.
extension ints on int {
  /// Format number as string with leading zeros.
  String withLeadingZeros([int pad = 0]) {
    assert(!pad.isNegative);
    return toString().padLeft(pad, '0');
  }
}
