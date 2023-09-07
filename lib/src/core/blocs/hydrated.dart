import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Base hydrated [Bloc] which saves its state apart for authenticated user.
abstract class BaseHydratedBloc<TEvent, TState>
    extends HydratedBloc<TEvent, TState> with StateSubscriptionMixin<TState> {
  /// Abstract constructor. This constructor provides an initial [state] and
  /// optional [authId] (usually user identifier) which is used to change a
  /// [storagePrefix].
  BaseHydratedBloc(super.state, {int? authId}) {
    authenticationId ??= authId;
  }

  /// Contains the authentication id. Usually it is idenifier of the
  /// authenticated user.
  static int? authenticationId;

  @override
  String get id => authenticationId != null ? '.$authenticationId' : super.id;

  @override
  String get storagePrefix => super.storagePrefix.toLowerCase();

  @override
  String toString() => '$runtimeType {storage: $storagePrefix}';
}

/// Base hydrated [Cubit] which saves its state apart for authenticated user.
abstract class BaseHydratedCubit<TState> extends HydratedCubit<TState>
    with StateSubscriptionMixin<TState> {
  /// Abstract constructor. This constructor provides an initial [state] and
  /// optional [authId] (usually user identifier) which is used to change a
  /// [storagePrefix].
  BaseHydratedCubit(super.state, {int? authId}) {
    authenticationId ??= authId;
  }

  /// Contains the authentication id. Usually it is idenifier of the
  /// authenticated user.
  static int? authenticationId;

  @override
  String get id => authenticationId != null ? '.$authenticationId' : super.id;

  @override
  String get storagePrefix => super.storagePrefix.toLowerCase();

  @override
  String toString() => '$runtimeType {storage: $storagePrefix}';
}

/// Mixes additional [key] string to modifyc [storagePrefix].
@optionalTypeArgs
mixin KeyedStoragePrefix<TState> on HydratedMixin<TState> {
  /// A string key that is unique across the entire app which affects
  /// the [storagePrefix]. It is used for storage uniqueness.
  String get key;

  /// Whether [key] is concatenated at the end of storage prefix. Otherwise
  /// the [key] is concatenated after app name (leading).
  ///
  /// Default is `false`.
  bool get isKeyTrailing => false;

  @override
  String get storagePrefix => (key.isNotEmpty
          ? (isKeyTrailing ? '$runtimeType.$key' : '$key.$runtimeType')
          : '$runtimeType')
      .toLowerCase();

  @override
  String toString() => '$runtimeType {storage: $storagePrefix}';
}

/// Mixin which is a helper to handle stream subscriptions.
@optionalTypeArgs
mixin StateSubscriptionMixin<TState> on BlocBase<TState> {
  final _subscriptions = <StreamSubscription<TState>>[];

  void addSubscription(StreamSubscription<TState> subscription) {
    _subscriptions.add(subscription);
  }

  @override
  Future<void> close() async {
    for (var subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
