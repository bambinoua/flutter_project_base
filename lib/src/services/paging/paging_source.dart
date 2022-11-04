import 'package:flutter/foundation.dart';

import 'invalid_callback_tracker.dart';
import 'load_params.dart';
import 'load_result.dart';
import 'paging_state.dart';

/// https://android.googlesource.com/platform/frameworks/support/+/androidx-paging-release/paging/paging-common/src/main/kotlin/androidx/paging/PagingSource.kt
abstract class PagingSource<Key, Value> {
  final _invalidateCallbackTracker =
      InvalidateCallbackTracker<VoidCallback>((callback) => callback());

  /// Whether this [PagingSource] has been invalidated, which should happen when
  /// the data this [PagingSource] represents changes since it was first
  /// instantiated.
  bool get invalid => _invalidateCallbackTracker.invalid;

  /// `true` if this [PagingSource] expects to re-use keys to load distinct
  /// pages without a call to invalidate, `false` otherwise.
  bool get keyReuseSupported => false;

  /// `true` if this [PagingSource] supports jumping, `false` otherwise.
  bool get jumpingSupported => false;

  /// Signal this [PagingSource] to stop loading.
  void invalidate() => _invalidateCallbackTracker.invalidate();

  void registerInvalidatedCallback(VoidCallback onInvalidatedCallback) {
    _invalidateCallbackTracker
        .registerInvalidatedCallback(onInvalidatedCallback);
  }

  void unregisterInvalidatedCallback(VoidCallback onInvalidatedCallback) {
    _invalidateCallbackTracker
        .unregisterInvalidatedCallback(onInvalidatedCallback);
  }

  /// Loading API for [PagingSource].
  ///
  /// Implement this method to trigger your async `load` (e.g. from database or
  /// network).
  Future<LoadResult<Key, Value>> load(LoadParams<Key> params);

  /// Provide a [Key] used for the initial [load] for the next [PagingSource]
  /// due to invalidation of this [PagingSource]. The [Key] is provided to
  /// [load] via [LoadParams.key].
  ///
  /// The [Key] returned by this method should cause [load] to load enough items
  /// to fill the viewport around the last accessed position, allowing the next
  /// generation to transparently animate in. The last accessed position can be
  /// retrieved via [state.anchorPosition][PagingState.anchorPosition], which is
  /// typically the top-most or bottom-most item in the viewport due to access
  /// being triggered by binding items as they scroll into view.
  ///
  /// For example, if items are loaded based on integer position keys, you can
  /// return [state.anchorPosition][PagingState.anchorPosition].
  ///
  /// Alternately, if items contain a key used to load, get the key from the
  /// item in the page at index [state.anchorPosition][PagingState.anchorPosition].
  ///
  /// Parameter `state` [PagingState] of the currently fetched data, which
  /// includes the most recently accessed position in the list via
  /// [PagingState.anchorPosition].
  ///
  /// Returns a [Key] passed to [load] after invalidation used for initial load
  /// of the next generation. The [Key] returned by [getRefreshKey] should load
  /// pages centered around user's current viewport. If the correct [Key] cannot
  /// be determined, `null` can be returned to allow [load] decide what default
  /// key to use.
  Key? getRefreshKey(PagingState<Key, Value> state);
}
