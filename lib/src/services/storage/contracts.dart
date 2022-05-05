import 'package:flutter/foundation.dart';

import '../../core/contracts.dart';

/// Specifies a priority setting that is used to decide whether
/// to evict a storafe entry.
enum StorageItemPriority {
  /// Indicates that there is no priority for removing the cache entry.
  standard,

  ///Indicates that a cache entry should never be removed from the cache.
  notRemovable
}

/// A key that uses as parameter for [Storage].
class StorageItem<T> implements Cloneable<StorageItem<T>> {
  /// Construct a [StorageItem] with optional persistence.
  const StorageItem(
    this.key,
    this.value, {
    this.priority = StorageItemPriority.standard,
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

  /// Adds the passed storage item to the storage, or update that `item`
  /// if it already exists.
  void putItem(String key, String value);

  /// Removes the `key` from the given storage object if it exists.
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void removeItem(String key);
}
