/// Signature for a function that creates an instance of type T.
typedef InstanceBuilder<T> = T Function();

/// Signature for a function that creates an instance of type T from `map`.
typedef InstanceMapBuilder<T> = T Function(Map<String, dynamic> map);

class Date extends DateTime {
  ///
  Date(int year, [int month = DateTime.january, int day = 1])
      : super(year, month, day, 0, 0, 0, 0, 0);

  ///
  Date.today() : super.now();

  ///
  Date.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch)
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  ///
  Date.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch)
      : super.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
}
