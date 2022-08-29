import 'package:flutter/material.dart';
import 'package:flutter_project_base/flutter_project_base.dart';

const _kAnimationDuration = Duration(milliseconds: 400);

final _connectivity = InternetConnectivity();

class InternetConnectivityBar extends StatefulWidget {
  const InternetConnectivityBar({
    Key? key,
    this.onStateChange,
    required this.child,
  }) : super(key: key);

  /// Callbacks when Internet connection state has changed.
  final ValueChanged<bool>? onStateChange;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<InternetConnectivityBar> createState() =>
      _InternetConnectivityBarState();
}

class _InternetConnectivityBarState extends State<InternetConnectivityBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> sizeFactor;

  @override
  void dispose() {
    _connectivity.removeListener(_connectivityHandler);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: _kAnimationDuration);
    sizeFactor = Tween<double>(begin: 0, end: 1).animate(controller);
    _connectivity.addListener(_connectivityHandler);
    if (_connectivity.isDisconnected) {
      _connectivityHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SizeTransition(
            sizeFactor: sizeFactor,
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.error,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'No Internet connection',
                style: context.theme.textTheme.labelLarge!
                    .copyWith(color: context.theme.colorScheme.onPrimary),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _connectivityHandler() {
    widget.onStateChange?.call(_connectivity.isConnected);
    _connectivity.isConnected ? controller.reverse() : controller.forward();
  }
}
