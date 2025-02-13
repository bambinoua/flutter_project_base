import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/basic_types.dart';

/// The abstract interface which provides a base operations for store [key]/[value] pairs.
abstract class KeyValueStorage {
  /// When invoked, will empty all keys out of the storage.
  void clear();

  /// Retrieves the value from the storage associated with the specified [key],
  /// or `null` if the key does not exist.
  String? get(String key);

  /// Returns a list of keys of this storage.
  List<String> get keys;

  /// Returns number of values stored in this storage.
  int get length;

  /// Adds the passed [value] to the storage with the [key], or update that [key]
  /// if it already exists.
  void put(String key, String value);

  /// Removes the [key] from the given storage object if it exists.
  ///
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void remove(String key);
}

/// Provides and interface for values which can be persisted in undrlyiing [KeyValueStorage] storage.
abstract class StorableValue<T> extends ChangeNotifier
    implements ValueListenable<T> {
  StorableValue(
    this.key,
    this.storage,
  ) : assert(key.isNotEmpty);

  /// The unique value's key.
  final String key;

  /// Underlying storage interface.
  final KeyValueStorage storage;

  /// Removes this key from storage.
  void remove();
}

/// Base implementation of the [StorableValue].
abstract class BaseStorableValue<TOut, TIn> extends StorableValue<TOut> {
  BaseStorableValue(
    super.key,
    TOut initialValue,
    super.storage, {
    ConvertibleBuilder<TOut, TIn>? valueBuilder,
  })  : _initialValue = initialValue,
        _valueBuilder = valueBuilder,
        _value = initialValue;

  static const _primitiveTypes = <Type>[
    String,
    bool,
    num,
    int,
    double,
    List,
    Map,
  ];

  /// Default value if storage does not contains value yet.
  final TOut _initialValue;

  /// Builds an instance of type T from type V.
  final ConvertibleBuilder<TOut, TIn>? _valueBuilder;

  /// Current value.
  late TOut _value;

  /// Current encoded value.
  String? _encodedValue;

  @override
  TOut get value {
    final jsonValue = storage.get(key);
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
      final decodedValue = json.decode(jsonValue) as TIn;
      return _valueBuilder != null
          ? _valueBuilder(decodedValue)
          : decodedValue as TOut;
    } on FormatException {
      rethrow;
    }
  }

  set value(TOut newValue) {
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
      storage.put(key, encodedValue);
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
    storage.remove(key);
    _value = _initialValue;
    _encodedValue = null;
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
