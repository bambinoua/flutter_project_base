/// An alias for `[Map]<String,dynamic>`
typedef JsonMap = Map<String, dynamic>;

/// An alias for file `int` size (in bytes).
typedef FileSize = int;

/// An alias for file `GUID`.
typedef GuidString = String;

/// Signature for a function which providdes a value of type T.
typedef ValueBuilder<T> = T Function();

/// Signature for a function which creates a value of type T
/// using `value` of type V.
typedef ConvertibleBuilder<T, V> = T Function(V value);
