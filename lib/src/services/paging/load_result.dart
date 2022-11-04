import 'package:meta/meta.dart';

import 'paging_config.dart';

@sealed
class LoadResult<Key, Value> {
  /// Invalid result object for [PagingSource.load].
  factory LoadResult.invalid() => const LoadResultInvalid._();

  /// Error result object for [PagingSource.load].
  factory LoadResult.error(Exception error) => LoadResultError._(error);

  /// Success result object for [PagingSource.load].
  factory LoadResult.page({
    required List<Value> data,
    Key? prevKey,
    Key? nextKey,
    int itemsBefore = PagingConfig.countUndefined,
    int itemsAfter = PagingConfig.countUndefined,
  }) =>
      LoadResultPage._(
        data: data,
        prevKey: prevKey,
        nextKey: nextKey,
        itemsBefore: itemsBefore,
        itemsAfter: itemsAfter,
      );
}

class LoadResultInvalid<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultInvalid._();
}

class LoadResultError<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultError._(this.throwable);

  final Exception throwable;
}

class LoadResultPage<Key, Value> implements LoadResult<Key, Value> {
  const LoadResultPage._({
    required this.data,
    this.prevKey,
    this.nextKey,
    this.itemsBefore = PagingConfig.countUndefined,
    this.itemsAfter = PagingConfig.countUndefined,
  })  : assert(itemsBefore >= -1),
        assert(itemsAfter >= -1);

  LoadResultPage.empty() : this._(data: []);

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
