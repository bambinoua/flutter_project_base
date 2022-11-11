// ignore_for_file: comment_references

import 'package:flutter/widgets.dart';

import '../core/contracts.dart';

/// A helper class which can be used for management of [TextField] widgets.
///
/// Combines `focusNode` and text editing `controller` in single object.
class TextFieldHelper<T> implements Disposable {
  TextFieldHelper({
    FocusNode? focusNode,
    TextEditingController? controller,
    String? initialText,
  })  : assert(controller == null || initialText == null),
        focusNode = focusNode ?? FocusNode(),
        controller = controller ?? TextEditingController(text: initialText);

  /// An object that can be used by a [TextField] widget to obtain the
  /// keyboard focus.
  final FocusNode? focusNode;

  /// A controller for an editable text field.
  final TextEditingController? controller;

  /// A [FormFieldState] [Key] identifier for [TextField].
  Key get key => _key ??= GlobalKey<FormFieldState<T>>();
  Key? _key;

  /// The current string the user is editing.
  String get text => controller!.text;

  /// Set the text `value` to empty.
  void clear() => controller!.clear();

  /// Requests the primary focus for this node.
  void setFocus() => focusNode!.requestFocus();

  /// Clears parent [TextField] and requests the primary focus for it.
  void reset() {
    clear();
    setFocus();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    controller!.dispose();
  }
}

/// A helper class which can be used for management of widgets which requires
/// a value like [Checkbox] or [DropdownButtonFormField].
///
/// Combines `focusNode` and editable `value` in single object.
class SelectableFieldHelper implements Disposable {
  SelectableFieldHelper({
    FocusNode? focusNode,
    this.value,
  }) : focusNode = focusNode ?? FocusNode();

  /// An object that can be used by a [Checkbox] widget to obtain the
  /// keyboard focus
  final FocusNode? focusNode;

  /// A value of this checkbox.
  bool? value;

  /// Requests the primary focus for this node.
  void setFocus() => focusNode!.requestFocus();

  /// Clears parent [Checkbox] and requests the primary focus for it.
  void reset() {
    value = false;
    setFocus();
  }

  @override
  void dispose() {
    focusNode!.dispose();
  }
}
