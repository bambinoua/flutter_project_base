import 'dart:async';

import '../../core/basic_types.dart';
import '../../core/contracts.dart';
import 'paging_data.dart';
import 'paging_config.dart';
import 'paging_source.dart';

class Pager<Key, Value> implements Disposable {
  Pager(
    this.config, {
    this.initialKey,
    required this.pagingSourceFactory,
  });

  final PagingConfig config;
  final Key? initialKey;
  final ValueBuilder<PagingSource<Key, Value>> pagingSourceFactory;

  final _controller = StreamController<PagingData<Value>>();

  /// A cold [Flow] of [PagingData], which emits new instances of [PagingData]
  /// once they become invalidated by [PagingSource.invalidate] or calls to
  /// [AsyncPagingDataDiffer.refresh] or [PagingDataAdapter.refresh].
  ///
  /// To consume this stream as a LiveData or in Rx, you may use the extensions
  /// available in the  paging-runtime or paging-rxjava* artifacts.
  ///
  /// NOTE: Instances of [PagingData] emitted by this [Flow] are not re-usable
  /// and cannot be submitted multiple times. This is especially relevant for
  /// transforms such as [Flow.combine][kotlinx.coroutines.flow.combine], which
  /// would replay the latest value downstream. To ensure you get a new instance
  /// of [PagingData] for each downstream observer, you should use the
  /// [cachedIn] operator which multicasts the [Flow] in a way that returns a
  /// new instance of [PagingData] with cached data pre-loaded.
  Stream<PagingData<Value>> get flow => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }
}
