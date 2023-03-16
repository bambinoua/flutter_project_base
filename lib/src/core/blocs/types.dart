import 'package:equatable/equatable.dart';

import '../contracts.dart';

/// BLoC statuses.
enum BlocStatus {
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
abstract class BlocState<TState, TData, TError> extends Equatable
    implements Cloneable<TState> {
  const BlocState({required this.status, this.data, this.error});

  /// Initial state.
  const BlocState.initial() : this(status: BlocStatus.initial);

  /// This state is active when BLoC is busy with some async operation.
  const BlocState.waiting() : this(status: BlocStatus.waiting);

  /// Successful state.
  ///
  /// May contains `data`.
  const BlocState.success([TData? data])
      : this(status: BlocStatus.success, data: data);

  /// Failure state.
  ///
  /// May contains `error`.
  const BlocState.failure([TError? error])
      : this(status: BlocStatus.failure, error: error);

  final BlocStatus status;
  final TData? data;
  final TError? error;

  bool get isInitial => status == BlocStatus.initial;
  bool get isWaiting => status == BlocStatus.waiting;
  bool get isSuccess => status == BlocStatus.success;
  bool get isFailure => status == BlocStatus.failure;

  @override
  List<Object?> get props => [status, data, error];
}
