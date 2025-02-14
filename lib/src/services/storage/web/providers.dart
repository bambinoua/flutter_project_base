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
final class WebStorage extends PreferenceStorage {
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
  String? get(String key) {
    assert(key.isNotEmpty);
    return _storage[key];
  }

  @override
  void put(String key, String value) {
    assert(key.isNotEmpty);
    _storage.update(key, (oldValue) => value, ifAbsent: () => value);
  }

  @override
  void remove(String key) {
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

/// Creates a value which is stored in web browser local storage.
final class WebLocalStorageValue<T, S> extends BasePreferenceValue<T, S> {
  WebLocalStorageValue(String key, T initialValue,
      {ConvertibleBuilder<T, S>? valueBuilder})
      : super(key, initialValue, WebStorage.local, valueBuilder: valueBuilder);
}

/// Creates a value which is stored in web browser session storage.
final class WebSessionStorageValue<T, S> extends BasePreferenceValue<T, S> {
  WebSessionStorageValue(String key, T initialValue,
      {ConvertibleBuilder<T, S>? valueBuilder})
      : super(key, initialValue, WebStorage.session,
            valueBuilder: valueBuilder);
}
