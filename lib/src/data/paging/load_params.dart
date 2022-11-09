import 'package:meta/meta.dart';

@sealed
class LoadParams<Key> {
  const LoadParams._({
    this.key,
    this.loadSize = 1,
    this.placeholdersEnabled = false,
  }) : assert(loadSize >= 1);

  /// Params to load a page of data from a [PagingSource] via [PagingSource.load]
  /// to be appended to the end of the list.
  LoadParams.append({required Key key, required int loadSize})
      : this._(key: key, loadSize: loadSize);

  /// Params to load a page of data from a [PagingSource] via [PagingSource.load]
  /// to be appended to the end of the list.
  LoadParams.prepend({required Key key, required int loadSize})
      : this._(key: key, loadSize: loadSize);

  /// Params for an initial load request on a [PagingSource] from
  /// [PagingSource.load] or a refresh triggered by [invalidate].
  LoadParams.refresh({Key? key, required int loadSize})
      : this._(key: key, loadSize: loadSize);

  /// Key for the page to be loaded.
  ///
  /// [key] can be `null` only if this [LoadParams] is [Refresh], and either no
  /// `initialKey` is provided to the [Pager] or [PagingSource.getRefreshKey]
  /// from the previous [PagingSource] returns `null`.
  ///
  /// The value of [key] is dependent on the type of [LoadParams]:
  ///  * [Refresh]
  ///    * On initial load, the nullable `initialKey` passed to the [Pager].
  ///    * On subsequent loads due to invalidation or refresh, the result of
  ///      [PagingSource.getRefreshKey].
  ///  * [Prepend] - [LoadResult.Page.prevKey] of the loaded page at the front
  ///    of the list.
  ///  * [Append] - [LoadResult.Page.nextKey] of the loaded page at the end of
  ///    the list.
  final Key? key;

  /// Requested number of items to load.
  ///
  /// It is valid for [PagingSource.load] to return a [LoadResult] that has a
  /// different number of items than the requested load size.
  final int loadSize;

  /// From [PagingConfig.enablePlaceholders], `true` if placeholders are enabled
  /// and the load request for this [LoadParams] should populate
  /// [PagingSourceLoadResult.Page.itemsBefore] and
  /// [PagingSourceLoadResult.Page.itemsAfter] if possible.
  final bool placeholdersEnabled;
}
