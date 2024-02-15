import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'basic_types.dart';
import 'exceptions.dart';

/// Interface provides a set of methods to allow class which implement it
/// to be serializable using [json.encode] method.
abstract class Serializable<T extends Object> {
  const Serializable();

  /// Returns a [Map] which represents this object.
  T toJson();
}

/// Provides base implementation of [Serializable] interface which ignores
/// `null` values while [json.encode] method is used.
///
/// To specife properties which may contain null values the getter
/// [nullablePermittedKeys] must be overridden.
abstract class BaseSerializable extends Serializable<JsonMap> {
  const BaseSerializable();

  @override
  JsonMap toJson() => (toJsonMap()..removeWhere(removeWhere)).map(map);

  /// Returns a [Map] which represents this object.
  @protected
  JsonMap toJsonMap();

  /// The list of keys which are permitted to have null values.
  @protected
  List<String> get nullablePermittedKeys => const <String>[];

  /// Removes all entries of this map that satisfy the given [test].
  @protected
  bool removeWhere(String key, dynamic value) =>
      value == null && !nullablePermittedKeys.contains(key);

  /// Returns a new map entry.
  @protected
  MapEntry<String, dynamic> map(String key, dynamic value) {
    if (value is Enum) {
      value = mapEnum(value);
    } else if (value is bool) {
      value = mapBoolean(value);
    } else if (value is DateTime) {
      value = mapDateTime(value);
    } else if (value is Color) {
      value = mapColor(value);
    }
    return MapEntry(key, value);
  }

  /// Maps the `bool` [value] to required type bool or integer.
  ///
  /// For example, SQLite does not support booleans so the value must be
  /// converted to integer.
  ///
  /// Default returned value is `bool`.
  @protected
  dynamic mapBoolean(bool value) => value;

  /// Maps the `DateTime` [value] to integer or String.
  ///
  /// Default returned value `integer` Unix timestamp.
  @protected
  dynamic mapDateTime(DateTime value) => value.millisecondsSinceEpoch;

  /// Maps the `Color` [value] to integer or String.
  ///
  /// Default returned value `integer` number.
  @protected
  dynamic mapColor(Color value) => value.value;

  /// Maps the `Enum` [value] to integer or String.
  ///
  /// Default returned value `integer` number.
  @protected
  dynamic mapEnum(Enum value) => value.index;
}

/// Interface provides a method that it is legal for make a field-for-field
/// copy of instances of that class.
abstract class Cloneable<T> {
  /// Returns new instance of type T with optionally modified properties.
  T copyWith();
}

/// Interface provides a method which is used for release of unmanaged
/// resources and finalizing some instances.
///
/// For example this interface can be implemented by classes which use
/// [StreamController]s. The `dispose` method can be used for close sink.
abstract class Disposable {
  /// Disposes resources which were allocated.
  void dispose();
}

/// Interface provides a method that allows to implement `Builder` pattern.
/// The `Builder` pattern is a design pattern designed to provide a flexible
/// solution to various object creation problems in object-oriented programming.
abstract class Builder<T> {
  /// Builds an instance of type T.
  T build();
}

/// Mixin provides getters which defines if the mixed object is empty or not.
///
/// The method `isEmpty` must be overridden.
mixin Emptiable {
  /// Whether this [Emptiable] is empty.
  bool get isEmpty;

  /// Whether this [Emptiable] is not empty.
  bool get isNotEmpty => !isEmpty;
}

/// An interface for objects that are aware of some task execution.
///
/// This is used to make a widget aware of changes to the task's execution state.
abstract class TaskAware {
  /// Called when the current task has been completed.
  void onTaskCompleted([TaskResult? result]);

  /// Called when the current task has been failed.
  void onTaskFailed([ApplicationException? exception]) {}

  /// Called when the current task has changed `isBusy` status.
  void onTaskStatusChanged(bool isBusy) {}
}

/// An interface for objects that are result of [TaskAware] execution.
abstract class TaskResult {
  /// Defines no task result.
  static const empty = _EmptyTaskResult();
}

class _EmptyTaskResult implements TaskResult {
  const _EmptyTaskResult();
}
