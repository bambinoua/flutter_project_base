import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/basic_types.dart';
import '../contracts.dart';

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

  static const WebStorage local = WebStorage._(_WebStorageType.local);
  static const WebStorage session = WebStorage._(_WebStorageType.session);

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

/// Base class for web [StorageKey].
abstract class _WebStorageKey<T, V> extends StorageKey<T> {
  _WebStorageKey(String name, Storage storage, T initialValue, this.builder)
      : assert(name.isNotEmpty),
        super(name, storage, initialValue);

  final ConvertibleBuilder<T, V>? builder;

  @override
  T get value {
    final jsonValue = storage.getItem(name);
    if (jsonValue == null) {
      return super.value;
    }
    final decodedValue = json.decode(jsonValue);
    return builder != null ? builder!(decodedValue) : decodedValue;
  }

  @override
  set value(T newValue) {
    final encodedValue = json.encode(newValue);
    storage.putItem(name, encodedValue);
    super.value = newValue;
  }

  @override
  void remove() {
    storage.removeItem(name);
  }
}

/// Creates persistent key which stores its value in web local storage.
class WebLocalStorageKey<T, V> extends _WebStorageKey<T, V> {
  WebLocalStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? builder})
      : super(name, WebStorage.local, initialValue, builder);
}

/// Creates persistent key which stores its value in web session storage.
class WebSessionStorageKey<T, V> extends _WebStorageKey<T, V> {
  WebSessionStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? builder})
      : super(name, WebStorage.session, initialValue, builder);
}
