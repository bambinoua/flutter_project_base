import 'package:flutter/foundation.dart';

typedef CallbackInvoker<T> = void Function(T callback);
typedef InvalidGetter = bool Function();

/// https://android.googlesource.com/platform/frameworks/support/+/androidx-paging-release/paging/paging-common/src/main/kotlin/androidx/paging/InvalidateCallbackTracker.kt
class InvalidateCallbackTracker<T extends VoidCallback> {
  InvalidateCallbackTracker(this._callbackInvoker,
      {InvalidGetter? invalidGetter})
      : _invalidGetter = invalidGetter;

  final CallbackInvoker<T> _callbackInvoker;
  final InvalidGetter? _invalidGetter;

  final List<T> _callbacks = <T>[];

  bool get invalid => _invalid;
  bool _invalid = false;

  void registerInvalidatedCallback(T callback) {
    // This isn't sufficient, but is the best we can do in cases where
    // DataSource.isInvalid is overridden, since we have no way of knowing when
    //the result gets flipped if user never calls .invalidate().
    if (_invalidGetter?.call() ?? false) {
      invalidate();
    }

    if (_invalid) {
      _callbackInvoker(callback);
      return;
    }

    var callImmediately = false;

    if (_invalid) {
      callImmediately = true;
    } else {
      _callbacks.add(callback);
    }

    if (callImmediately) {
      _callbackInvoker(callback);
    }
  }

  void unregisterInvalidatedCallback(T callback) {
    _callbacks.remove(callback);
  }

  void invalidate() {
    if (_invalid) return;
    _invalid = true;

    final callbacksToInvoke = _callbacks.toList();
    _callbacks.clear();
    callbacksToInvoke.forEach(_callbackInvoker);
  }
}
