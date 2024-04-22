import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  /// Returns the [Rect] structure of the widget of type T with the specified local [key].
  Rect findWidgetRectByKey<T extends Widget>(LocalKey key) {
    RenderBox? renderBox;
    visitAncestorElements((element) {
      if (element.widget is T && element.widget.key == key) {
        renderBox = element.findRenderObject() as RenderBox;
        return false;
      }
      return true;
    });
    assert(() {
      if (renderBox == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot get renderObject of inactive element.'),
          ErrorDescription(
              'In order for an element to have a valid renderObject, it must be '
              'active, which means it is part of the tree.'),
          describeElement(
              'The findRenderObject() method was called for the following element'),
        ]);
      }
      return true;
    }());
    final topLeft =
        renderBox!.localToGlobal(renderBox!.size.topLeft(Offset.zero));
    return topLeft & renderBox!.size;
  }

  /// Returns the [Rect] structure for the given context.
  Rect getRect() {
    final renderBox = findRenderObject() as RenderBox?;
    assert(renderBox != null);
    final topLeft =
        renderBox!.localToGlobal(renderBox.size.topLeft(Offset.zero));
    return topLeft & renderBox.size;
  }
}
