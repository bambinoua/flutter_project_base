import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core.dart';

part 'authentication.freezed.dart';

enum AuthStatus {
  signedOut,
  signedIn,
  failure,
  waiting,
}

/// All available authentication states.
@freezed
class AuthState<T> with _$AuthState<T> {
  /// The `waiting` state.
  const factory AuthState.waiting() = AuthWaiting;

  /// The `signed out` state.
  const factory AuthState.signedOut() = AuthSignedOut;

  /// The `signed in` state.
  const factory AuthState.signedIn([T? data]) = AuthSignedIn;

  /// The `failure` state.
  const factory AuthState.failure([ApplicationException? error]) = AuthFailure;

  /// Indicates whether state is `waiting`.
  bool get isWaiting => this is AuthWaiting;

  /// Indicates whether state is `failure`.
  bool get isFailure => this is AuthFailure;

  /// Indicates whether state is `signed in`.
  bool get isSignedIn => this is AuthSignedIn;

  /// Indicates whether state is `signed out`.
  bool get isSignedOut => this is AuthSignedOut;
}

/// Provides interface for authentication process.
abstract class AuthenticationService<T> implements ApplicationService {
  /// Executes process of signing in.
  Future<T> signIn();

  /// Executes process of signing out.
  Future<void> signOut();
}
