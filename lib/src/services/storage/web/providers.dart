import 'package:universal_html/html.dart' as html;

import '../../../core/basic_types.dart';
import '../contracts.dart';

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
final class WebStorage implements BaseStorage {
  const WebStorage._(this._type);

  /// The web local storage.
  static const WebStorage local = WebStorage._(WebStorageType.local);

  /// The web session storage.
  static const WebStorage session = WebStorage._(WebStorageType.session);

  /// The type of used web storage.
  final WebStorageType _type;

  /// Shortness for web storage.
  html.Storage get _storage => _type == WebStorageType.session
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
  void clear() => _storage.clear();

  @override
  List<String> get keys => _storage.keys.toList();

  @override
  int get length => keys.length;
}

/// Creates persistent key which stores its value in web local storage.
final class WebLocalStorageKey<T, V> extends BaseStorageKey<T, V> {
  WebLocalStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? valueBuilder})
      : super(name, initialValue, WebStorage.local, valueBuilder: valueBuilder);
}

/// Creates persistent key which stores its value in web session storage.
final class WebSessionStorageKey<T, V> extends BaseStorageKey<T, V> {
  WebSessionStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? valueBuilder})
      : super(name, initialValue, WebStorage.session,
            valueBuilder: valueBuilder);
}
