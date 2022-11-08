import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../core/extensions.dart';

@sealed
class LoadResult<Key, Value> {
  const LoadResult._();

  /// Invalid result object for [PagingSource.load].
  const factory LoadResult.invalid() = _LoadResultInvalid._;

  /// Error result object for [PagingSource.load].
  const factory LoadResult.error(Exception error) = _LoadResultError._;

  /// Success result object for [PagingSource.load].
  const factory LoadResult.page({
    required List<Value> data,
    Key? prevKey,
    Key? nextKey,
    int itemsBefore,
    int itemsAfter,
  }) = _LoadResultPage._;

  static const int countUndefined = Int.min32bitValue;

  void when({
    required ValueSetter<Page<Key, Value>> page,
    required ValueSetter<Error<Key, Value>> error,
    required ValueSetter<Invalid<Key, Value>> invalid,
  }) {
    if (this is Page) {
      page(this as Page<Key, Value>);
    }
    if (this is Error) {
      error(this as Error<Key, Value>);
    }
    if (this is Invalid) {
      invalid(this as Invalid<Key, Value>);
    }
  }
}

/// Invalid result object for [PagingSource.load]
///
/// This return type can be used to terminate future load requests on this
/// [PagingSource] when the [PagingSource] is not longer valid due to changes
/// in the underlying dataset.
///
/// For example, if the underlying database gets written into but the
/// [PagingSource] does not invalidate in time, it may return inconsistent
/// results if its implementation depends on the immutability of the backing
/// dataset it loads from (e.g., LIMIT OFFSET style db implementations). In this
/// scenario, it is recommended to check for invalidation after loading and to
/// return LoadResult.Invalid, which causes Paging to discard any pending or
/// future load requests to this PagingSource and invalidate it.
///
/// Returning [Invalid] will trigger Paging to [invalidate] this [PagingSource]
/// and terminate any future attempts to [load] from this [PagingSource]
class _LoadResultInvalid<Key, Value> extends LoadResult<Key, Value> {
  const _LoadResultInvalid._() : super._();
}

/// Error result object for [PagingSource.load].
///
/// This return type indicates an expected, recoverable error (such as a network
/// load failure). This failure will be forwarded to the UI as a
/// [LoadState.Error], and may be retried.
///
/// * Sample: androidx.paging.samples.pageKeyedPagingSourceSample
class _LoadResultError<Key, Value> extends LoadResult<Key, Value> {
  const _LoadResultError._(this.throwable) : super._();

  /// Instance of exception.
  final Exception throwable;
}

/// Success result object for [PagingSource.load].
///
/// * Sample: androidx.paging.samples.pageIndexedPage
class _LoadResultPage<Key, Value> extends LoadResult<Key, Value> {
  const _LoadResultPage._({
    required this.data,
    this.prevKey,
    this.nextKey,
    this.itemsBefore = LoadResult.countUndefined,
    this.itemsAfter = LoadResult.countUndefined,
  })  : assert(itemsBefore >= 0),
        assert(itemsAfter >= 0),
        super._();

  /// Loaded data.
  final List<Value> data;

  /// Key for previous page if more data can be loaded in that direction, null
  /// otherwise.
  final Key? prevKey;

  /// Key for next page if more data can be loaded in that direction, null
  /// otherwise.
  final Key? nextKey;

  /// Optional count of items before the loaded data.
  final int itemsBefore;

  /// Optional count of items after the loaded data.
  final int itemsAfter;
}

/// Synonym of [LoadResultPage<Key, Value>].
typedef Page<Key, Value> = _LoadResultPage<Key, Value>;

/// Synonym of [LoadResultError<Key, Value>].
typedef Error<Key, Value> = _LoadResultError<Key, Value>;

/// Synonym of [LoadResultInvalid<Key, Value>].
typedef Invalid<Key, Value> = _LoadResultInvalid<Key, Value>;
