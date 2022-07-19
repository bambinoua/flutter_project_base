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
class PageStateBucket {
  PageStateBucket({this.name = 'state'})
      : assert(name.isNotEmpty),
        _localStorage = WebLocalStorageKey(name, <String, dynamic>{},
            builder: (data) => data),
        _sessionStorage = WebSessionStorageKey(name, <String, dynamic>{},
            builder: (data) => data);

  /// Keeps the name of this storage
  final String name;

  final BaseStorageKey<Json, Json> _localStorage;
  final BaseStorageKey<Json, Json> _sessionStorage;

  final Map<String, Object> _internalStorage = <String, Object>{};

  void writeState(BuildContext context, String key, Object data) {
    _internalStorage[key] = data;
  }

  T? readState<T>(BuildContext context, String key) {
    return _internalStorage[key] as T?;
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
