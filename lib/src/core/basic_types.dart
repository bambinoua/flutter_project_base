import 'package:meta/meta.dart';

import 'exceptions.dart';

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
class ResourceState {
  const ResourceState._(
    this._value, {
    this.data,
    this.emergency,
  });

  /// The resource is idle.
  static const idle = ResourceState._(ResourceStates.idle);

  /// The resource is waiting.
  static const waiting = ResourceState._(ResourceStates.waiting);

  /// The resource is ready with the optional `data`.
  const ResourceState.ready({Object? data})
      : this._(ResourceStates.ready, data: data);

  /// The resource is failed with the `emergency`.
  const ResourceState.failed(Emergency emergency)
      : this._(ResourceStates.failed, emergency: emergency);

  /// Contains resource state value.
  final ResourceStates _value;

  /// Contains data when the resource is ready.
  final Object? data;

  /// Contains an exception when the resource is failed.
  final Emergency? emergency;

  /// Whether data is available. Applicable for `ready` state.
  bool get hasData => data != null;

  /// Whether data is available. Applicable for `ready` state.
  bool get hasError => emergency != null;

  bool get isIdle => _value == ResourceStates.idle;
  bool get isWaiting => _value == ResourceStates.waiting;
  bool get isReady => _value == ResourceStates.ready;
  bool get isFailed => _value == ResourceStates.failed;
}

/// Resource state values.
enum ResourceStates {
  idle,
  waiting,
  ready,
  failed,
}
