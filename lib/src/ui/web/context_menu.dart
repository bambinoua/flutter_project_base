import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' hide VoidCallback;

import '../../../ui.dart';

const _contextMenu = 'contextmenu';

/// The widget provides a context menu base on [showMenu] for web platform.
class WebContextMenu<T> extends StatefulWidget {
  const WebContextMenu({
    super.key,
    required this.wrappingHtmlElement,
    required this.itemBuilder,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    required this.child,
  }) : assert(kIsWeb, 'WebContextMenu is only available on web platform');

  /// The HTML element which wraps the target for context menu.
  final HtmlElement wrappingHtmlElement;

  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled? onCanceled;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  State<WebContextMenu<T>> createState() => _WebContextMenuState<T>();
}

class _WebContextMenuState<T> extends State<WebContextMenu<T>> {
  late final _eventListener = _pointerEventListener;

  @override
  void dispose() {
    window.removeEventListener(_contextMenu, _eventListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    window.addEventListener(_contextMenu, _eventListener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: _onSecondaryTapDown,
      child: Stack(
        children: [
          HtmlElementView(
            viewType: DivHtmlElement(
              id: widget.wrappingHtmlElement.id,
              className: widget.wrappingHtmlElement.className,
              unifyIdAttribute: false,
            ).toString(),
          ),
          widget.child,
        ],
      ),
    );
  }

  dynamic _pointerEventListener(Event event) {
    final target = event.target as HtmlElement;
    final wrapper = widget.wrappingHtmlElement;
    if (target.id == wrapper.id && target.className == wrapper.className) {
      event.preventDefault();
    }
  }

  void _onSecondaryTapDown(TapDownDetails event) async {
    widget.onOpened?.call();

    final offset = event.globalPosition;
    final value = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx,
        offset.dy,
      ),
      items: widget.itemBuilder(context),
    );

    if (value != null) {
      widget.onSelected?.call(value);
    } else {
      widget.onCanceled?.call();
    }
  }
}
