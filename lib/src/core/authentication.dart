import 'package:flutter_project_base/src/core/basic_types.dart';

import 'domain_driven_design.dart';
import 'exceptions.dart';

enum AuthenticationStatus {
  unauthenticated,
  authenticated,
  failure,
  waiting,
}

/// All available authentication states.
class AuthenticationState<T extends Object>
    extends Either<T, ApplicationException> {
  const AuthenticationState._(this.status,
      {T? data, ApplicationException? error})
      : super(data: data, error: error);

  final AuthenticationStatus status;

  static const waiting = AuthenticationState._(AuthenticationStatus.waiting);
  static const unauthenticated =
      AuthenticationState._(AuthenticationStatus.unauthenticated);

  AuthenticationState.authenticated([T? data])
      : this._(AuthenticationStatus.authenticated, data: data);
  AuthenticationState.failure([ApplicationException? error])
      : this._(AuthenticationStatus.failure, error: error);

  bool get isAutenticated => status == AuthenticationStatus.authenticated;
  bool get isUnautenticated => status == AuthenticationStatus.unauthenticated;
  bool get isFailure => status == AuthenticationStatus.failure;
  bool get isWaiting => status == AuthenticationStatus.waiting;
}

/// Provides interface for authentication process.
abstract class AuthenticationService<T> implements ApplicationService {
  /// Executes process of signing in.
  Future<T> signIn();

  /// Executes process of signing out.
  Future<void> signOut();
}
