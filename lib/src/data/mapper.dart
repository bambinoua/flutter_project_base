/// Provides a mapping interface for transformation [TSource] to [TTarget].
abstract class Mapper<TSource, TTarget> {
  /// Map `value` to instance of [TTarget].
  TTarget map(TSource value);
}
