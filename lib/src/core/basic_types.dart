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

/// Signature for a function which creates a value of type T
/// using [JsonMap].
typedef JsonValueBuilder<T> = T Function(JsonMap map);

/// Provides data or error result.
class Either<T, V extends Exception> {
  const Either({this.data, this.error});

  /// Paylod.
  final T? data;

  /// Error.
  final V? error;

  bool get hasData => data != null;
  bool get hasError => error != null;
}
