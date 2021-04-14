import 'package:flutter/foundation.dart';

/// Defines list of available storage providers.
enum StorageProvider {
  /// Mobile device storage (usually SharedPreferences)
  mobile,

  /// Simple memory storage like PageStorage.
  memory,

  /// Web domain local storage.
  webLocal,

  /// Web domain session storage.
  webSession,
}

/// The Storage interface provides access to a particular mobile, memory,
/// domain's session or local storage. It allows, for example, the addition,
/// modification, or deletion of stored data items.
abstract class Storage {
  Storage._();

  /// When invoked, will empty all keys out of the storage.
  void clear();

  /// Return that `key`'s value, or `null` if the key does not exist,
  /// in the given storage.
  T? getItem<T>(StorageKey key);

  /// Returns list of item keys of this storage.
  List<StorageKey> get keys;

  /// Returns number of data items stored in this storage.
  int get length;

  /// Adds the passed `key` to the storage, or update that `key`'s
  /// `value`  if it already exists.
  void putItem<T>(StorageKey key, T value);

  /// Removes the `key` from the given Storage object if it exists.
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void removeItem(StorageKey key);
}

/// A key that uses as parameter for [Storage].
class StorageKey extends ValueKey<String> {
  /// Construct a [StorageKey] with optional persistence.
  const StorageKey(
    String value, {
    this.persistent = false,
  }) : super(value);

  /// Returns `true` if key will be persistent between sessions.
  final bool persistent;
}
