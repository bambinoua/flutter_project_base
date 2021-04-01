/// Signature for a function that creates an instance of type T.
typedef InstanceBuilder<T> = T Function();

/// Signature for a function that creates an instance of type T from `map`.
typedef InstanceMapBuilder<T> = T Function(Map<String, dynamic> map);

/// The `Date` type is used for values with a date part but no time part.
/// Dates can represent time values that are at a distance of at most
/// 100,000,000 days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
class Date extends DateTime {
  /// Constructs a [Date] instance specified in the local time zone.
  ///
  /// For example,
  /// to create a DateTime object representing the 7th of September 2017,
  ///
  /// ```
  /// var dentistAppointment = Date(2017, 9, 7);
  /// ```
  Date(int year, [int month = DateTime.january, int day = 1])
      : super(year, month, day, 0, 0, 0, 0, 0);

  /// Constructs a [Date] instance with current date in the local time zone.
  ///
  /// ```
  /// var thisInstant = Date.today();
  /// ```
  factory Date.today() {
    var now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  /// Constructs a new [Date] instance with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [Date] represents
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] ms in the given
  /// time zone (local or UTC).
  Date.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
      {bool isUtc = false})
      : super.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc);

  /// Constructs a new [Date] instance with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [Date] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  Date.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
      {bool isUtc = false})
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: isUtc);

  @override
  String toString() => "$year-$month-$day";
}
