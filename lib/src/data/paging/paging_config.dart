import '../../core/extensions.dart';
import 'load_result.dart';

/// An object used to configure loading behavior within a [Pager], as it loads
/// content from a [PagingSource].
///
/// When [maxSize] is set to [maxSizeUnbounded], the maximum number of items
/// loaded is unbounded, and pages will never be dropped.
class PagingConfig {
  const PagingConfig({
    this.pageSize = 1,
    this.initialLoadSize = 1,
    this.maxSize = maxSizeUnbounded,
    this.prefetchDistance = 0,
    this.jumpThreshold = LoadResult.countUndefined,
    this.enablePlaceholders = false,
  })  : assert(pageSize >= 1),
        assert(maxSize >= 2),
        assert(initialLoadSize >= 1),
        assert(prefetchDistance >= 0),
        assert(jumpThreshold == LoadResult.countUndefined || jumpThreshold > 0),
        assert(
            enablePlaceholders || prefetchDistance > 0,
            'Placeholders and prefetch are the only ways to trigger '
            'loading of more data in PagingData, so either placeholders '
            'must be enabled, or prefetch distance must be > 0.'),
        assert(
            maxSize == maxSizeUnbounded ||
                maxSize >= pageSize + prefetchDistance * 2,
            'Maximum size must be at least pageSize + 2 * prefetchDistance,'
            'pageSize=$pageSize, prefetchDist=$prefetchDistance, '
            'maxSize=$maxSize');

  const PagingConfig.standard({int pageSize = defaultPageSize})
      : this(
          pageSize: pageSize,
          initialLoadSize: pageSize * defaultInitialPageMultiplier,
          prefetchDistance: pageSize,
        );

  static const int defaultPageSize = 30;
  static const int defaultInitialPageMultiplier = 3;
  static const int maxSizeUnbounded = Int.max32bitValue;

  /// Defines the number of items loaded at once from the [PagingSource].
  final int pageSize;

  /// Defines requested load size for initial load from [PagingSource],
  /// typically larger than `pageSize`, so on first load data there's a large
  /// enough range of content loaded to cover small scrolls.
  final int initialLoadSize;

  /// Defines the maximum number of items that may be loaded into [PagingData]
  /// before pages should be dropped.
  final int maxSize;

  /// Prefetch distance which defines how far from the edge of loaded content
  /// an access must be to trigger further loading.
  final int prefetchDistance;

  /// Defines a threshold for the number of items scrolled outside the bounds
  /// of loaded items before Paging should give up on loading pages
  /// incrementally, and instead jump to the user's position by triggering
  /// REFRESH via invalidate.
  final int jumpThreshold;

  /// Defines whether [PagingData] may display null placeholders, if the
  /// [PagingSource] provides them.
  final bool enablePlaceholders;
}
