import 'package:equatable/equatable.dart';
import 'package:flutter_project_base/src/core/basic_types.dart';

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
class BlocState<T extends Object> extends Either<T, ApplicationException> {
  const BlocState(
    this.status, {
    T? data,
    ApplicationException? error,
  }) : super(data: data, error: error);

  static const idle = BlocState(BlocStatus.idle);
  static const waiting = BlocState(BlocStatus.waiting);

  BlocState.success([T? data]) : this(BlocStatus.success, data: data);
  BlocState.failure([ApplicationException? error])
      : this(BlocStatus.failure, error: error);

  final BlocStatus status;

  bool get isIdle => status == BlocStatus.idle;
  bool get isWaiting => status == BlocStatus.waiting;
  bool get isSuccess => status == BlocStatus.success;
  bool get isFailure => status == BlocStatus.failure;
}
