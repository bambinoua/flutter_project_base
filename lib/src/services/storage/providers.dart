import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'contracts.dart';

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage implements Storage {
  const SharedPreferencesStorage._();

  static late SharedPreferences _sharedPreferences;

  /// Creates an instance of already initialized storage.
  static Future<SharedPreferencesStorage> create() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return const SharedPreferencesStorage._();
  }

  @override
  String? getItem(String key) {
    assert(key.isNotEmpty);
    return _sharedPreferences.getString(key);
  }

  @override
  void putItem(String key, String value) {
    assert(key.isNotEmpty);
    _sharedPreferences.setString(key, value);
  }

  @override
  void removeItem(String key) {
    assert(key.isNotEmpty);
    _sharedPreferences.remove(key);
  }

  @override
  void clear() {
    _sharedPreferences.clear();
  }

  @override
  List<String> get keys {
    return _sharedPreferences.getKeys().toList();
  }

  @override
  int get length => keys.length;
}

/// Available type of web storages.
enum _WebStorageType {
  /// The stored data is cleared when the page session ends.
  session,

  /// The stored data is saved across browser sessions.
  local,
}

/// Provides implementation of web session storage.
///
/// The descriptions of interfaces are on
///
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
///
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
class WebStorage implements Storage {
  const WebStorage._(this._type)
      : assert(kIsWeb, 'WebStorage is available only in web environment');

  const WebStorage.session() : this._(_WebStorageType.session);
  const WebStorage.local() : this._(_WebStorageType.local);

  /// The type of used web storage.
  final _WebStorageType _type;

  /// Shortness for web storage.
  html.Storage get _storage => _type == _WebStorageType.session
      ? html.window.sessionStorage
      : html.window.localStorage;

  @override
  String? getItem(String key) {
    assert(key.isNotEmpty);
    return _storage[key];
  }

  @override
  void putItem(String key, String value) {
    assert(key.isNotEmpty);
    _storage.update(key, (oldValue) => value, ifAbsent: () => value);
  }

  @override
  void removeItem(String key) {
    assert(key.isNotEmpty);
    _storage.remove(key);
  }

  @override
  void clear() {
    _storage.clear();
  }

  @override
  List<String> get keys => _storage.keys.toList();

  @override
  int get length => keys.length;
}

/// Provides implementation of in-memory storage.
class MemoryStorage implements Storage {
  /// Memory map.
  final Map<String, String> _storage = {};

  @override
  String? getItem(String key) {
    assert(key.isNotEmpty);
    return _storage[key];
  }

  @override
  void putItem(String key, String value) {
    assert(key.isNotEmpty);
    _storage[key] = value;
  }

  @override
  void removeItem(String key) {
    assert(key.isNotEmpty);
    _storage.remove(key);
  }

  @override
  void clear() => _storage.clear();

  @override
  List<String> get keys => _storage.keys.toList();

  @override
  int get length => _storage.length;
}

/// Storage controller mixin allows to manipulate by priority of cache items.
mixin SharedPreferencesStorageMixin<T> on SharedPreferencesStorage {
  /// Contains all storage items.
  final Map<String, StorageItem<T>> _items = {};

  /// Returns list of storage items which will not be evicted after
  /// session close.
  List<StorageItem<T>> get persistentKeys => _items.values
      .where((item) => item.priority == StorageItemPriority.notRemovable)
      .toList();

  /// Returns list of storage items which will be evicted after
  /// session close.
  List<StorageItem> get sessionKeys => _items.values
      .where((item) => item.priority == StorageItemPriority.standard)
      .toList();

  /// Puts item into inner controller storage.
  void saveKey(StorageItem<T> item) {
    _items[item.key] = item;
  }

  /// Removes item from inner controller storage.
  void removeKey(StorageItem<T> item) {
    _items.remove(item);
  }

  /// Removes keys which are not marked as `not removable`.
  void removeSessionKeys();
}
