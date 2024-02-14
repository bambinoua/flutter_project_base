import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Provides a functionality for capture the widget as image.
final class WidgetToImage {
  WidgetToImage._();

  /// Captures the widget.
  ///
  /// The [pixelRatio] describes the scale between the logical pixels and the
  /// size of the output image. It is independent of the
  /// [dart:ui.FlutterView.devicePixelRatio] for the device, so specifying 1.0
  /// (the default) will give you a 1:1 mapping between logical pixels and the
  /// output pixels in the image.
  ///
  /// The [format] argument specifies the format in which the bytes will be
  /// returned.
  static Future<Uint8List> capture(
    Widget widget, {
    BuildContext? context,
    double pixelRatio = 1.0,
    Duration buildDelay = Duration.zero,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final flutterView = context != null
        ? View.of(context)
        : ui.PlatformDispatcher.instance.views.first;
    final logicalSize = flutterView.physicalSize / flutterView.devicePixelRatio;
    final widgetSize = flutterView.physicalSize;
    assert(logicalSize.aspectRatio == widgetSize.aspectRatio);

    final renderRepaintBoundary = RenderRepaintBoundary();
    final renderView = RenderView(
      view: flutterView,
      child: RenderPositionedBox(
        child: renderRepaintBoundary,
      ),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: pixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();

    final buildOwner = BuildOwner(
      focusManager: FocusManager(),
      onBuildScheduled: () {},
    );

    final rootElement = RenderObjectToWidgetAdapter(
      container: renderRepaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    if (buildDelay.inMicroseconds > 0) await Future.delayed(buildDelay);

    ui.Image? image;
    try {
      image = await renderRepaintBoundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: format);
      assert(byteData != null);
      return byteData!.buffer.asUint8List();
    } on Exception {
      return Uint8List(0);
    } finally {
      image?.dispose();
    }
  }
}
