import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/src/ui/scaffold_messenger.dart';

import '../../core/contracts.dart';

const kIndent32px = 32.0;
const kIndent24px = 24.0;
const kIndent16px = 16.0;
const kIndent08px = 8.0;
const kIndent04px = 4.0;
const kIndent02px = 2.0;

/// [Widget] extensions.
extension Widgets on Widget {
  /// Returns class name of the widget.
  String get className => objectRuntimeType(this, '');
}

class UtilityWidgets {
  UtilityWidgets._();

  static const circularProgressIndicator =
      Center(child: CircularProgressIndicator.adaptive());

  static const horizontalDivider = Divider(height: 1);
  static const verticalDivider = Divider(height: 1);

  static const horizontalGap32 = SizedBox(width: kIndent32px);
  static const horizontalGap24 = SizedBox(width: kIndent24px);
  static const horizontalGap16 = SizedBox(width: kIndent16px);
  static const horizontalGap08 = SizedBox(width: kIndent08px);
  static const horizontalGap04 = SizedBox(width: kIndent04px);

  static const verticalGap32 = SizedBox(height: kIndent32px);
  static const verticalGap24 = SizedBox(height: kIndent24px);
  static const verticalGap16 = SizedBox(height: kIndent16px);
  static const verticalGap08 = SizedBox(height: kIndent08px);
  static const verticalGap04 = SizedBox(height: kIndent04px);
}

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
class StreamBuilderWithCallback<T> extends StreamBuilder<T> {
  const StreamBuilderWithCallback({
    super.key,
    super.initialData,
    super.stream,
    required super.builder,
    required this.onData,
  });

  /// Called back when StreamBuilder has a data.
  final ValueChanged<T> onData;

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    onData(data);
    return super.afterData(current, data);
  }
}

/// Inherited widget which composes the path to the specific widget in the widget tree.
class WidgetPathProvider extends InheritedWidget {
  const WidgetPathProvider({
    super.key,
    required super.child,
    this.userId = '',
  });

  /// Optional user identifier. Usually it is authenticated user identifier.
  final String userId;

  /// Retursn the current path of the this widget in the specified `context`.
  String getPath(BuildContext context) {
    final path = _computePath(context).keys.map((key) => key.value).join('.');
    return userId.isNotEmpty ? '$userId.$path' : path;
  }

  /// Returns the widget path as list of [PathKey]s.
  List<PathKey> getPathKeys(BuildContext context) => _computePath(context).keys;

  @override
  bool updateShouldNotify(WidgetPathProvider oldWidget) => false;

  /// Searches for instance of [WidgetPathProvider] above the tree and returns it.
  static WidgetPathProvider? of(BuildContext context,
      {bool suppressError = false}) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<WidgetPathProvider>();
    if (!suppressError) {
      assert(() {
        if (inheritedElement == null) {
          throw FlutterError.fromParts([
            ErrorSummary('Error: Could not find the `WidgetPathProvider` above '
                'this `${context.widget}` widget'),
            ErrorDescription(
                'This happens because you used a `BuildContext` that does not include '
                'the `WidgetPathProvider`. Make sure that you wrap your `home` widget '
                'with `WidgetPathProvider`'),
          ]);
        }
        return true;
      }());
    }
    return inheritedElement?.widget as WidgetPathProvider;
  }

  _PathSegmentIdentifier _computePath(BuildContext context) =>
      _PathSegmentIdentifier(_allKeys(context).reversed.toList());

  List<PathKey> _allKeys(BuildContext context) {
    final keys = <PathKey>[];
    if (_maybeAddKey(context, keys)) {
      context.visitAncestorElements((element) => _maybeAddKey(element, keys));
    }
    return keys;
  }

  static bool _maybeAddKey(BuildContext context, List<PathKey> keys) {
    final widget = context.widget;
    final key = widget.key;
    if (key is PathKey) keys.add(key);
    return widget is! WidgetPathProvider;
  }
}

@immutable
class _PathSegmentIdentifier extends Equatable with Emptiable {
  const _PathSegmentIdentifier(this.keys);

  final List<PathKey> keys;

  @override
  bool get isEmpty => keys.isEmpty;

  @override
  List<Object?> get props => [keys];
}

/// A value key which is used to persist the widget path.
@immutable
class PathKey extends ValueKey<String> {
  const PathKey(super.value);
}

