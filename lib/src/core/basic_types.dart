import 'package:meta/meta.dart';

/// An alias for `[Map]<String,dynamic>`
typedef Json = Map<String, dynamic>;

/// An alias for file `int` size (in bytes).
typedef FileSize = int;

/// Signature for a function which providdes a value of type T.
typedef ValueBuilder<T> = T Function();

/// Signature for a function which creates a value of type T
/// using `value` of type V.
typedef ConvertibleBuilder<T, V> = T Function(V value);

/// Provides a helper instances for using with [StreamBuilder]'s.
@sealed
@immutable
class ResourceState {
  const ResourceState._(
    this.state, {
    this.data,
    this.message,
  });

  /// The resource is idle.
  static const idle = ResourceState._(_ResourceStates.idle);

  /// The resource is waiting.
  static const waiting = ResourceState._(_ResourceStates.waiting);

  /// The resource is ready with the optional `data`.
  const ResourceState.ready({Object? data})
      : this._(_ResourceStates.ready, data: data);

  /// The resource is failed with the `message`.
  const ResourceState.error(String message)
      : this._(_ResourceStates.error, message: message);

  /// Contains resource state value.
  final _ResourceStates state;

  /// Contains data when resource is ready.
  final Object? data;

  /// Contains error message when resource is failed.
  final String? message;

  /// Whether data is available. Applicable for `ready` state.
  bool get hasData => data != null;

  bool get isIdle => state == _ResourceStates.idle;
  bool get isWaiting => state == _ResourceStates.waiting;
  bool get isReady => state == _ResourceStates.ready;
  bool get isError => state == _ResourceStates.error;
}

/// Resource state values.
enum _ResourceStates {
  idle,
  waiting,
  ready,
  error,
}
