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
