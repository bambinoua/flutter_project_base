import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_base/packages.dart';
import 'package:flutter_project_base/services.dart';

/// A storage bucket associated with a page in an app.
///
/// Useful for storing per-page state that persists across navigations from one
/// page to another.
@experimental
abstract class StorageBucket extends ChangeNotifier {
  StorageBucket(this.name, this.storage) : assert(name != '');

  /// Keeps the name of this storage.
  final String name;

  /// The underlying storage.
  final BaseStorage storage;

  /// Registers a stprage item.
  void registerStorageItem<T>(StorageItem<T> storageItem) {}

  /// Retursn the current flattened identifier of the this widget in the specified `context`.
  String _getIdentifier(BuildContext context) =>
      _computeIdentifier(context).keys.map((key) => key.value).join('.');

  _StorageIdentifier _computeIdentifier(BuildContext context) {
    final keys = <PageStorageKey<dynamic>>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return _StorageIdentifier(keys.reversed.toList());
  }

  static bool _maybeAddKey(
      BuildContext context, List<PageStorageKey<dynamic>> keys) {
    final widget = context.widget;
    final key = widget.key;
    if (key is PageStorageKey) {
      keys.add(key);
    }
    return widget is! GlobalStorage;
  }

  @override
  String toString() => 'WebPageStorageBucket {name: $name}';
}

class HiveStorageBucket extends StorageBucket {
  HiveStorageBucket(String name) : super(name, HiveStorage.instance);
}

class WebLocalStorageBucket extends StorageBucket {
  WebLocalStorageBucket(String name) : super(name, WebStorage.local);
}

class WebSessionStorageBucket extends StorageBucket {
  WebSessionStorageBucket(String name) : super(name, WebStorage.session);
}

/// Establish a subtree in which widgets can opt into persisting states after
/// being destroyed.
///
/// [GlobalStorage] is used to save and restore values that can outlive the widget.
class GlobalStorage<T extends StorageBucket> extends InheritedWidget {
  const GlobalStorage({
    super.key,
    required this.bucket,
    required super.child,
  });

  /// The storage bucket to use by wrapped widget subtree.
  final T bucket;

  /// The bucket from the closest instance of this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final <T extends StorageBucket> storage = GlobalStorage.of(context);
  /// ```
  ///
  static T of<T extends StorageBucket>(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<GlobalStorage>();
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
    return (inheritedElement?.widget as GlobalStorage<T>).bucket;
  }

  /// The identifier from the closest instance of this class that encloses the given context.
  static String identifierOf(BuildContext context) =>
      of(context)._getIdentifier(context);

  @override
  bool updateShouldNotify(GlobalStorage oldWidget) =>
      bucket != oldWidget.bucket;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      '$_className {bucket: ${bucket.name}}';

  static const _className = 'GlobalStorage';
}

@immutable
class _StorageIdentifier {
  const _StorageIdentifier(this.keys);

  final List<PageStorageKey<dynamic>> keys;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is _StorageIdentifier &&
          listEquals<PageStorageKey<dynamic>>(other.keys, keys);

  @override
  int get hashCode => Object.hashAll(keys);

  @override
  String toString() => 'StorageIdentifier {${keys.join(":")}}';
}
