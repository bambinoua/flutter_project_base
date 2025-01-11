import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/basic_types.dart';

/// The Storage interface provides access to a particular mobile, memory,
/// domain's session or local storage. It allows, for example, the addition,
/// modification, or deletion of stored data items.
abstract class BaseStorage {
  /// When invoked, will empty all keys out of the storage.
  void clear();

  /// Retrieves the value of the item from the storage associated with this
  /// object's `key`, or `null` if the key does not exist.
  String? getItem(String key);

  /// Returns list of item keys of this storage.
  List<String> get keys;

  /// Returns number of data items stored in this storage.
  int get length;

  /// Adds the passed storage item to the storage, or update that `key`
  /// if it already exists.
  void putItem(String key, String value);

  /// Removes the `key` from the given storage object if it exists.
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void removeItem(String key);
}

/// Provices interface for building values which cen be persisted in undrlyiing storage.
abstract class StorageKey<T> extends ChangeNotifier
    implements ValueListenable<T> {
  StorageKey(
    this.name,
    this.storage,
  ) : assert(name.isNotEmpty);

  /// Name of this storage key.
  final String name;

  /// Underlying storage interface.
  final BaseStorage storage;

  /// Removes this key from storage.
  void remove();
}

/// Base class for web [StorageKey].
abstract class BaseStorageKey<T, V> extends StorageKey<T> {
  BaseStorageKey(
    super.name,
    T initialValue,
    super.storage, {
    ConvertibleBuilder<T, V>? builder,
  })  : assert(name.isNotEmpty),
        _initialValue = initialValue,
        _builder = builder,
        _value = initialValue;

  static const _primitiveTypes = <Type>[
    String,
    bool,
    num,
    int,
    double,
    List<String>,
    List<bool>,
    List<num>,
    List<int>,
    List<double>,
    Map<String, String>,
    Map<String, dynamic>,
  ];

  /// Default value if storage does not contains value yet.
  final T _initialValue;

  /// Builds an instance of type T from type V.
  final ConvertibleBuilder<T, V>? _builder;

  /// Current value.
  late T _value;

  /// Current encoded value.
  String? _encodedValue;

  @override
  T get value {
    final jsonValue = storage.getItem(name);
    // There is no stored value yet so return the default one.
    if (jsonValue == null) {
      return _initialValue;
    }
    // The stored value was changed from outsied. For example it is possible
    // in Web browser. If so remove this value from storage and return default one.
    if (jsonValue != _encodedValue) {
      remove();
      return _initialValue;
    }
    try {
      final decodedValue = json.decode(jsonValue) as V;
      return _builder != null ? _builder(decodedValue) : decodedValue as T;
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
        if (!_primitiveTypes.contains(object.runtimeType)) {
          throw FormatException(
            'Could not encode the [object] directly. Please convert it to primitive type'
            'or use method `toJson()` for encoded class.',
            object.toString(),
          );
        }
        return object;
      });
      storage.putItem(name, encodedValue);
      if (_value != newValue) {
        _value = newValue;
        _encodedValue = encodedValue;
        notifyListeners();
      }
    } on FormatException {
      rethrow;
    }
  }

  @override
  void remove() {
    storage.removeItem(name);
    _value = _initialValue;
    _encodedValue = null;
    notifyListeners();
  }
}

/// Represents an individual storage entry in the [BaseStorage].
class StorageItem<T> {
  /// Construct a [StorageItem] with optional persistence.
  const StorageItem(
    this.key,
    this.value, {
    this.priority = StorageItemPriority.session,
  }) : assert(key != '');

  /// A unique identifier for this storage entry.
  final String key;

  /// A data of type T for this storage entry.
  final T value;

  /// Priority setting that is used to determine whether to evict
  /// a storage entry.
  final StorageItemPriority priority;

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
/// to evict a storafe entry.
enum StorageItemPriority {
  /// Indicates that there is no priority for removing the storage item.
  session,

  ///Indicates that a storage item should never be removed from the storage.
  persistent;

  /// Whether the priority is session.
  bool get isSession => this == StorageItemPriority.session;

  /// Whether the priority is persistent.
  bool get isPersistent => this == StorageItemPriority.persistent;
}
