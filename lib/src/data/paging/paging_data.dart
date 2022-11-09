/// Container for Paged data from a single generation of loads.
///
/// Each refresh of data (generally either pushed by local storage, or pulled
/// from the network) will have a separate corresponding [PagingData].
class PagingData<T> {
  const PagingData(
    Stream<List<T>> flow,
    Object receiver,
  );

  /// Create a [PagingData] that immediately displays an empty list of items
  /// when submitted to [AsyncPagingDataAdapter][androidx.paging.AsyncPagingDataAdapter].
  PagingData.empty() : this(Stream<List<T>>.empty(), Object());

  /// Create a [PagingData] that immediately displays a static list of items
  /// when submitted to [AsyncPagingDataAdapter][androidx.paging.AsyncPagingDataAdapter].
  ///
  /// `data` is a static list of [T] to display.
  PagingData.from(List<T> data)
      : this(Stream.fromIterable(Iterable.castFrom(data)), Object());
}
