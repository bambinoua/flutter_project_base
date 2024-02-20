import 'package:equatable/equatable.dart';

import '../contracts.dart';

/// BLoC statuses.
enum Status {
  initial,
  waiting,
  success,
  failure,
}

/// Provides a base event for BLoC pattern.
///
/// Usually may be use with [flutter_bloc] package. It is required to override
/// `props` property in ancestors.
abstract class BlocEvent extends Equatable {
  const BlocEvent();

  @override
  List<Object?> get props => const [];
}

/// Provides a base state for BLoC pattern.
///
/// Usually may be use with [flutter_bloc] package.
abstract class BlocState<T extends BlocState<T, TData, TError>, TData, TError>
    extends Equatable implements Cloneable<T> {
  const BlocState({
    this.status = Status.initial,
    this.data,
    this.error,
  }) : assert(data == null || error == null);

  /// Status of the this state.
  final Status status;

  /// Payload of this state.
  final TData? data;

  /// Error of this state.
  final TError? error;

  /// Whether state contains a payload.
  bool get hasData => data != null;

  /// Whether state is error.
  bool get hasError => error != null;

  bool get isInitial => status == Status.initial;
  bool get isWaiting => status == Status.waiting;
  bool get isSuccess => status == Status.success;
  bool get isFailure => status == Status.failure;

  @override
  List<Object?> get props => [status, data, error];

  @override
  T copyWith({Status? status, TData? data, TError? error});
}
