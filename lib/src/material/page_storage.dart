import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../core/contracts.dart';

class PageStateKey extends ValueKey<String> {
  /// Creates a [ValueKey] that defines where [PageStorage] values will be saved.
  const PageStateKey(String value) : super(value);
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

class PageStateBucket {
  final _internalStorage = <String, Object>{};

  void writeState(BuildContext context, String key, Object data) {
    _internalStorage[key] = data;
  }

  T? readState<T>(BuildContext context, String key) {
    return null;
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
}

class PageStateStorage extends InheritedWidget {
  const PageStateStorage({
    Key? key,
    this.name = 'state',
    required Widget child,
  }) : super(key: key, child: child);

  /// Keeps the name of this storage
  final String name;

  static PageStateStorage? of(BuildContext context) {
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
    return inheritedElement?.widget as PageStateStorage;
  }

  @override
  bool updateShouldNotify(PageStateStorage oldWidget) {
    return name != oldWidget.name;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '$_kClassName {name: $name}';
  }

  static const _kClassName = 'PageStateStorage';
}