/// Mixin for implementing [WidgetPathProvider] for widget path generating.
mixin WidgetPathProviderMixin<T extends StatefulWidget> on State<T> {
  /// Returns the current path which is built with calling widgets path segments.
  String get currentPath => _pathProvider.getPath(context);

  /// Returns the widget path as list of [PathKey]s.
  List<PathKey> get pathKeys => _pathProvider.getPathKeys(context);

  /// Indicates wheher error will raise if [WidgetPathProvider] not found as ancestor.
  bool get suppressProviderNotFoundError => false;

  late WidgetPathProvider _pathProvider;

  @override
  void initState() {
    super.initState();
    _pathProvider = WidgetPathProvider.of(context,
        suppressError: suppressProviderNotFoundError)!;
  }
}

/// Custom `dual ring` circular progress indicator.
class DualRingProgressIndicator extends StatefulWidget {
  const DualRingProgressIndicator({
    super.key,
    this.duration = const Duration(seconds: 1),
    this.color = const Color(0xff3b82f6),
    this.diameter = 36.0,
    this.text,
  })  : assert(duration != Duration.zero),
        assert(diameter > 0);

  /// The duration of progress animation.
  final Duration duration;

  /// The color of the progress indicator.
  final Color color;

  /// The ring diameter of the progress indicator.
  final double diameter;

  /// Optional [Text] widget which is under the ring.
  final Widget? text;

  @override
  State<DualRingProgressIndicator> createState() =>
      _DualRingProgressIndicatorState();
}

class _DualRingProgressIndicatorState extends State<DualRingProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: CustomPaint(
              painter: _DualRingPainter(
                widget.color,
                widget.diameter,
              ),
            ),
          ),
          if (widget.text != null) ...[
            const SizedBox(height: 20.0),
            widget.text!,
          ],
        ],
      ),
    );
  }
}

/// Custom painter which draws the "dual ring".
class _DualRingPainter extends CustomPainter {
  _DualRingPainter(this.color, this.diameter) : assert(diameter > 0);

  /// The color of paint.
  final Color color;

  /// The diameter of dual ring.
  final double diameter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 6.0;
    _drawArc(canvas, 2.0, paint);
    _drawArc(canvas, math.pi, paint);
  }

  void _drawArc(Canvas canvas, double sweepAngle, Paint paint) {
    canvas.drawArc(
        Rect.fromCenter(center: Offset.zero, width: diameter, height: diameter),
        0.0,
        sweepAngle,
        false,
        paint);
  }

  @override
  bool shouldRepaint(_DualRingPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_DualRingPainter oldDelegate) => false;
}

/// Container with shadow.
class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({super.key, required this.child});

  /// The [child] contained by the container.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: MediaQuery.platformBrightnessOf(context) == Brightness.light
                ? const Color(0x0f000000)
                : const Color(0xff323232),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Widget which allows to hide the keyboard when user taps on wrapped
/// child widget.
class DismissibleKeyboard extends StatelessWidget {
  const DismissibleKeyboard({
    super.key,
    this.enabled = true,
    required this.child,
  });

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

/// Whether wrap the child with some other widget(s).
class IfElseWrapper extends StatelessWidget {
  const IfElseWrapper({
    super.key,
    this.wrapIf = _alwaysReturnsFalse,
    required this.ifBuilder,
    this.elseBuilder,
    required this.child,
  });

  /// Switches between wrapping the [child] with a [ifBuilder] or [elseBuilder].
  final bool Function() wrapIf;

  /// The widget to use when [wrapIf] return `true`.
  final TransitionBuilder ifBuilder;

  /// The widget to use when [wrapIf] return `false`.
  ///
  /// If this builder is omitted then the [child] widget is built.
  final TransitionBuilder? elseBuilder;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return wrapIf()
        ? ifBuilder(context, child)
        : elseBuilder != null
            ? elseBuilder!(context, child)
            : child;
  }
}

bool _alwaysReturnsFalse() => false;

/// A set of toggle buttons working as [Radio] widget.
class ToggleRadio<T> extends StatefulWidget {
  const ToggleRadio({
    super.key,
    required this.items,
    this.focusNodes,
    this.constraints,
    this.tapTargetSize,
    this.value,
    this.isExpanded = false,
    this.renderBorder = true,
    this.onChanged,
  })  : assert(!isExpanded || constraints == null),
        assert(items.length > 0);

  /// The toggle button widgets.
  final List<ToggleRadioItem<T>> items;

  /// The initial value.
  final T? value;

  /// The callback that is called when a button is tapped.
  ///
  /// The index parameter of the callback is the index of the button that is
  /// tapped or otherwise activated.
  ///
  /// When the callback is null, all toggle buttons will be disabled.
  final ValueChanged<T>? onChanged;

  /// The list of [FocusNode]s, corresponding to each toggle button.
  ///
  /// Focus is used to determine which widget should be affected by keyboard
  /// events. The focus tree keeps track of which widget is currently focused
  /// on by the user.
  ///
  /// If not null, the length of focusNodes has to match the length of
  /// [items].
  final List<FocusNode>? focusNodes;

