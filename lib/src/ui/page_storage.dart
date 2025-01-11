import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_base/services.dart';
import 'package:meta/meta.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';

/// A storage bucket associated with a page in an app.
///
/// Useful for storing per-page state that persists across navigations from one
/// page to another.
@experimental
class WebPageStorageBucket implements Disposable {
  WebPageStorageBucket({this.name = 'storage'})
      : assert(name.isNotEmpty),
        _memoryStorage = MemoryStorageKey(name, <String, dynamic>{},
            builder: (data) => data),
        _localStorage = WebLocalStorageKey(name, <String, dynamic>{},
            builder: (data) => data),
        _sessionStorage = WebSessionStorageKey(name, <String, dynamic>{},
            builder: (data) => data) {
    _memoryStorage.addListener(_memoryStorageChangeListener);
  }

  /// Keeps the name of this storage.
  final String name;

  final BaseStorageKey<JsonMap, JsonMap> _memoryStorage;
  final BaseStorageKey<JsonMap, JsonMap> _localStorage;
  final BaseStorageKey<JsonMap, JsonMap> _sessionStorage;

  /// Registers a memory storage key.
  void registerMemoryKey<T>(String key, T initialValue) {
    final storageKey = MemoryStorageKey<T, T>(name, initialValue);
    final storageValue = _memoryStorage.value;
    storageValue.putIfAbsent(name, () => storageKey);
    _memoryStorage.value = storageValue;
  }

  /// Registers a web session storage key.
  void registerSessionKey<T, V>(String name, T initialValue,
      {ConvertibleBuilder<T, V>? valueBuilder}) {
    final storageKey =
        WebSessionStorageKey<T, V>(name, initialValue, builder: valueBuilder);
    final storageValue = _sessionStorage.value;
    storageValue.putIfAbsent(name, () => storageKey);
    _sessionStorage.value = storageValue;
  }

  /// Registers a web local storage key.
  void registerPersistentKey<T, V>(String key, T initialValue,
      {ConvertibleBuilder<T, V>? valueBuilder}) {
    final storageKey =
        WebLocalStorageKey(name, initialValue, builder: valueBuilder);
    final storageValue = _localStorage.value;
    storageValue.putIfAbsent(name, () => storageKey);
    _localStorage.value = storageValue;
  }

  /// Retursn the current flattened identifier of the this widget in the specified `context`.
  String _getIdentifier(BuildContext context) =>
      _computePath(context).keys.map((key) => key.value).join('.');

  _WebPageIdentifier _computePath(BuildContext context) =>
      _WebPageIdentifier(_allKeys(context).reversed.toList());

  List<WebPageKey> _allKeys(BuildContext context) {
    final keys = <WebPageKey>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return keys;
  }

  static bool _maybeAddKey(BuildContext context, List<WebPageKey> keys) {
    final widget = context.widget;
    final key = widget.key;
    if (key is WebPageKey) {
      keys.add(key);
    }
    return widget is! WebPageStorage;
  }

  void _memoryStorageChangeListener() {
    final memoryMap = <String, dynamic>{};
    final persistentMap = _localStorage.value;
    final sessionMap = <String, dynamic>{};

    // Save memory items
    if (memoryMap.isNotEmpty) {
      final oldMap = _memoryStorage.value;
      final newMap = mergeMaps(oldMap, persistentMap);
      _localStorage.value = newMap;
    }

    // Save persistent items
    if (persistentMap.isNotEmpty) {
      final oldMap = _localStorage.value;
      final newMap = mergeMaps(oldMap, persistentMap);
      _localStorage.value = newMap;
    }

    // Save session items
    if (sessionMap.isNotEmpty) {
      final oldMap = _sessionStorage.value;
      final newMap = mergeMaps(oldMap, sessionMap);
      _sessionStorage.value = newMap;
    }
  }

  @override
  void dispose() {
    _memoryStorage.dispose();
    _localStorage.dispose();
    _sessionStorage.dispose();
  }

  @override
  String toString() => 'WebPageStorageBucket {name: $name}';
}

/// Establish a subtree in which widgets can opt into persisting states after
/// being destroyed.
///
/// [WebPageStorage] is used to save and restore values that can outlive the widget.
class WebPageStorage extends InheritedWidget {
  const WebPageStorage({
    super.key,
    required this.bucket,
    required super.child,
  });

  /// The storage bucket to use by wrapped widget subtree.
  final WebPageStorageBucket bucket;

  /// The bucket from the closest instance of this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// PageStateBucket bucket = PageStateStorage.of(context);
  /// ```
  ///
  static WebPageStorageBucket of(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<WebPageStorage>();
    assert(() {
      if (inheritedElement == null) {
        throw FlutterError.fromParts([
          ErrorSummary('Error: Could not find the `$_className` above '
              'this `${context.widget}` widget'),
          ErrorDescription(
              'This happens because you used a `BuildContext` that does not include '
              'the `$_className`. Make sure that you wrap your `home` widget '
              'with `$_className`'),
        ]);
      }
      return true;
    }());
    return (inheritedElement?.widget as WebPageStorage).bucket;
  }

  /// The identifier from the closest instance of this class that encloses the given context.
  static String identifierOf(BuildContext context) =>
      of(context)._getIdentifier(context);

  @override
  bool updateShouldNotify(WebPageStorage oldWidget) =>
      bucket != oldWidget.bucket;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      '$_className {bucket: ${bucket.name}}';

  static const _className = 'WebPageStorage';
}

@immutable
class WebPageKey extends ValueKey<String> {
  const WebPageKey(super.value) : assert(value.length > 0);
}

@immutable
class _WebPageIdentifier extends Equatable with Emptiable {
  const _WebPageIdentifier(this.keys);

  final List<WebPageKey> keys;

  @override
  bool get isEmpty => keys.isEmpty;

  @override
  List<Object?> get props => [keys];
}
