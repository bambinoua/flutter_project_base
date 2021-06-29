import 'dart:async';

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

/// Interface provides a method which is used for realese of unmanaged
/// resources and finalizing some instances.
///
/// For example this interface can be implemented by classes which use
/// [StreamController]s. The `dispose` method can be used for close sink.
abstract class Disposable {
  void dispose();
}

/// Provides base interface for classes which may be used as `enum`s.
///
/// For example,
/// ```dart
/// class Gender implements Enum {
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
abstract class Enum {
  /// Returns index of enumeration.
  int get index;
}

/// This interface is designed to provide a common protocol for objects
/// that wish to execute code while they are active.
abstract class Runnable<T> {
  /// Runs statements.
  void run();
}

/// Interface provides a method to initialize implementing instance.
abstract class Initiable {
  FutureOr<void> init();
}

/// JSON implementation of [Serializable] interface.
abstract class JsonSerializable extends Serializable {
  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.fromEntries(
        asMap().entries.where((entry) => entry.value != null).map((entry) {
      var effectiveValue;
      if (entry.value is DateTime) {
        effectiveValue = convertTimeToUtc
            ? (entry.value as DateTime).toUtc().toIso8601String()
            : (entry.value as DateTime).toIso8601String();
      } else if (entry.value is Enum) {
        effectiveValue = (entry.value as Enum).index;
      } else {
        /// This is a trick to serialize `enum`. If value implements
        /// `index` property than it is potentially `enum`eration and
        /// there will not be exception. Otherwise the original value is taken.
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
  bool get convertTimeToUtc => false;
}
