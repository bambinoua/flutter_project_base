import 'dart:async';

import 'package:flutter/material.dart';

/// Shows a modal material design bottom sheet with rounded corners.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
Future<T?> showModalRoundedBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  double maxScreenFraction = 0.8,
  BorderRadiusGeometry? borderRadius,
}) {
  assert(maxScreenFraction > 0.0 && maxScreenFraction <= 1.0);
  final size = MediaQuery.of(context).size;
  final effectiveBorderRadius = borderRadius ??
      const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      );
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: effectiveBorderRadius,
    ),
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints.loose(
            Size(size.width, size.height * maxScreenFraction)),
        child: builder(context),
      );
    },
    isScrollControlled: isScrollControlled,
  );
}

extension RenderBoxExtension on BuildContext {
  /// Finds a widget identified by `key`.
  Future<Rect> findWidgetRect<T extends Widget>(LocalKey key) async {
    assert(T != Widget);
    final completer = Completer<RenderBox>();
    visitAncestorElements((element) {
      if (element.widget is T && element.widget.key == key) {
        completer.complete(element.renderObject as RenderBox);
        return false;
      }
      return true;
    });
    final renderBox = await completer.future;
    final topLeft =
        renderBox.localToGlobal(renderBox.size.topLeft(Offset.zero));
    return topLeft & renderBox.size;
  }

  /// Returns [Rect] of this context.
  Rect getRect() {
    final renderBox = findRenderObject() as RenderBox?;
    assert(renderBox != null);
    final topLeft =
        renderBox!.localToGlobal(renderBox.size.topLeft(Offset.zero));
    final bottomRight =
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
    return Rect.fromPoints(topLeft, bottomRight);
  }
}
