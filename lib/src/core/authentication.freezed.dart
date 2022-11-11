// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthenticationState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() unauthenticated,
    required TResult Function(T? data) authenticated,
    required TResult Function(ApplicationException? error) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? unauthenticated,
    TResult? Function(T? data)? authenticated,
    TResult? Function(ApplicationException? error)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? unauthenticated,
    TResult Function(T? data)? authenticated,
    TResult Function(ApplicationException? error)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthUnauthenticated<T> value) unauthenticated,
    required TResult Function(AuthAuthenticated<T> value) authenticated,
    required TResult Function(AuthFailure<T> value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult? Function(AuthAuthenticated<T> value)? authenticated,
    TResult? Function(AuthFailure<T> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult Function(AuthAuthenticated<T> value)? authenticated,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<T, $Res> {
  factory $AuthenticationStateCopyWith(AuthenticationState<T> value,
          $Res Function(AuthenticationState<T>) then) =
      _$AuthenticationStateCopyWithImpl<T, $Res, AuthenticationState<T>>;
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<T, $Res,
        $Val extends AuthenticationState<T>>
    implements $AuthenticationStateCopyWith<T, $Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthWaitingCopyWith<T, $Res> {
  factory _$$AuthWaitingCopyWith(
          _$AuthWaiting<T> value, $Res Function(_$AuthWaiting<T>) then) =
      __$$AuthWaitingCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$AuthWaitingCopyWithImpl<T, $Res>
    extends _$AuthenticationStateCopyWithImpl<T, $Res, _$AuthWaiting<T>>
    implements _$$AuthWaitingCopyWith<T, $Res> {
  __$$AuthWaitingCopyWithImpl(
      _$AuthWaiting<T> _value, $Res Function(_$AuthWaiting<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthWaiting<T> extends AuthWaiting<T> {
  const _$AuthWaiting() : super._();

  @override
  String toString() {
    return 'AuthenticationState<$T>.waiting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthWaiting<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() unauthenticated,
    required TResult Function(T? data) authenticated,
    required TResult Function(ApplicationException? error) failure,
  }) {
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? unauthenticated,
    TResult? Function(T? data)? authenticated,
    TResult? Function(ApplicationException? error)? failure,
  }) {
    return waiting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? unauthenticated,
    TResult Function(T? data)? authenticated,
    TResult Function(ApplicationException? error)? failure,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthUnauthenticated<T> value) unauthenticated,
    required TResult Function(AuthAuthenticated<T> value) authenticated,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult? Function(AuthAuthenticated<T> value)? authenticated,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return waiting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult Function(AuthAuthenticated<T> value)? authenticated,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting(this);
    }
    return orElse();
  }
}

abstract class AuthWaiting<T> extends AuthenticationState<T> {
  const factory AuthWaiting() = _$AuthWaiting<T>;
  const AuthWaiting._() : super._();
}

/// @nodoc
abstract class _$$AuthUnauthenticatedCopyWith<T, $Res> {
  factory _$$AuthUnauthenticatedCopyWith(_$AuthUnauthenticated<T> value,
          $Res Function(_$AuthUnauthenticated<T>) then) =
      __$$AuthUnauthenticatedCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$AuthUnauthenticatedCopyWithImpl<T, $Res>
    extends _$AuthenticationStateCopyWithImpl<T, $Res, _$AuthUnauthenticated<T>>
    implements _$$AuthUnauthenticatedCopyWith<T, $Res> {
  __$$AuthUnauthenticatedCopyWithImpl(_$AuthUnauthenticated<T> _value,
      $Res Function(_$AuthUnauthenticated<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthUnauthenticated<T> extends AuthUnauthenticated<T> {
  const _$AuthUnauthenticated() : super._();

  @override
  String toString() {
    return 'AuthenticationState<$T>.unauthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthUnauthenticated<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() unauthenticated,
    required TResult Function(T? data) authenticated,
    required TResult Function(ApplicationException? error) failure,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? unauthenticated,
    TResult? Function(T? data)? authenticated,
    TResult? Function(ApplicationException? error)? failure,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? unauthenticated,
    TResult Function(T? data)? authenticated,
    TResult Function(ApplicationException? error)? failure,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthUnauthenticated<T> value) unauthenticated,
    required TResult Function(AuthAuthenticated<T> value) authenticated,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult? Function(AuthAuthenticated<T> value)? authenticated,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult Function(AuthAuthenticated<T> value)? authenticated,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated<T> extends AuthenticationState<T> {
  const factory AuthUnauthenticated() = _$AuthUnauthenticated<T>;
  const AuthUnauthenticated._() : super._();
}

/// @nodoc
abstract class _$$AuthAuthenticatedCopyWith<T, $Res> {
  factory _$$AuthAuthenticatedCopyWith(_$AuthAuthenticated<T> value,
          $Res Function(_$AuthAuthenticated<T>) then) =
      __$$AuthAuthenticatedCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? data});
}

/// @nodoc
class __$$AuthAuthenticatedCopyWithImpl<T, $Res>
    extends _$AuthenticationStateCopyWithImpl<T, $Res, _$AuthAuthenticated<T>>
    implements _$$AuthAuthenticatedCopyWith<T, $Res> {
  __$$AuthAuthenticatedCopyWithImpl(_$AuthAuthenticated<T> _value,
      $Res Function(_$AuthAuthenticated<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$AuthAuthenticated<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$AuthAuthenticated<T> extends AuthAuthenticated<T> {
  const _$AuthAuthenticated([this.data]) : super._();

  @override
  final T? data;

  @override
  String toString() {
    return 'AuthenticationState<$T>.authenticated(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticated<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedCopyWith<T, _$AuthAuthenticated<T>> get copyWith =>
      __$$AuthAuthenticatedCopyWithImpl<T, _$AuthAuthenticated<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() unauthenticated,
    required TResult Function(T? data) authenticated,
    required TResult Function(ApplicationException? error) failure,
  }) {
    return authenticated(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? unauthenticated,
    TResult? Function(T? data)? authenticated,
    TResult? Function(ApplicationException? error)? failure,
  }) {
    return authenticated?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? unauthenticated,
    TResult Function(T? data)? authenticated,
    TResult Function(ApplicationException? error)? failure,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthUnauthenticated<T> value) unauthenticated,
    required TResult Function(AuthAuthenticated<T> value) authenticated,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult? Function(AuthAuthenticated<T> value)? authenticated,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult Function(AuthAuthenticated<T> value)? authenticated,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated<T> extends AuthenticationState<T> {
  const factory AuthAuthenticated([final T? data]) = _$AuthAuthenticated<T>;
  const AuthAuthenticated._() : super._();

  T? get data;
  @JsonKey(ignore: true)
  _$$AuthAuthenticatedCopyWith<T, _$AuthAuthenticated<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureCopyWith<T, $Res> {
  factory _$$AuthFailureCopyWith(
          _$AuthFailure<T> value, $Res Function(_$AuthFailure<T>) then) =
      __$$AuthFailureCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApplicationException? error});
}

/// @nodoc
class __$$AuthFailureCopyWithImpl<T, $Res>
    extends _$AuthenticationStateCopyWithImpl<T, $Res, _$AuthFailure<T>>
    implements _$$AuthFailureCopyWith<T, $Res> {
  __$$AuthFailureCopyWithImpl(
      _$AuthFailure<T> _value, $Res Function(_$AuthFailure<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_$AuthFailure<T>(
      freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApplicationException?,
    ));
  }
}

/// @nodoc

class _$AuthFailure<T> extends AuthFailure<T> {
  const _$AuthFailure([this.error]) : super._();

  @override
  final ApplicationException? error;

  @override
  String toString() {
    return 'AuthenticationState<$T>.failure(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailure<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureCopyWith<T, _$AuthFailure<T>> get copyWith =>
      __$$AuthFailureCopyWithImpl<T, _$AuthFailure<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() unauthenticated,
    required TResult Function(T? data) authenticated,
    required TResult Function(ApplicationException? error) failure,
  }) {
    return failure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? unauthenticated,
    TResult? Function(T? data)? authenticated,
    TResult? Function(ApplicationException? error)? failure,
  }) {
    return failure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? unauthenticated,
    TResult Function(T? data)? authenticated,
    TResult Function(ApplicationException? error)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthUnauthenticated<T> value) unauthenticated,
    required TResult Function(AuthAuthenticated<T> value) authenticated,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult? Function(AuthAuthenticated<T> value)? authenticated,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthUnauthenticated<T> value)? unauthenticated,
    TResult Function(AuthAuthenticated<T> value)? authenticated,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class AuthFailure<T> extends AuthenticationState<T> {
  const factory AuthFailure([final ApplicationException? error]) =
      _$AuthFailure<T>;
  const AuthFailure._() : super._();

  ApplicationException? get error;
  @JsonKey(ignore: true)
  _$$AuthFailureCopyWith<T, _$AuthFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
