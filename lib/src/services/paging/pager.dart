import 'dart:async';

import '../../core/basic_types.dart';
import '../../core/contracts.dart';
import 'base_types.dart';
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

  /// A cold Flow of [PagingData], which emits new instances of [PagingData]
  /// once they become invalidated by [PagingSource.invalidate] or calls to
  /// [PagingDataAdapter.refresh].
  Stream<PagingData<Value>> get flow => _controller.stream;

  final _controller = StreamController<PagingData<Value>>();

  @override
  void dispose() {
    _controller.close();
  }
}
