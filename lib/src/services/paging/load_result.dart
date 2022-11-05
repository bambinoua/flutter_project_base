import 'package:meta/meta.dart';

import '../../core/extensions.dart';

@sealed
class LoadResult<Key, Value> {
  /// Invalid result object for [PagingSource.load].
  factory LoadResult.invalid() => const LoadResultInvalid._();

  /// Error result object for [PagingSource.load].
  factory LoadResult.error(Exception error) => LoadResultError._(error);

  /// Success result object for [PagingSource.load].
  factory LoadResult.page(
    List<Value> data, {
    Key? prevKey,
    Key? nextKey,
    int itemsBefore = countUndefined,
    int itemsAfter = countUndefined,
  }) =>
      LoadResultPage._(
        data: data,
        prevKey: prevKey,
        nextKey: nextKey,
        itemsBefore: itemsBefore,
        itemsAfter: itemsAfter,
      );

  static const int countUndefined = Int.min32bitValue;
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
class LoadResultInvalid<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultInvalid._();
}

/// Error result object for [PagingSource.load].
///
/// This return type indicates an expected, recoverable error (such as a network
/// load failure). This failure will be forwarded to the UI as a
/// [LoadState.Error], and may be retried.
///
/// * Sample: androidx.paging.samples.pageKeyedPagingSourceSample
class LoadResultError<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultError._(this.throwable);

  /// Instance of exception.
  final Exception throwable;
}

/// Success result object for [PagingSource.load].
///
/// * Sample: androidx.paging.samples.pageIndexedPage
class LoadResultPage<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultPage._({
    required this.data,
    this.prevKey,
    this.nextKey,
    this.itemsBefore = LoadResult.countUndefined,
    this.itemsAfter = LoadResult.countUndefined,
  })  : assert(itemsBefore > 0),
        assert(itemsAfter >= 0);

  const LoadResultPage.empty() : this._(data: const []);

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
