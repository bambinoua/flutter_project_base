// ignore_for_file: comment_references

import 'package:flutter/widgets.dart';

import '../core/contracts.dart';

/// A helper class which can be used for management of [FormField] widgets.
///
/// Combines `focusNode` and text editing `controller` in single object.
class FormFieldHelper<T> implements Disposable {
  FormFieldHelper({
    FocusNode? focusNode,
    TextEditingController? controller,
    String? initialText,
  })  : assert(controller == null || initialText == null),
        focusNode = focusNode ?? FocusNode(),
        controller = controller ?? TextEditingController(text: initialText);

  /// An object that can be used by a [TextField] widget to obtain the keyboard focus
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
