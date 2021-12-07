import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_base/src/contracts.dart';

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
class StreamBuilderWithCallback<T> extends StreamBuilder<T> {
  StreamBuilderWithCallback({
    Key? key,
    this.initialData,
    Stream<T>? stream,
    required this.builder,
    required this.onData,
  }) : super(
            key: key,
            initialData: initialData,
            stream: stream,
            builder: builder);

  /// The build strategy currently used by this builder.
  ///
  /// This builder must only return a widget and should not have any side
  /// effects as it may be called multiple times.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  ///
  /// Providing this value (presumably obtained synchronously somehow when the
  /// [Stream] was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final T? initialData;

  /// Called back when StreamBuilder has a data.
  final ValueChanged<T> onData;

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    onData(data);
    return super.afterData(current, data);
  }
}

/// Inherited widget which composes the path to the specific widget in the widget tree.
class WidgetPathProvider extends InheritedWidget {
  const WidgetPathProvider({
    Key? key,
    required Widget child,
    this.userId = '',
  }) : super(key: key, child: child);

  /// Optional user identifier. Usually it is authenticated user identifier.
  final String userId;

  /// Retursn the current path of the this widget in the specified `context`.
  String getPath(BuildContext context) {
    final path = _computePath(context).keys.map((key) => key.value).join('.');
    return userId.isNotEmpty ? '$userId.$path' : path;
  }

  /// Returns the widget path as list of [PathKey]s.
  List<PathKey> getPathKeys(BuildContext context) => _computePath(context).keys;

  @override
  bool updateShouldNotify(WidgetPathProvider oldWidget) => false;

  /// Searches for instance of [WidgetPathProvider] above the tree and returns it.
  static WidgetPathProvider? of(BuildContext context,
      {bool suppressError = false}) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<WidgetPathProvider>();
    if (!suppressError) {
      assert(() {
        if (inheritedElement == null) {
          throw FlutterError.fromParts([
            ErrorSummary('Error: Could not find the `WidgetPathProvider` above '
                'this `${context.widget}` widget'),
            ErrorDescription(
                'This happens because you used a `BuildContext` that does not include '
                'the `WidgetPathProvider`. Make sure that you wrap your `home` widget '
                'with `WidgetPathProvider`'),
          ]);
        }
        return true;
      }());
    }
    return inheritedElement?.widget as WidgetPathProvider;
  }

  _PathSegmentIdentifier _computePath(BuildContext context) =>
      _PathSegmentIdentifier(_allKeys(context).reversed.toList());

  List<PathKey> _allKeys(BuildContext context) {
    final keys = <PathKey>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return keys;
  }

  static bool _maybeAddKey(BuildContext context, List<PathKey> keys) {
    final widget = context.widget;
    final key = widget.key;
    if (key is PathKey) keys.add(key);
    return widget is! WidgetPathProvider;
  }
}

@immutable
class _PathSegmentIdentifier extends Equatable with Emptiable {
  const _PathSegmentIdentifier(this.keys);

  final List<PathKey> keys;

  @override
  bool get isEmpty => keys.isEmpty;

  @override
  List<Object?> get props => [keys];
}

/// A value key which is used to persist the widget path.
@immutable
class PathKey extends ValueKey<String> {
  const PathKey(String value) : super(value);
}

/// Mixin for implementing [WidgetPathProvider] for widget path generating.
mixin WidgetPathProviderMixin<T extends StatefulWidget> on State<T> {
  /// Returns the current path which is built with calling widgets path segments.
  String get currentPath => _pathProvider.getPath(context);

  /// Returns the widget path as list of [PathKey]s.
  List<PathKey> get pathKeys => _pathProvider.getPathKeys(context);

  /// Indicates wheher error will raise if [WidgetPathProvider] not found as ancestor.
  bool get suppressProviderNotFoundError => false;

  late WidgetPathProvider _pathProvider;

  @override
  void initState() {
    super.initState();
    _pathProvider = WidgetPathProvider.of(context,
        suppressError: suppressProviderNotFoundError)!;
  }
}
