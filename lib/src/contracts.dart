/// Interface provides a set of methods to allow class which implement it
/// to be serializable using [json.encode] method.
abstract class Serializable {
  /// Returns a [Map] which represents this object.
  Map<String, dynamic> toJson();
}

/// Interface provides a method that it is legal for make a field-for-field
/// copy of instances of that class.
abstract class Cloneable<T> {
  T copyWith();
}

/// Interface provides a method which is used for realese of unmanaged
/// resources and finalizing some instances.
///
/// For example this interface can be implemented by classes which use
/// [StreamController]s. The `dispose` method can be used for close sink.
abstract class Disposable {
  void dispose();
}

/// Default implementation of [Serializable] interface.
abstract class DefaultSerializable extends Serializable {
  @override
  Map<String, dynamic> toJson() {
    return asMap().map((key, value) {
      var effectiveValue;
      if (value is DateTime) {
        effectiveValue = value.toIso8601String();
      } else {
        /// This is a trick to serialize `enum`. If value implements
        /// `index` property than it is potentially `enum`eration and
        /// there will not be exception. Otherwise the original value is taken.
        try {
          effectiveValue = value.index;
        } catch (_) {
          effectiveValue = value;
        }
      }
      return MapEntry(key, effectiveValue);
    });
  }

  /// Returns a [Map] which is used by method `toJson`
  /// of `Serializable` interface.
  Map<String, dynamic> asMap();
}
