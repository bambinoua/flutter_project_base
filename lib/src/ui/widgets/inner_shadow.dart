import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Appends inner shadow to [child].
class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    super.key,
    this.shadows = const <Shadow>[],
    super.child,
  });

  /// A list of shadows.
  ///
  /// See also:
  ///
  ///  * [kElevationToShadow], for some predefined shadows used in Material Design.
  ///  * [PhysicalModel], a widget for showing shadows.
  final List<Shadow> shadows;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderInnerShadow(shadows);

  @override
  void updateRenderObject(
      BuildContext context, RenderInnerShadow renderObject) {
    renderObject.shadows = shadows;
  }
}

class RenderInnerShadow extends RenderProxyBox {
  RenderInnerShadow(this.shadows);

  late List<Shadow> shadows;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final bounds = offset & size;

    context.canvas.saveLayer(bounds, Paint());
    context.paintChild(child!, offset);

    for (final shadow in shadows) {
      final shadowRect = bounds.inflate(shadow.blurSigma);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..colorFilter = ColorFilter.mode(shadow.color, BlendMode.srcOut)
        ..imageFilter = ImageFilter.blur(
            sigmaX: shadow.blurSigma, sigmaY: shadow.blurSigma);
      context.canvas
        ..saveLayer(shadowRect, shadowPaint)
        ..translate(shadow.offset.dx, shadow.offset.dy);
      context.paintChild(child!, offset);
      context.canvas.restore();
    }

    context.canvas.restore();
  }
}
