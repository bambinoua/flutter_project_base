import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter_project_base/src/storage/contracts.dart';

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage implements Storage {
  SharedPreferences? _sharedPreferences;

  /// Initializes storage.
  Future<SharedPreferences> init() async =>
      _sharedPreferences ??= await SharedPreferences.getInstance();

  @override
  StorageItem<T>? getItem<T>(String key) {
    _debugAssertNotInitialized();
    assert(key.isNotEmpty);
    T? value;
    switch (T) {
      case bool:
        value = _sharedPreferences!.getBool(key) as T?;
        break;
      case double:
        value = _sharedPreferences!.getDouble(key) as T?;
        break;
      case int:
        value = _sharedPreferences!.getInt(key) as T?;
        break;
      case String:
        value = _sharedPreferences!.getString(key) as T?;
        break;
      case List:
        value = _sharedPreferences!.getStringList(key) as T?;
        break;
      default:
        throw UnsupportedError(_debugErrorUnsupportedMessage(T));
    }
    return value != null ? StorageItem<T>(key: key, value: value) : null;
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    _debugAssertNotInitialized();
    switch (T) {
      case bool:
        _sharedPreferences!.setBool(item.key, item.value as bool);
        break;
      case double:
        _sharedPreferences!.setDouble(item.key, item.value as double);
        break;
      case int:
        _sharedPreferences!.setInt(item.key, item.value as int);
        break;
      case String:
        _sharedPreferences!.setString(item.key, item.value as String);
        break;
      case List:
        _sharedPreferences!.setStringList(item.key, item.value as List<String>);
        break;
      default:
        throw UnsupportedError(_debugErrorUnsupportedMessage(T));
    }
  }

  @override
  void removeItem(String key) {
    _debugAssertNotInitialized();
    assert(key.isNotEmpty);
    _sharedPreferences!.remove(key);
  }

  @override
  void clear() {
    _debugAssertNotInitialized();
    _sharedPreferences!.clear();
  }

  @override
  List<String> get keys {
    _debugAssertNotInitialized();
    return _sharedPreferences!.getKeys().toList();
  }

  @override
  int get length => keys.length;

  void _debugAssertNotInitialized() {
    assert(_sharedPreferences != null,
        "Before using 'SharedPreferencesStorage' call its method 'init()'");
  }

  String _debugErrorUnsupportedMessage(type) => '''
    Expected value of stored types is 'bool', 'int', 'double',
    'String', 'List<String>' but got '$type'
  ''';
}

/// Available type of web storages.
enum WebStorageType {
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
  const WebStorage({WebStorageType type = WebStorageType.session})
      : _type = type,
        assert(kIsWeb, 'WebStorage is available only in web environment');

  /// The type of used web storage.
  final WebStorageType _type;

  /// Shortness for web storage.
  html.Storage get _storage => _type == WebStorageType.session
      ? html.window.sessionStorage
      : html.window.localStorage;

  @override
  StorageItem<T>? getItem<T>(String key) {
    assert(key.isNotEmpty);
    final jsonValue = _storage[key];
    if (jsonValue == null) return null;
    final value = json.decode(jsonValue) as T;
    assert(
        T == value.runtimeType, 'Stored and requested value types mismatched');
    switch (T) {
      case bool:
      case num:
      case double:
      case int:
      case String:
      case List:
      case Map:
        return StorageItem(key: key, value: value);
      default:
        throw UnsupportedError(_debugErrorUnsupportedMessage(T));
    }
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    final jsonValue = json.encode(item.value);
    _storage.update(item.key, (oldValue) => jsonValue,
        ifAbsent: () => jsonValue);
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

  String _debugErrorUnsupportedMessage(type) => '''
    Expected value of stored types is 'bool', 'num', 'int', 'double',
    'String', 'List<String>' but got '$type'
  ''';
}

/// Provides implementation of in-memory storage.
class MemoryStorage implements Storage {
  /// Memory map.
  final Map<String, dynamic> _storage = {};

  @override
  StorageItem<T>? getItem<T>(String key) {
    assert(key.isNotEmpty);
    final T? value = _storage[key];
    return value != null ? StorageItem<T>(key: key, value: value) : null;
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    _storage[item.key] = item.value;
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
