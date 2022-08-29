enum AuthenticationStatus { unauthenticated, authenticated, failure }

/// All available authentication states.
class AuthenticationState {
  const AuthenticationState._(this.status, [this.data]);

  /// Status
  final AuthenticationStatus status;

  /// Optional state payload.
  final Object? data;

  bool get hasData => data != null;

  static const unauthenticated =
      AuthenticationState._(AuthenticationStatus.unauthenticated);

  static AuthenticationState authenticated(Object data) =>
      AuthenticationState._(AuthenticationStatus.authenticated, data);

  static AuthenticationState failure(Object error) =>
      AuthenticationState._(AuthenticationStatus.failure, error);
}

/// Provides interface for authentication process.
abstract class AuthenticationController<T> {
  /// Executes process of signing in.
  Future<T> signIn();

  /// Executes process of signing out.
  Future<void> signOut();
}
