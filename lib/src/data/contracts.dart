import 'package:injectable/injectable.dart';

import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

/// The [DataService] interface defines the contract by which app retrieve data.
///  * TSource is a type of table schema or name to be handled.
///  * TQueryable is a type of returned collection of entities.
///  * TEntity is a type of single entity in collection.
///  * TValue is a type of value to be inserted or updated.
@injectable
abstract class DataService<TSource, TQueryable, TEntity, TValue>
    implements InfrastructureService, Disposable {
  /// Fetches the snapthot (usually list of rows) from underlaying `source`.
  /// ```
  /// int count = await db.fetch('source',
  ///    where: [QueryFilter('search', 'needle']);
  ///   orderBy: [QueryOrder('id']);
  /// ```
  Future<TQueryable> fetch(
    TSource source, {
    DataQuery? query,
  });

  /// This method helps insert a map of `values`
  /// into the specified `source` and returns the
  /// `id` of the last inserted row.
  ///
  /// ```
  /// final value = {
  ///   'age': 18,
  ///   'name': 'value'
  /// };
  /// int id = await db.insert('source', value);
  /// ```
  Future<TEntity> insert(
    TSource source, {
    required TValue value,
  });

  /// Updates `source` with `values`, a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// `where` is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// ```
  /// int count = await db.update('source', item.toMap(),
  ///    where: [QueryFilter('id', 1]);
  /// ```
  Future<TEntity> update(
    TSource source, {
    required TValue value,
    required List<QueryFilter>? where,
  });

  /// Deletes rows from `source`.
  ///
  /// `where` is the optional WHERE clause to apply when updating. Passing null
  /// or empty value will delete all rows.
  ///
  /// Returns the number of rows affected.
  /// ```
  /// int count = await db.delete('source', where: [QueryFilter('id', 1)]);
  /// ```
  Future<TResult> delete<TResult extends Object?>(
    TSource source, {
    required List<QueryFilter> where,
  });
}

/// Represents an SQL database service.
abstract class SqlDataService<TConnection, TSource, TQueryable, TEntity, TValue>
    extends DataService<TSource, TQueryable, TEntity, TValue>
    with DataConnection<TConnection, TSource, TQueryable, TEntity, TValue> {
  /// Executes a raw SQL SELECT query and returns a list
  /// of the rows that were found.
  ///
  /// ```
  /// List<Map> snapshot = await database.query('SELECT * FROM test WHERE id = ?',
  ///    parameters: [1]);
  /// ```
  Future<List<TValue>> query(String sql, {List<Object?>? parameters});
}

/// Represents a remote database service.
abstract class RemoteDataService<TConnection, TSource, TQueryable, TEntity,
        TValue> extends DataService<TSource, TQueryable, TEntity, TValue>
    with DataConnection<TConnection, TSource, TQueryable, TEntity, TValue> {}

/// Provides a connection for [DataService]s which require it.
mixin DataConnection<TConnection, TSource, TQueryable, TEntity, TValue>
    on DataService<TSource, TQueryable, TEntity, TValue> {
  /// Declares a connection if [DataService] requires it.
  TConnection get connection;
}
