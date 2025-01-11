import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core.dart';

part 'authentication.freezed.dart';

enum AuthenticationStatus {
  unauthenticated,
  authenticated,
  failure,
  waiting,
}

/// All available authentication states.
@freezed
class AuthenticationState<T> with _$AuthenticationState<T> {
  const AuthenticationState._();

  const factory AuthenticationState.waiting() = AuthWaiting;

  const factory AuthenticationState.unauthenticated() = AuthUnauthenticated;

  const factory AuthenticationState.authenticated([T? data]) =
      AuthAuthenticated;

  const factory AuthenticationState.failure([ApplicationException? error]) =
      AuthFailure;

  bool get isWaiting => this is AuthWaiting;
  bool get isFailure => this is AuthFailure;
  bool get isAutenticated => this is AuthAuthenticated;
  bool get isUnautenticated => this is AuthUnauthenticated;
}

/// Provides interface for authentication process.
abstract class AuthenticationService<T> implements ApplicationService {
  /// Executes process of signing in.
  Future<T> signIn();

  /// Executes process of signing out.
  Future<void> signOut();
}
