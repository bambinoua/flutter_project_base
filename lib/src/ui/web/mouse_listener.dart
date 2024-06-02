import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that calls callbacks in response to mouse pointer events.
///
/// It listens to events that can construct gestures, such as when the
/// pointer is pressed, then released or canceled.
class MousePointerListener extends StatefulWidget {
  const MousePointerListener({
    super.key,
    this.doubleClickTime = Durations.long1,
    this.onPointerDown,
    this.onPointerDoubleDown,
    this.onPointerHover,
    this.behavior = HitTestBehavior.deferToChild,
    this.child,
  }) : assert(doubleClickTime >= Durations.medium1,
            'Double click time should not be less than ${Durations.medium1}');

  /// The maximum number of milliseconds that can elapse between a first click and a second click
  /// for the OS to consider the mouse action a double-click.
  ///
  /// Default value is 450 ms.
  final Duration doubleClickTime;

  /// A pointer that might cause a tap with a primary button has contacted the
  /// screen at a particular location.
  final PointerDownEventListener? onPointerDown;

  /// A pointer that might cause a double tap has contacted the screen at a
  /// particular location.
  ///
  /// Triggered immediately after the down event of the second tap.
  final PointerDownEventListener? onPointerDoubleDown;

  /// Called when a pointer that has not triggered an [onPointerDown] changes
  /// position.
  ///
  /// This is only fired for pointers which report their location when not down
  /// (e.g. mouse pointers, but not most touch pointers).
  final PointerHoverEventListener? onPointerHover;

  /// How to behave during hit testing.
  final HitTestBehavior behavior;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  State<MousePointerListener> createState() => _MousePointerListenerState();
}

class _MousePointerListenerState extends State<MousePointerListener> {
  Timer? _timer;

  bool _isFirstClick = true;
  bool _isDoubleClick = true;
  double _milliseconds = 0;

  bool get _isDoubleClickExpired =>
      _milliseconds >= widget.doubleClickTime.inMilliseconds;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerHover: widget.onPointerHover,
      behavior: widget.behavior,
      child: widget.child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_isFirstClick) {
      _isFirstClick = false;
      _timer = Timer.periodic(
          Duration(milliseconds: widget.doubleClickTime.inMilliseconds ~/ 10),
          (_) => _onTimerTick(event));
    } else {
      if (_isDoubleClickExpired) {
        _isDoubleClick = true;
      }
    }
  }

  void _onTimerTick(PointerDownEvent event) {
    _milliseconds += 100;

    if (!_isDoubleClickExpired) {
      return;
    }

    _timer!.cancel();

    _isDoubleClick
        ? widget.onPointerDoubleDown?.call(event)
        : widget.onPointerDown?.call(event);

    _isFirstClick = true;
    _isDoubleClick = false;
    _milliseconds = 0;
  }
}
