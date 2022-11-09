/// Invalidation callback for [DataSource].
///
/// Used to signal when a [DataSource] a data source has become invalid, and
/// that a new data source is needed to continue loading data.
abstract class InvalidatedCallback {
  /// Called when the data backing the list has become invalid. This callback
  /// is typically used to signal that a new data source is needed.
  ///
  /// This callback will be invoked on the thread that calls [invalidate]. It
  /// is valid for the data source to invalidate itself during its load methods,
  /// or for an outside source to invalidate it.
  void onInvalidated();
}