  /// Defines the button's size.
  ///
  /// Typically used to constrain the button's minimum size.
  ///
  /// If this property is null, then
  /// BoxConstraints(minWidth: 48.0, minHeight: 48.0) is be used.
  final BoxConstraints? constraints;

  /// Configures the minimum size of the area within which the buttons may
  /// be pressed.
  ///
  /// If the [tapTargetSize] is larger than [constraints], the buttons will
  /// include a transparent margin that responds to taps.
  ///
  /// Defaults to [ThemeData.materialTapTargetSize].
  final MaterialTapTargetSize? tapTargetSize;

  /// Set this widget to horizontally fill its parent.
  final bool isExpanded;

  /// Whether or not to render a border around each toggle button.
  ///
  /// When true, a border with [borderWidth], [borderRadius] and the
  /// appropriate border color will render. Otherwise, no border will be
  /// rendered.
  final bool renderBorder;

  @override
  State<ToggleRadio<T>> createState() => _ToggleRadioState<T>();
}

class _ToggleRadioState<T> extends State<ToggleRadio<T>> {
  late final List<bool> _isSelected;

  late BoxConstraints _constraints;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(widget.items.length,
        (index) => widget.items[index].value == widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final haveItemsFocusNodes =
        widget.items.every((item) => item.focusNode != null);
    final focusNodes = haveItemsFocusNodes
        ? widget.items.map((item) => item.focusNode!).toList()
        : widget.focusNodes;

    if (focusNodes?.isNotEmpty ?? false) {
      assert(focusNodes!.length == widget.items.length);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _constraints = constraints;
        return ToggleButtons(
          constraints: widget.constraints,
          tapTargetSize: widget.tapTargetSize,
          focusNodes: focusNodes,
          renderBorder: widget.renderBorder,
          isSelected: _isSelected,
          onPressed: widget.onChanged != null
              ? (index) {
                  setState(() {
                    for (var i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = i == index;
                    }
                  });
                  widget.onChanged?.call(widget.items[index].value);
                }
              : null,
          children: widget.items,
        );
      },
    );
  }
}

/// An item in a menu created by a [ToggleRadio].
///
/// The type `T` is the type of the value the item represents. All the items
/// in a given menu must represent values with consistent types.
class ToggleRadioItem<T> extends StatelessWidget {
  const ToggleRadioItem({
    super.key,
    this.focusNode,
    this.title,
    this.titleColor,
    this.icon,
    this.iconColor,
    this.width,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
    required this.value,
  }) : assert(title != null || icon != null, 'Missing title or icon property');

  final String? title;
  final Color? titleColor;
  final IconData? icon;
  final Color? iconColor;
  final FocusNode? focusNode;
  final double? width;
  final EdgeInsetsGeometry contentPadding;
  final T value;

  @override
  Widget build(BuildContext context) {
    final parentState =
        context.findAncestorStateOfType<_ToggleRadioState<T>>()!;
    final totalDividersWidth = parentState.widget.renderBorder
        ? parentState.widget.items.length + 1
        : 0;
    final itemWidth = (parentState._constraints.maxWidth - totalDividersWidth) /
        parentState.widget.items.length;

    return IfElseWrapper(
      wrapIf: () => parentState.widget.isExpanded,
      ifBuilder: (context, child) {
        return SizedBox(
          width: itemWidth,
          child: child,
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width ?? double.infinity),
        child: Padding(
          padding: contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: iconColor),
              if (title != null) ...[
                if (icon != null) UtilityWidgets.horizontalGap08,
                Text(title!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// class ToggleRadioFormField<T> extends FormField<T> {
//   ToggleRadioFormField({
//     super.key,
//     required List<ToggleRadioItem<T>> items,
//     List<FocusNode>? focusNodes,
//     BoxConstraints? constraints,
//     MaterialTapTargetSize? tapTargetSize,
//     T? initialValue,
//     bool isExpanded = false,
//     bool renderBorder = true,
//     ValueChanged<T>? onChanged,
//     FormFieldSetter<T>? onSaved,
//     FormFieldValidator<T>? validator,
//   }) : super(
//           builder: (state) => ToggleRadio(
//             key: key,
//             items: items,
//             focusNodes: focusNodes,
//             constraints: constraints,
//             tapTargetSize: tapTargetSize,
//             value: initialValue,
//             isExpanded: isExpanded,
//             renderBorder: renderBorder,
//             onChanged: onChanged,
//           ),
//           initialValue: initialValue,
//           validator: validator,
//           onSaved: onSaved,
//         );
// }
