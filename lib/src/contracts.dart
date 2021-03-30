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
