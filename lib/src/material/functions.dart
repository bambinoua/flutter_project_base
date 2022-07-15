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
