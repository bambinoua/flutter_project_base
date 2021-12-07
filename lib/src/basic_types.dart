import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// An alias for `[Map]<String,dynamic>`
typedef Json = Map<String, dynamic>;

/// An alias for file `int` size (in bytes).
typedef FileSize = int;

/// Signature for a function which providdes an instance of type T.
typedef InstanceProvider<T> = T Function();

/// Signature for a function which creates an instance of type T
/// using `value` of type V.
typedef InstanceProviderV<T, V> = T Function(V value);

/// Defines a key/value pair that can be set or retrieved.
@immutable
class KeyValuePair<K, V> extends Equatable {
  /// Creates an instance of a key/value pair.
  const KeyValuePair(this.key, this.value);

  /// An unique identifier for a key.
  final K key;

  /// An data of any type for this key.
  final V value;

  @override
  List<Object?> get props => [key, value];
}

/// Provides a helper instances for using with [StreamBuilder]'s.
@sealed
@immutable
class ResourceState<T> {
  const ResourceState._(
    this.state, {
    this.data,
    this.message,
  });

  /// The resource is idle.
  const ResourceState.idle() : this._(_ResourceStates.idle);

  /// The resource is waiting.
  const ResourceState.waiting() : this._(_ResourceStates.waiting);

  /// The resource is ready with the optional `data`.
  const ResourceState.ready({T? data})
      : this._(_ResourceStates.ready, data: data);

  /// The resource is failed with the `message`.
  const ResourceState.error(String message)
      : this._(_ResourceStates.failed, message: message);

  /// Contains resource state value.
  final _ResourceStates state;

  /// Contains data when resource is ready.
  final T? data;

  /// Contains error message when resource is failed.
  final String? message;

  bool get hasData => data != null;
  bool get hasError => message != null && message!.isNotEmpty;
  bool get isIdle => state == _ResourceStates.idle;
  bool get isWaiting => state == _ResourceStates.waiting;
  bool get isReady => state == _ResourceStates.ready;
  bool get isFailed => state == _ResourceStates.failed;
}

/// Resource state values.
enum _ResourceStates {
  idle,
  waiting,
  ready,
  failed,
}
