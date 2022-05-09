import 'dart:async';

import 'package:flutter/painting.dart';

/// Interface provides a set of methods to allow class which implement it
/// to be serializable using [json.encode] method.
abstract class Serializable {
  /// Returns a [Map] which represents this object.
  Map<String, dynamic> toJson();
}

/// Interface provides a method that it is legal for make a field-for-field
/// copy of instances of that class.
abstract class Cloneable<T> {
  T copyWith();
}

/// Interface provides a method which is used for release of unmanaged
/// resources and finalizing some instances.
///
/// For example this interface can be implemented by classes which use
/// [StreamController]s. The `dispose` method can be used for close sink.
abstract class Disposable {
  void dispose();
}

/// Interface provides a method that allows to implement `Builder` pattern.
/// The `Builder` pattern is a design pattern designed to provide a flexible
/// solution to various object creation problems in object-oriented programming.
abstract class Builder<T> {
  T build();
}

/// Mixin provides getters which defines if the mixed object is empty or not.
mixin Emptiable {
  bool get isEmpty;
  bool get isNotEmpty => !isEmpty;
}

/// Provides base interface for classes which may be used as `enum`s.
///
/// For example,
/// ```dart
/// class Gender implements CustomEnum {
///   const Gender._(this._index);
///
///   final int _index;
///
///   static const none = Gender._(0);
///   static const male = Gender._(1);
///   static const female = Gender._(2);
///
///   static const List<Gender> values = [
///     none,
///     male,
///     female,
///   ];
///
///   @override
///   int get index => _index;
/// }
/// ```
abstract class CustomEnum {
  /// A numeric identifier for the enumerated value.
  ///
  /// The values of a single enumeration are numbered
  /// consecutively from zero to one less than the
  /// number of values.
  /// This is also the index of the value in the
  /// enumerated type's static `values` list.
  int get index;

  /// The value's "name".
  ///
  /// The name of a value is a string containing the
  /// source identifier used to declare the value.
  ///
  String? get name => null;

  @override
  String toString() => '$runtimeType {$index: $name}';
}

/// JSON implementation of [Serializable] interface.
///
/// This class use `EquatableMixin` instead of extending `Equatable` because
/// derived classed may be not `@immutable`.
mixin SerializableMixin implements Serializable {
  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.fromEntries(asMap()
        .entries
        .where((entry) => entry.value != null)
        .where((entry) => !removedKeys.contains(entry.key))
        .map((entry) {
      var effectiveValue;
      if (entry.value is DateTime) {
        effectiveValue = useUtc
            ? (entry.value as DateTime).toUtc().toIso8601String()
            : (entry.value as DateTime).toIso8601String();
      } else if (entry.value is Color) {
        effectiveValue = (entry.value as Color).value;
      } else if (entry.value is CustomEnum) {
        effectiveValue = (entry.value as CustomEnum).index;
      } else if (entry.value is Enum) {
        effectiveValue = (entry.value as Enum).index;
      } else if (entry.value is Serializable) {
        effectiveValue = (entry.value as Serializable).toJson();
      } else {
        //! Deprecated since @dart 2.14
        // This is a trick to serialize `enum`. If value implements
        // `index` property than it is potentially enumeration and
        // there will not be exception. Otherwise the original value is taken.
        try {
          effectiveValue = entry.value.index;
        } catch (_) {
          effectiveValue = entry.value;
        }
      }
      return MapEntry(entry.key, effectiveValue);
    }));
  }

  /// Returns a [Map] which is used as data for method `toJson` of
  /// [Serializable] interface.
  Map<String, dynamic> asMap();

  /// Indicates whether [DateTime] values must be converted to UTC.
  ///
  /// Default value is `false`.
  bool get useUtc => false;

  /// The list of property names which will be removed while JSON encoding
  /// this [Serializable].
  ///
  /// By default no instance properties removed.
  List<String> get removedKeys => <String>[];

  @override
  String toString() {
    final propString = asMap()
        .entries
        .where((prop) => prop.value != null)
        .map((prop) => '${prop.key}: ${prop.value}')
        .join(', ');
    return '$runtimeType {$propString}';
  }
}

/// An interface for objects that are aware of some task execution.
///
/// This is used to make a widget aware of changes to the task's execution state.
abstract class TaskAware {
  /// Called when the current task has been completed.
  void onTaskCompleted([TaskResult? result]);

  /// Called when the current task has been failed.
  void onTaskFailed([Exception? exception]) {}

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
