import 'package:equatable/equatable.dart';

import '../exceptions.dart';

/// BLoC state values.
enum BlocStatus {
  idle,
  waiting,
  success,
  failure,
}

/// Provides a base event for BLoC pattern.
///
/// Usually may be use with [flutter_bloc] package.
abstract class BlocEvent extends Equatable {
  const BlocEvent();
}

/// Provides a base state for BLoC patter.
///
/// Usually may be use with [flutter_bloc] package.
class BlocState<T> {
  const BlocState(
    this.status, {
    this.data,
    this.error,
  });

  /// Current status.
  final BlocStatus status;

  /// Contains data when this state is successful.
  final T? data;

  /// Contains an exception when this state is failed.
  final ApplicationException? error;

  /// Whether data is available. Applicable for `ready` state.
  bool get hasData => data != null;

  /// Whether data is available. Applicable for `ready` state.
  bool get hasError => error != null;

  bool get isIdle => status == BlocStatus.idle;
  bool get isWaiting => status == BlocStatus.waiting;
  bool get isSuccess => status == BlocStatus.success;
  bool get isFailure => status == BlocStatus.failure;
}
