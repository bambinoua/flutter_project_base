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
/// Usually may be use with [flutter_bloc] package.
abstract class BlocEvent extends Equatable {
  const BlocEvent();

  @override
  List<Object?> get props => const [];
}

/// Provides a base state for BLoC pattern.
///
/// Usually may be use with [flutter_bloc] package.
abstract class BlocState<T, D, E> extends Equatable implements Cloneable<T> {
  const BlocState({required this.status, this.data, this.error});

  const BlocState.initial() : this(status: BlocStatus.initial);
  const BlocState.waiting() : this(status: BlocStatus.waiting);
  const BlocState.success([D? data])
      : this(status: BlocStatus.success, data: data);
  const BlocState.failure([E? error])
      : this(status: BlocStatus.failure, error: error);

  final BlocStatus status;
  final D? data;
  final E? error;

  bool get isInitial => status == BlocStatus.initial;
  bool get isWaiting => status == BlocStatus.waiting;
  bool get isSuccess => status == BlocStatus.success;
  bool get isFailure => status == BlocStatus.failure;

  @override
  List<Object?> get props => [status, data, error];
}
