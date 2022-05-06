// Integet bit wrapper.
class BitInt {
  BitInt(this.value);

  /// Target [int] value.
  late int value;

  /// Returns the value of the bit with `index`.
  bool getBit(int index) {
    assert(_debugAssert(index));
    return value >> index & 1 != 0;
  }

  /// Sets the bit with `index`.
  int setBit(int index) {
    assert(_debugAssert(index));
    value |= 1 << index;
    return value;
  }

  /// Resets the bit with `index`.
  int resetBit(int index) {
    assert(_debugAssert(index));
    value &= ~(1 << index);
    return value;
  }

  /// Toggles the bit with `index`.
  int toggleBit(int index) {
    assert(_debugAssert(index));
    value ^= 1 << index;
    return value;
  }

  static bool _debugAssert(int index) {
    return index >= 0 && index <= 63;
  }
}
