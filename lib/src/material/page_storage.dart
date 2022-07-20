import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_base/src/services/storage/web/providers.dart';

import '../core/contracts.dart';
import '../data/contracts.dart';
import '../services/storage/contracts.dart';

/// A storage bucket associated with a page in an app.
///
/// Useful for storing per-page state that persists across navigations from one
/// page to another.
class PageStateBucket implements Disposable {
  PageStateBucket({this.name = 'state'})
      : assert(name.isNotEmpty),
        _internalStorage = _PageStateInternalStorage(),
        _localStorage = WebLocalStorageKey(name, <String, dynamic>{},
            builder: (data) => data),
        _sessionStorage = WebSessionStorageKey(name, <String, dynamic>{},
            builder: (data) => data) {
    _internalStorage.addListener(_onChangeInternalStorage);
  }

  /// Keeps the name of this storage
  final String name;

  final _PageStateInternalStorage _internalStorage;
  final BaseStorageKey<Json, Json> _localStorage;
  final BaseStorageKey<Json, Json> _sessionStorage;

  void writeState<T>(BuildContext context, String key, T value,
      {bool persistent = false, bool overwrite = false}) {
    _internalStorage.add<T>(key, value, persistent, overwrite: overwrite);
  }

  T? readState<T>(BuildContext context, String key, {T? defaultValue}) {
    return _internalStorage.get(key, defaultValue: defaultValue);
  }

  /// Retursn the current flattened identifier of the this widget in the specified `context`.
  String getStatePath(BuildContext context) =>
      _computePath(context).keys.map((key) => key.value).join('.');

  _PageStateIdentifier _computePath(BuildContext context) =>
      _PageStateIdentifier(_allKeys(context).reversed.toList());

  List<PageStateKey> _allKeys(BuildContext context) {
    final keys = <PageStateKey>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return keys;
  }

  static bool _maybeAddKey(BuildContext context, List<PageStateKey> keys) {
    final widget = context.widget;
    final key = widget.key;
    if (key is PageStateKey) keys.add(key);
    return widget is! PageStateStorage;
  }

  void _onChangeInternalStorage() {
    final persistentMap = <String, dynamic>{};
    final sessionMap = <String, dynamic>{};

    // Accumulate persistent and session storage items.
    for (var storageItem in _internalStorage._storage.values) {
      Object? value = storageItem.value;
      final storageEntry = <String, dynamic>{
        storageItem.key: value is Serializable ? value.toJson() : value
      };

      if (storageItem.priority == StorageItemPriority.persistent) {
        persistentMap.addAll(storageEntry);
      } else {
        sessionMap.addAll(storageEntry);
      }
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
    _internalStorage.dispose();
  }

  @override
  String toString() => 'PageStateBucket {name: $name}';
}

/// Establish a subtree in which widgets can opt into persisting states after
/// being destroyed.
///
/// [PageStateStorage] is used to save and restore values that can outlive the widget.
class PageStateStorage extends InheritedWidget {
  const PageStateStorage({
    Key? key,
    required this.bucket,
    required Widget child,
  }) : super(key: key, child: child);

  /// The storage bucket to use by wrapped widget subtree.
  final PageStateBucket bucket;

  /// The bucket from the closest instance of this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// PageStateBucket bucket = PageStateStorage.of(context);
  /// ```
  ///
  static PageStateBucket of(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<PageStateStorage>();
    assert(() {
      if (inheritedElement == null) {
        throw FlutterError.fromParts([
          ErrorSummary('Error: Could not find the `$_kClassName` above '
              'this `${context.widget}` widget'),
          ErrorDescription(
              'This happens because you used a `BuildContext` that does not include '
              'the `$_kClassName`. Make sure that you wrap your `home` widget '
              'with `$_kClassName`'),
        ]);
      }
      return true;
    }());
    return (inheritedElement?.widget as PageStateStorage).bucket;
  }

  /// The path from the closest instance of this class that encloses the given context.
  static String pathOf(BuildContext context) =>
      of(context).getStatePath(context);

  @override
  bool updateShouldNotify(PageStateStorage oldWidget) {
    return bucket != oldWidget.bucket;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '$_kClassName {bucket: ${bucket.name}}';
  }

  static const _kClassName = 'PageStateStorage';
}

class PageStateKey extends ValueKey<String> {
  const PageStateKey(String value)
      : assert(value.length > 0),
        super(value);
}

@immutable
class _PageStateIdentifier extends Equatable with Emptiable {
  const _PageStateIdentifier(this.keys);

  final List<PageStateKey> keys;

  @override
  bool get isEmpty => keys.isEmpty;

  @override
  List<Object?> get props => [keys];
}

class _PageStateInternalStorage extends ChangeNotifier {
  final _storage = <String, StorageItem<Object?>>{};

  /// Retrieves the value of the item from the storage associated with this
  /// object's `key`, or `defaultValue` if the key does not exist.
  T? get<T>(String key, {T? defaultValue}) {
    if (_storage.containsKey(key)) {
      return _storage[key] as T;
    }
    return defaultValue;
  }

  /// Adds the passed storage item to the storage, or update that `key`
  /// if it already exists.
  void add<T>(String key, T value, bool persistent, {bool overwrite = false}) {
    if (!_storage.containsKey(key) || overwrite) {
      _storage[key] = StorageItem<T>(key, value,
          priority: persistent
              ? StorageItemPriority.persistent
              : StorageItemPriority.session);
      notifyListeners();
    }
  }

  /// Removes the `key` from the given storage object if it exists.
  /// If there is no item associated with the given key, this method
  /// will do nothing.
  void remove(String key) {
    if (_storage.containsKey(key)) {
      _storage.remove(key);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _storage.clear();
    super.dispose();
  }
}
