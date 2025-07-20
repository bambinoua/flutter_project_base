import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/basic_types.dart';

/// The list of all primitive types which can be serialized.
const primitiveTypes = <Type>[
  Null,
  String,
  bool,
  num,
  int,
  double,
  List,
  Map,
];

/// Represents a storage of keys and values.
abstract class KeyValueStorage<K, V> {
  /// When invoked, will empty all keys out of the storage.
  void clear();

  /// Retrieves the value from the storage associated with the specified [key],
  /// or `null` if the key does not exist.
  V? get(K key);

  /// Returns a list of keys of this storage.
  List<K> get keys;

  /// Returns number of values stored in this storage.
  int get length;

  /// Adds the passed [value] to the storage with the [key], or update that [key]
  /// if it already exists.
  void put(K key, V value);

  /// Removes the [key] from the given storage object if it exists.
  ///
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void remove(K key);
}

/// An abstract interface for preferences storage.
abstract class PreferenceStorage implements KeyValueStorage<String, String> {
  const PreferenceStorage();
}

/// An abstract preference value.
abstract class PreferenceValue<T, S> extends ChangeNotifier
    implements ValueListenable<T> {
  PreferenceValue(
    this.key,
    T initialValue,
    this._storage, {
    ConvertibleBuilder<T, S>? valueBuilder,
  })  : assert(key.isNotEmpty),
        _initialValue = initialValue,
        _valueBuilder = valueBuilder,
        _value = initialValue;

  /// The unique value's key.
  final String key;

  /// Underlying storage interface.
  final PreferenceStorage _storage;

  /// Default value if storage does not contains value yet.
  final T _initialValue;

  /// Builds an instance of type T from type V.
  final ConvertibleBuilder<T, S>? _valueBuilder;

  /// Current value.
  T? _value;

  @override
  T get value {
    if (_value != null && !kIsWeb) {
      return _value!;
    }

    final jsonValue = _storage.get(key);
    if (jsonValue == null) {
      return _initialValue;
    }

    try {
      final decodedValue = json.decode(jsonValue) as S;
      return _valueBuilder?.call(decodedValue) ?? decodedValue as T;
    } on FormatException {
      rethrow;
    }
  }

  set value(T newValue) {
    try {
      final encodedValue = json.encode(newValue, toEncodable: (object) {
        if (object is DateTime) {
          throw FormatException(
            'Could not encode the `DateTime` directly. Please convert it to '
            '`String` value using `toIso8601String()` method, or to '
            '`int` value using `millisecondsSinceEpoch` property.',
            object.toString(),
          );
        }
        if (object is Enum) {
          throw FormatException(
            'Could not encode the `Enum` directly. Please convert it to '
            '`int` value using `index` property or `String` value using `name` property.',
            object.toString(),
          );
        }
        if (!primitiveTypes.contains(object.runtimeType)) {
          throw FormatException(
            'Could not encode the [`$object``] directly. Please convert it to primitive type'
            'or use method `toJson()` for encoded class.',
            object.toString(),
          );
        }
        return object;
      });
      _storage.put(key, encodedValue);
      if (_value != newValue) {
        _value = newValue;
        notifyListeners();
      }
    } on FormatException {
      rethrow;
    }
  }

  /// Removes this key from storage.
  void remove() {
    _value = null;
    _storage.remove(key);
    notifyListeners();
  }
}

/// Represents an individual storage entry in the [KeyValueStorage].
class StorageItem<T> extends ValueNotifier<T> {
  /// Construct a [StorageItem] with optional persistence.
  StorageItem(
    this.key,
    super.value, {
    this.priority = StoragePriority.persistent,
  }) : assert(key != '');

  /// A unique identifier for this storage entry.
  final String key;

  /// Priority setting that is used to determine whether to evict
  /// a storage entry.
  final StoragePriority priority;

  @override
  int get hashCode => Object.hash(key, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageItem &&
          key == other.key &&
          value == other.value &&
          priority == other.priority;

  @override
  String toString() => 'StorageItem (key: $key, value: $value, '
      'priority: ${priority.name})';
}

/// Specifies a priority setting that is used to decide whether
/// to evict a storage entry.
enum StoragePriority {
  /// Indicates that there is no priority for removing the storage item.
  sessional,

  ///Indicates that a storage item should never be removed from the storage.
  persistent;

  /// Whether the priority is sessional.
  bool get isSessional => this == StoragePriority.sessional;

  /// Whether the priority is persistent.
  bool get isPersistent => this == StoragePriority.persistent;
}
