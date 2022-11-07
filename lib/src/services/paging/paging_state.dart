import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../core/extensions.dart';
import 'load_result.dart';
import 'paging_config.dart';

/// Snapshot state of Paging system including the loaded [pages], the last
/// accessed [anchorPosition], and the [config] used.
class PagingState<Key, Value> extends Equatable {
  const PagingState({
    this.anchorPosition,
    required this.config,
    this.pages = const <LoadResultPage<Key, Value>>[],
    int leadingPlaceholderCount = 0,
  })  : assert(leadingPlaceholderCount >= 0),
        _leadingPlaceholderCount = leadingPlaceholderCount;

  /// Most recently accessed index in the list, including placeholders.
  ///
  /// `null` if no access in the [PagingData] has been made yet. E.g., if this
  /// snapshot was generated before or during the first load.
  final int? anchorPosition;

  /// [PagingConfig] that was given when initializing the [PagingData] stream.
  final PagingConfig config;

  /// Loaded pages of data in the list.
  final List<LoadResultPage<Key, Value>> pages;

  /// Number of placeholders before the first loaded item if placeholders are
  /// enabled, otherwise 0.
  final int _leadingPlaceholderCount;

  /// Coerces [anchorPosition] to closest loaded value in [pages].
  ///
  /// This function can be called with [anchorPosition] to fetch the loaded item
  /// that is closest to the last accessed index in the list.
  ///
  /// @param anchorPosition Index in the list, including placeholders.
  ///
  /// @return The closest loaded [Value] in [pages] to the provided
  /// [anchorPosition]. `null` if all loaded [pages] are empty.
  Value? closestItemToPosition(int anchorPosition) {
    if (pages.isEmpty) return null;

    return _anchorPositionToPagedIndices(anchorPosition, (pageIndex, index) {
      final firstNonEmptyPage = pages.first;
      final lastNonEmptyPage = pages.last;
      if (index.isNegative) {
        return firstNonEmptyPage.data.first;
      }
      if (pageIndex == pages.lastIndex && index > pages.last.data.lastIndex) {
        return lastNonEmptyPage.data.last;
      }
      return pages[pageIndex].data[index];
    });
  }

  /// Coerces an index in the list, including placeholders, to closest loaded
  /// page in [pages].
  LoadResultPage<Key, Value>? closestPageToPosition(int anchorPosition) {
    if (pages.isEmpty) return null;

    return _anchorPositionToPagedIndices(anchorPosition, (pageIndex, index) {
      return index.isNegative ? pages.first : pages[pageIndex];
    });
  }

  /// Returns `true` if all loaded pages are empty or no pages were loaded when
  /// this [PagingState] was created, `false` otherwise.
  bool get isEmpty => pages.isEmpty;

  /// Returns the first loaded item in the list or `null` if all loaded pages
  /// are empty or no pages were loaded when this [PagingState] was created.
  Value? get firstItemOrNull => pages.firstOrNull?.data.first;

  /// @return The last loaded item in the list or `null` if all loaded pages
  /// are empty or no pages were loaded when this [PagingState] was created.
  Value? get lastItemOrNull => pages.lastOrNull?.data.last;

  T _anchorPositionToPagedIndices<T>(
      int anchorPosition, T Function(int pageIndex, int index) block) {
    var pageIndex = 0;
    var index = anchorPosition - _leadingPlaceholderCount;
    while (pageIndex < pages.lastIndex &&
        index > pages[pageIndex].data.lastIndex) {
      index -= pages[pageIndex].data.length;
      pageIndex++;
    }
    return block(pageIndex, index);
  }

  @override
  List<Object?> get props => [
        anchorPosition,
        config,
        pages,
        _leadingPlaceholderCount,
      ];

  @override
  String toString() {
    return 'PagingState(pages: $pages, anchorPosition: $anchorPosition, '
        'config: $config, leadingPlaceholderCount: $_leadingPlaceholderCount)';
  }
}
