import 'package:universal_html/html.dart';

/// A function which takes an unique `id` and creates an HTML element.
///
/// This is made available to end-users throw dart:ui in web.
typedef PlatformViewFactory = Element Function(int viewId);

/// A function which takes an unique `id` and some `params` and creates an HTML element.
///
/// This is made available to end-users throw dart:ui in web.
typedef ParamertrizedPlatformViewFactory = Element Function(int viewId,
    {Object? params});

// ignore: camel_case_types
class platformViewRegistry {
  static bool registryViewFactory(
          String viewType, PlatformViewFactory viewFactory) =>
      true;
}
