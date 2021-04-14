import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';

import 'package:flutter_project_base/src/storage/contracts.dart';

String _debugUnsupportedMessage(type) =>
    'Only `bool`,`int`,`double`,`String` and `List<String>` are supported';

mixin PersistentStorageKeyMonitor<T extends Storage> {
  final List<StorageKey> _keys = [];

  List<StorageKey> get persistentKeys =>
      _keys.where((key) => key.persistent).toList();

  List<StorageKey> get sessionKeys =>
      _keys.where((key) => !key.persistent).toList();

  void saveKey(StorageKey key) {
    _keys.add(key);
  }

  void removeKey(StorageKey key) {
    _keys.remove(key);
  }

  void removeSessionKeys();
}

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage
    with PersistentStorageKeyMonitor
    implements Storage {
  SharedPreferences? _sharedPreferences;

  /// Initializes storage.
  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  @override
  T? getItem<T>(StorageKey key) {
    _debugAssert();
    switch (T) {
      case bool:
        return _sharedPreferences!.getBool(key.value) as T?;
      case double:
        return _sharedPreferences!.getDouble(key.value) as T?;
      case int:
        return _sharedPreferences!.getInt(key.value) as T?;
      case String:
        return _sharedPreferences!.getString(key.value) as T?;
      case List:
        return _sharedPreferences!.getStringList(key.value) as T?;
      default:
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
  }

  @override
  void putItem<T>(StorageKey key, T value) {
    _debugAssert();
    switch (T) {
      case bool:
        _sharedPreferences!.setBool(key.value, value as bool);
        break;
      case double:
        _sharedPreferences!.setDouble(key.value, value as double);
        break;
      case int:
        _sharedPreferences!.setInt(key.value, value as int);
        break;
      case String:
        _sharedPreferences!.setString(key.value, value as String);
        break;
      case List:
        _sharedPreferences!.setStringList(key.value, value as List<String>);
        break;
      default:
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
  }

  @override
  void removeItem(StorageKey key) {
    _debugAssert();
    _sharedPreferences!.remove(key.value);
  }

  @override
  void clear() {
    _debugAssert();
    _sharedPreferences!.clear();
  }

  @override
  List<StorageKey> get keys {
    _debugAssert();
    return _sharedPreferences!.getKeys().map((key) => StorageKey(key)).toList();
  }

  @override
  int get length => _keys.length;

  @override
  void removeSessionKeys() {
    sessionKeys.forEach(removeItem);
  }

  void _debugAssert() {
    assert(_sharedPreferences != null,
        'Before using `SharedPreferencesStorage` call its method `init()`');
  }
}

/// Provides implementation of web session storage.
class WebSessionStorage implements Storage {
  const WebSessionStorage()
      : assert(kIsWeb, 'WebSessionStorage available only in web environment');

  @override
  T? getItem<T>(StorageKey key) {
    final encodedValue = window.sessionStorage[key.value];
    if (encodedValue == null) return encodedValue as T;
    final value = json.decode(encodedValue) as T;
    switch (T) {
      case bool:
      case double:
      case int:
      case String:
      case List:
        return value;
      default:
        throw UnsupportedError(_debugUnsupportedMessage(T));
    }
  }

  @override
  void putItem<T>(StorageKey key, T value) {
    window.sessionStorage.update(key.value, (oldValue) => json.encode(value),
        ifAbsent: () => json.encode(value));
  }

  @override
  void removeItem(StorageKey key) {
    window.sessionStorage.remove(key.value);
  }

  @override
  void clear() {
    window.sessionStorage.clear();
  }

  @override
  List<StorageKey> get keys =>
      window.sessionStorage.keys.map((key) => StorageKey(key)).toList();

  @override
  int get length => keys.length;
}
