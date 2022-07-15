import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/contracts.dart';

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
class StreamBuilderWithCallback<T> extends StreamBuilder<T> {
  const StreamBuilderWithCallback({
    Key? key,
    T? initialData,
    Stream<T>? stream,
    required AsyncWidgetBuilder<T> builder,
    required this.onData,
  }) : super(
            key: key,
            initialData: initialData,
            stream: stream,
            builder: builder);

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

/// Custom `dual ring` circular progress indicator.
class DualRingProgressIndicator extends StatefulWidget {
  const DualRingProgressIndicator({
    Key? key,
    this.duration = const Duration(seconds: 1),
    this.color = const Color(0xff3b82f6),
    this.diameter = 36.0,
    this.text,
  })  : assert(duration != Duration.zero),
        assert(diameter > 0),
        super(key: key);

  /// The duration of progress animation.
  final Duration duration;

  /// The color of the progress indicator.
  final Color color;

  /// The ring diameter of the progress indicator.
  final double diameter;

  /// Optional [Text] widget which is under the ring.
  final Widget? text;

  @override
  State<DualRingProgressIndicator> createState() =>
      _DualRingProgressIndicatorState();
}

class _DualRingProgressIndicatorState extends State<DualRingProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: CustomPaint(
              painter: _DualRingPainter(
                widget.color,
                widget.diameter,
              ),
            ),
          ),
          if (widget.text != null) ...[
            const SizedBox(height: 20.0),
            widget.text!,
          ],
        ],
      ),
    );
  }
}

/// Custom painter which draws the "dual ring".
class _DualRingPainter extends CustomPainter {
  _DualRingPainter(this.color, this.diameter) : assert(diameter > 0);

  /// The color of paint.
  final Color color;

  /// The diameter of dual ring.
  final double diameter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 6.0;
    _drawArc(canvas, 2.0, paint);
    _drawArc(canvas, math.pi, paint);
  }

  void _drawArc(Canvas canvas, double sweepAngle, Paint paint) {
    canvas.drawArc(
        Rect.fromCenter(center: Offset.zero, width: diameter, height: diameter),
        0.0,
        sweepAngle,
        false,
        paint);
  }

  @override
  bool shouldRepaint(_DualRingPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_DualRingPainter oldDelegate) => false;
}

/// [Widget] extensions.
extension Widgets on Widget {
  /// Returns class name of the widget.
  String get className => objectRuntimeType(this, '');
}
