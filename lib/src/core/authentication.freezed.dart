// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() signedOut,
    required TResult Function(T? data) signedIn,
    required TResult Function(Exception? error) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? signedOut,
    TResult? Function(T? data)? signedIn,
    TResult? Function(Exception? error)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? signedOut,
    TResult Function(T? data)? signedIn,
    TResult Function(Exception? error)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthSignedOut<T> value) signedOut,
    required TResult Function(AuthSignedIn<T> value) signedIn,
    required TResult Function(AuthFailure<T> value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthSignedOut<T> value)? signedOut,
    TResult? Function(AuthSignedIn<T> value)? signedIn,
    TResult? Function(AuthFailure<T> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthSignedOut<T> value)? signedOut,
    TResult Function(AuthSignedIn<T> value)? signedIn,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<T, $Res> {
  factory $AuthStateCopyWith(
          AuthState<T> value, $Res Function(AuthState<T>) then) =
      _$AuthStateCopyWithImpl<T, $Res, AuthState<T>>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<T, $Res, $Val extends AuthState<T>>
    implements $AuthStateCopyWith<T, $Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthWaitingImplCopyWith<T, $Res> {
  factory _$$AuthWaitingImplCopyWith(_$AuthWaitingImpl<T> value,
          $Res Function(_$AuthWaitingImpl<T>) then) =
      __$$AuthWaitingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$AuthWaitingImplCopyWithImpl<T, $Res>
    extends _$AuthStateCopyWithImpl<T, $Res, _$AuthWaitingImpl<T>>
    implements _$$AuthWaitingImplCopyWith<T, $Res> {
  __$$AuthWaitingImplCopyWithImpl(
      _$AuthWaitingImpl<T> _value, $Res Function(_$AuthWaitingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthWaitingImpl<T> implements AuthWaiting<T> {
  const _$AuthWaitingImpl();

  @override
  String toString() {
    return 'AuthState<$T>.waiting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthWaitingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() signedOut,
    required TResult Function(T? data) signedIn,
    required TResult Function(Exception? error) failure,
  }) {
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? signedOut,
    TResult? Function(T? data)? signedIn,
    TResult? Function(Exception? error)? failure,
  }) {
    return waiting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? signedOut,
    TResult Function(T? data)? signedIn,
    TResult Function(Exception? error)? failure,
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
    required TResult Function(AuthSignedOut<T> value) signedOut,
    required TResult Function(AuthSignedIn<T> value) signedIn,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthSignedOut<T> value)? signedOut,
    TResult? Function(AuthSignedIn<T> value)? signedIn,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return waiting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthSignedOut<T> value)? signedOut,
    TResult Function(AuthSignedIn<T> value)? signedIn,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting(this);
    }
    return orElse();
  }
}

abstract class AuthWaiting<T> implements AuthState<T> {
  const factory AuthWaiting() = _$AuthWaitingImpl<T>;
}

/// @nodoc
abstract class _$$AuthSignedOutImplCopyWith<T, $Res> {
  factory _$$AuthSignedOutImplCopyWith(_$AuthSignedOutImpl<T> value,
          $Res Function(_$AuthSignedOutImpl<T>) then) =
      __$$AuthSignedOutImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$AuthSignedOutImplCopyWithImpl<T, $Res>
    extends _$AuthStateCopyWithImpl<T, $Res, _$AuthSignedOutImpl<T>>
    implements _$$AuthSignedOutImplCopyWith<T, $Res> {
  __$$AuthSignedOutImplCopyWithImpl(_$AuthSignedOutImpl<T> _value,
      $Res Function(_$AuthSignedOutImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthSignedOutImpl<T> implements AuthSignedOut<T> {
  const _$AuthSignedOutImpl();

  @override
  String toString() {
    return 'AuthState<$T>.signedOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthSignedOutImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() signedOut,
    required TResult Function(T? data) signedIn,
    required TResult Function(Exception? error) failure,
  }) {
    return signedOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? signedOut,
    TResult? Function(T? data)? signedIn,
    TResult? Function(Exception? error)? failure,
  }) {
    return signedOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? signedOut,
    TResult Function(T? data)? signedIn,
    TResult Function(Exception? error)? failure,
    required TResult orElse(),
  }) {
    if (signedOut != null) {
      return signedOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthSignedOut<T> value) signedOut,
    required TResult Function(AuthSignedIn<T> value) signedIn,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return signedOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthSignedOut<T> value)? signedOut,
    TResult? Function(AuthSignedIn<T> value)? signedIn,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return signedOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthSignedOut<T> value)? signedOut,
    TResult Function(AuthSignedIn<T> value)? signedIn,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (signedOut != null) {
      return signedOut(this);
    }
    return orElse();
  }
}

