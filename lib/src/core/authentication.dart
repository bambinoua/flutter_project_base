import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core.dart';

part 'authentication.freezed.dart';

/// All available authentication statuses.
///
/// They can be use for example in Blocs.
enum AuthStatus {
  signedOut,
  signedIn,
  failure,
  waiting,
}

/// All available authentication states.
@freezed
final class AuthState<T> with _$AuthState<T> {
  /// The `waiting` state.
  const factory AuthState.waiting() = AuthWaiting;

  /// The `signed out` state.
  const factory AuthState.signedOut() = AuthSignedOut;

  /// The `signed in` state.
  const factory AuthState.signedIn([T? data]) = AuthSignedIn;

  /// The `failure` state.
  const factory AuthState.failure([Exception? error]) = AuthFailure;
}

/// Provides interface for authentication process.
abstract class AuthenticationService<T> implements ApplicationService {
  /// Executes process of signing in.
  Future<T> signIn();

  /// Executes process of signing out.
  Future<void> signOut();
}
