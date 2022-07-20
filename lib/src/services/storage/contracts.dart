import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/basic_types.dart';
import '../../core/contracts.dart';

/// The Storage interface provides access to a particular mobile, memory,
/// domain's session or local storage. It allows, for example, the addition,
/// modification, or deletion of stored data items.
abstract class Storage {
  Storage._();

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
  StorageKey(this.name, this.storage);

  /// Name of this storage key.
  final String name;

  /// Underlying storage interface.
  final Storage storage;

  /// Removes this key from storage.
  void remove();
}

/// Base class for web [StorageKey].
abstract class BaseStorageKey<T, V> extends StorageKey<T> {
  BaseStorageKey(
    String name,
    T initialValue,
    Storage storage, {
    ConvertibleBuilder<T, V>? builder,
  })  : assert(name.isNotEmpty),
        _initialValue = initialValue,
        _value = initialValue,
        _builder = builder,
        super(name, storage);

  final ConvertibleBuilder<T, V>? _builder;
  final T _initialValue;

  late T _value;

  @override
  T get value {
    final jsonValue = storage.getItem(name);
    if (jsonValue == null) {
      return _value;
    }
    try {
      final decodedValue = json.decode(jsonValue, reviver: (key, value) {
        if (value is String && true /* data */) {
          return DateTime.parse(value);
        }
        return value;
      });
      return _builder != null ? _builder!(decodedValue) : decodedValue as T;
    } on FormatException {
      rethrow;
    }
  }

  set value(T newValue) {
    try {
      final encodedValue = json.encode(newValue, toEncodable: (object) {
        if (object is DateTime) {
          return object.millisecondsSinceEpoch;
        }
        if (_simpleTypes.contains(object.runtimeType)) {
          return object;
        }
        if (object is Enum) {
          return object.index;
        }
        if (object is Serializable) {
          return object.toJson();
        }
        //ignore: avoid_dynamic_calls
        return object.toJson();
      });
      storage.putItem(name, encodedValue);
      _value = newValue;
    } on FormatException {
      rethrow;
    }
  }

  @override
  void remove() {
    storage.removeItem(name);
    _value = _initialValue;
  }

  static const _simpleTypes = <Type>[
    String,
    num,
    int,
    double,
    bool,
    List,
    Map,
    Null,
  ];
}

/// Specifies a priority setting that is used to decide whether
/// to evict a storafe entry.
enum StorageItemPriority {
  /// Indicates that there is no priority for removing the storage item.
  session,

  ///Indicates that a storage item should never be removed from the storage.
  persistent
}

/// A key that uses as parameter for [Storage].
class StorageItem<T> implements Cloneable<StorageItem<T>> {
  /// Construct a [StorageItem] with optional persistence.
  const StorageItem(
    this.key,
    this.value, {
    this.priority = StorageItemPriority.session,
  });

  /// An unique identifier for a key.
  final String key;

  /// An data of any type for this key.
  final T value;

  /// Priority setting that is used to determine whether to evict
  /// a storage entry.
  final StorageItemPriority priority;

  @override
  StorageItem<T> copyWith({
    T? value,
  }) =>
      StorageItem<T>(
        key,
        value ?? this.value,
        priority: priority,
      );

  @override
  String toString() => 'StorageItem (key: $key, value: $value, '
      'priority: ${describeEnum(priority)})';
}
