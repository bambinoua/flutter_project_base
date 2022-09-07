import 'dart:async';

import 'basic_types.dart';
import 'exceptions.dart';

/// Interface provides a set of methods to allow class which implement it
/// to be serializable using [json.encode] method.
abstract class Serializable {
  const Serializable();

  /// Returns a [Map] which represents this object.
  Json toJson();
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
  void onTaskFailed([Emergency? exception]) {}

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
