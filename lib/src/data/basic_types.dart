import 'package:meta/meta.dart';

/// Object for representing range of numeric values.
@immutable
class Range<T extends num> {
  /// Creates pair of min and max values.
  const Range({this.minValue, this.maxValue});

  /// The minimum value.
  final T? minValue;

  /// The maximum value.
  final T? maxValue;

  /// Indicates whether this range has a minimum value.
  bool get hasMinValue => minValue != null;

  /// Indicates whether this range has a maximum value.
  bool get hasMaxValue => maxValue != null;

  /// Indicates whether the [value] is in this range.
  bool contains(num value) =>
      (minValue ?? double.negativeInfinity) <= value &&
      value <= (maxValue ?? double.infinity);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other.runtimeType == runtimeType &&
          other is Range &&
          other.minValue == minValue &&
          other.maxValue == maxValue;

  @override
  int get hashCode => Object.hash(minValue, maxValue);

  @override
  String toString() {
    final props = {
      if (minValue != null) 'minValue': minValue,
      if (maxValue != null) 'maxValue': maxValue,
    };
    return 'Range $props';
  }
}
