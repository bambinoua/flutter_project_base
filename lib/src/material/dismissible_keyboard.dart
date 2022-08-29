import 'package:flutter/material.dart';

/// Widget which allows to hide the keyboard when user taps on wrapped
/// child widget.
class DismissibleKeyboard extends StatelessWidget {
  const DismissibleKeyboard({
    Key? key,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  /// Whether tap is enabled.
  final bool enabled;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: enabled ? HitTestBehavior.translucent : HitTestBehavior.opaque,
      onTap: enabled
          ? () {
              if (FocusScope.of(context).isFirstFocus) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            }
          : null,
      child: child,
    );
  }
}