abstract class AuthSignedOut<T> implements AuthState<T> {
  const factory AuthSignedOut() = _$AuthSignedOutImpl<T>;
}

/// @nodoc
abstract class _$$AuthSignedInImplCopyWith<T, $Res> {
  factory _$$AuthSignedInImplCopyWith(_$AuthSignedInImpl<T> value,
          $Res Function(_$AuthSignedInImpl<T>) then) =
      __$$AuthSignedInImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T? data});
}

/// @nodoc
class __$$AuthSignedInImplCopyWithImpl<T, $Res>
    extends _$AuthStateCopyWithImpl<T, $Res, _$AuthSignedInImpl<T>>
    implements _$$AuthSignedInImplCopyWith<T, $Res> {
  __$$AuthSignedInImplCopyWithImpl(
      _$AuthSignedInImpl<T> _value, $Res Function(_$AuthSignedInImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$AuthSignedInImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$AuthSignedInImpl<T> implements AuthSignedIn<T> {
  const _$AuthSignedInImpl([this.data]);

  @override
  final T? data;

  @override
  String toString() {
    return 'AuthState<$T>.signedIn(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSignedInImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSignedInImplCopyWith<T, _$AuthSignedInImpl<T>> get copyWith =>
      __$$AuthSignedInImplCopyWithImpl<T, _$AuthSignedInImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() signedOut,
    required TResult Function(T? data) signedIn,
    required TResult Function(Exception? error) failure,
  }) {
    return signedIn(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? signedOut,
    TResult? Function(T? data)? signedIn,
    TResult? Function(Exception? error)? failure,
  }) {
    return signedIn?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? signedOut,
    TResult Function(T? data)? signedIn,
    TResult Function(Exception? error)? failure,
    required TResult orElse(),
  }) {
    if (signedIn != null) {
      return signedIn(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthWaiting<T> value) waiting,
    required TResult Function(AuthSignedOut<T> value) signedOut,
    required TResult Function(AuthSignedIn<T> value) signedIn,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return signedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthSignedOut<T> value)? signedOut,
    TResult? Function(AuthSignedIn<T> value)? signedIn,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return signedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthSignedOut<T> value)? signedOut,
    TResult Function(AuthSignedIn<T> value)? signedIn,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (signedIn != null) {
      return signedIn(this);
    }
    return orElse();
  }
}

abstract class AuthSignedIn<T> implements AuthState<T> {
  const factory AuthSignedIn([final T? data]) = _$AuthSignedInImpl<T>;

  T? get data;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSignedInImplCopyWith<T, _$AuthSignedInImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<T, $Res> {
  factory _$$AuthFailureImplCopyWith(_$AuthFailureImpl<T> value,
          $Res Function(_$AuthFailureImpl<T>) then) =
      __$$AuthFailureImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Exception? error});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<T, $Res>
    extends _$AuthStateCopyWithImpl<T, $Res, _$AuthFailureImpl<T>>
    implements _$$AuthFailureImplCopyWith<T, $Res> {
  __$$AuthFailureImplCopyWithImpl(
      _$AuthFailureImpl<T> _value, $Res Function(_$AuthFailureImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_$AuthFailureImpl<T>(
      freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Exception?,
    ));
  }
}

/// @nodoc

class _$AuthFailureImpl<T> implements AuthFailure<T> {
  const _$AuthFailureImpl([this.error]);

  @override
  final Exception? error;

  @override
  String toString() {
    return 'AuthState<$T>.failure(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<T, _$AuthFailureImpl<T>> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<T, _$AuthFailureImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function() signedOut,
    required TResult Function(T? data) signedIn,
    required TResult Function(Exception? error) failure,
  }) {
    return failure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function()? signedOut,
    TResult? Function(T? data)? signedIn,
    TResult? Function(Exception? error)? failure,
  }) {
    return failure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function()? signedOut,
    TResult Function(T? data)? signedIn,
    TResult Function(Exception? error)? failure,
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
    required TResult Function(AuthSignedOut<T> value) signedOut,
    required TResult Function(AuthSignedIn<T> value) signedIn,
    required TResult Function(AuthFailure<T> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthWaiting<T> value)? waiting,
    TResult? Function(AuthSignedOut<T> value)? signedOut,
    TResult? Function(AuthSignedIn<T> value)? signedIn,
    TResult? Function(AuthFailure<T> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthWaiting<T> value)? waiting,
    TResult Function(AuthSignedOut<T> value)? signedOut,
    TResult Function(AuthSignedIn<T> value)? signedIn,
    TResult Function(AuthFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class AuthFailure<T> implements AuthState<T> {
  const factory AuthFailure([final Exception? error]) = _$AuthFailureImpl<T>;

  Exception? get error;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<T, _$AuthFailureImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
