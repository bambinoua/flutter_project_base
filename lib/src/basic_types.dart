/// Signature for a function that creates an instance of type T.
typedef InstanceBuilder<T> = T Function();

/// Signature for a function that creates an instance of type T from `map`.
typedef InstanceMapBuilder<T> = T Function(Map<String, dynamic> map);
