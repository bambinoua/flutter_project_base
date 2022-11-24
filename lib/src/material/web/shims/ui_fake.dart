import 'package:meta/meta.dart';
import 'package:universal_html/html.dart';

/// A function which takes an unique `id` and creates an HTML element.
///
/// This is made available to end-users throw dart:ui in web.
typedef PlatformViewFactory = Element Function(int viewId);

// Fake interface for the logic that this package needs from (web-only) dart:ui.
// This is conditionally exported so the analyzer sees these methods as available.

/// Shim for web_ui engine.PlatformViewRegistry
/// https://github.com/flutter/engine/blob/master/lib/web_ui/lib/ui.dart#L62
/// ignore: camel_case_types, avoid_classes_with_only_static_members
@sealed
class PlatformViewRegistry {
  /// Shim for registerViewFactory
  /// https://github.com/flutter/engine/blob/master/lib/web_ui/lib/ui.dart#L72
  bool registerViewFactory(String viewType, PlatformViewFactory viewFactory) {
    throw UnsupportedError("platform view registry in non-web context");
  }
}

final platformViewRegistry = PlatformViewRegistry();
