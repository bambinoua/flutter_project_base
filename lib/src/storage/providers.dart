import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter_project_base/src/storage/contracts.dart';

String _debugUnsupportedMessage(type) =>
    "Expected value of types 'bool', 'int', 'double', 'String' " +
    "or 'List<String>' but got '$type'";

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage implements Storage {
  SharedPreferences? _sharedPreferences;

  /// Initializes storage.
  Future<SharedPreferences> init() async =>
      _sharedPreferences ??= await SharedPreferences.getInstance();

  @override
  StorageItem<T>? getItem<T>(String key) {
    _debugAssert();
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
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
    return value != null ? StorageItem<T>(key: key, value: value) : null;
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    _debugAssert();
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
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
  }

  @override
  void removeItem(String key) {
    _debugAssert();
    _sharedPreferences!.remove(key);
  }

  @override
  void clear() {
    _debugAssert();
    _sharedPreferences!.clear();
  }

  @override
  List<String> get keys {
    _debugAssert();
    return _sharedPreferences!.getKeys().toList();
  }

  @override
  int get length => keys.length;

  void _debugAssert() {
    assert(_sharedPreferences != null,
        "Before using 'SharedPreferencesStorage' call its method async 'init()'");
  }
}

/// Provides implementation of web session storage.
class WebSessionStorage implements Storage {
  const WebSessionStorage()
      : assert(kIsWeb, 'WebSessionStorage available only in web environment');

  html.Storage get _storage => html.window.sessionStorage;

  @override
  StorageItem<T>? getItem<T>(String key) {
    final jsonValue = _storage[key];
    if (jsonValue == null) return null;
    final value = json.decode(jsonValue) as T;
    switch (T) {
      case bool:
      case double:
      case int:
      case String:
      case List:
        return StorageItem(key: key, value: value);
      default:
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    _storage.update(item.key, (oldValue) => json.encode(item.value),
        ifAbsent: () => json.encode(item.value));
  }

  @override
  void removeItem(String key) {
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
  final Map<String, dynamic> _storage = {};

  @override
  StorageItem<T>? getItem<T>(String key) {
    final T? value = _storage[key];
    return value != null ? StorageItem<T>(key: key, value: value) : null;
  }

  @override
  void putItem<T>(StorageItem<T> item) {
    _storage[item.key] = item.value;
  }

  @override
  void removeItem(String key) {
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