import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

import '../../core/contracts.dart';
import 'shims/ui_fake.dart' if (dart.library.html) 'shims/ui_real.dart' as ui;

abstract class HtmlElementViewFactory<T extends Element> implements Disposable {
  HtmlElementViewFactory(this._viewType) : assert(kIsWeb) {
    if (!_cache.containsKey(_viewType)) {
      _cache.putIfAbsent(_viewType, () => this);
      // ignore: undefined_prefixed_name, avoid_dynamic_calls
      ui.platformViewRegistry.registerViewFactory(_viewType, build);
    }
  }

  /// The unique identifier for the HTML view type to be embedded.
  final String _viewType;

  /// Underlying HTML element.
  late final T _element;

  /// Describes the part of the user interface represented by this view.
  @protected
  T build(int viewId);

  static final _cache = <String, HtmlElementViewFactory>{};

  @override
  void dispose() {
    _cache.remove(_viewType);
  }

  @override
  String toString() => _viewType;
}

class DivHtmlElement extends HtmlElementViewFactory<DivElement> {
  /// Creates a HTML DIV element.
  ///
  /// If `id` is specified it must be unique among all document.
  DivHtmlElement({
    String? id,
    this.className,
    bool unifyIdAttribute = true,
  })  : assert(className == null || className.isNotEmpty),
        _unifyIdAttribute = unifyIdAttribute,
        super(id ?? 'flutter-project-base-div');

  /// Whether element's `id` must be additionaly unified.
  final bool _unifyIdAttribute;

  /// Element's class name.
  final String? className;

  /// Returns value of element's `id` attribute.
  String get id => _element.id;

  @override
  DivElement build(int viewId) {
    _element = DivElement()
      ..id = _unifyIdAttribute ? '$_viewType-$viewId' : _viewType
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'relative'
      ..style.overflow = 'hidden';
    if (className != null) {
      _element.className = className!;
    }
    return _element;
  }
}
