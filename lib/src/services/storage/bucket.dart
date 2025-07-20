import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services.dart';

///
abstract class PreferencesBucket extends ChangeNotifier {
  PreferencesBucket(this.name, this.storage) : assert(name != '');

  /// Keeps the name of this storage.
  final String name;

  /// The underlying storage.
  final KeyValueStorage<String, Object> storage;

  /// The internal storage map.
  final Map<String, PreferenceValue<dynamic, dynamic>> _values = {};

  /// Registers a [preferenceValue].
  void registerPreferenceValue<T, S>(PreferenceValue<T, S> preferenceValue) {
    _values.putIfAbsent(preferenceValue.key, () => preferenceValue);
  }

  /// Unregisters a preference value with the given [storageKey].
  void unregisterPreferenceValue<T>(String storageKey) {
    _values.removeWhere((key, value) => key == storageKey);
  }

  @override
  String toString() => 'PreferencesBucket {name: $name}';
}

mixin StorableMixin<T extends StatefulWidget> on State<T> {
  late final PreferencesBucket _bucket;

  String get storageKey;

  @override
  void initState() {
    super.initState();
    //_bucket =
  }

  void registerStorableValue(PreferenceValue<String, dynamic> preferenceValue) {
    _bucket.registerPreferenceValue(preferenceValue);
  }

  /// Retursn the current flattened identifier of the this widget in the specified `context`.
  // ignore: unused_element
  String _getIdentifier(BuildContext context) =>
      _computeIdentifier(context).keys.map((key) => key).join('.');

  _StorageIdentifier _computeIdentifier(BuildContext context) {
    final keys = <String>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return _StorageIdentifier(keys.reversed.toList());
  }

  static bool _maybeAddKey(BuildContext context, List<String> keys) {
    final mixin = context.findAncestorStateOfType<StorableMixin>();
    final widget = context.widget;
    final key = mixin?.storageKey ?? '';
    if (key.isNotEmpty) {
      keys.add(key);
    }
    return widget is! StorableMixin;
  }
}

@immutable
class _StorageIdentifier {
  const _StorageIdentifier(this.keys);

  final List<String> keys;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is _StorageIdentifier && listEquals<String>(other.keys, keys);

  @override
  int get hashCode => Object.hashAll(keys);

  @override
  String toString() => 'StorageIdentifier {${keys.join('-')}}';
}

class PreferenceContainer extends StatelessWidget {
  const PreferenceContainer({
    super.key,
    required this.bucket,
    required this.child,
  });

  /// The preference bucket to use by wrapped widget subtree.
  final PreferencesBucket bucket;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static const _className = 'PreferenceContainer';

  /// The bucket from the closest instance of this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final PreferencesBucket bucket = PreferenceContainer.of(context);
  /// ```
  static PreferencesBucket of(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<PreferenceContainer>();
    assert(() {
      if (widget == null) {
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
    return widget!.bucket;
  }
}
