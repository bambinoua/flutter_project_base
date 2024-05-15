import 'package:injectable/injectable.dart';

import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

/// The [DataService] interface defines the contract by which app retrieve data.
///  * TSource is a type of table schema or name to be handled.
///  * TQueryable is a type of returned collection of values.
///  * TInput is a type of inserted/updated value.
///  * TOutput is a type of returned value.
@injectable
abstract interface class DataService<TSource, TQueryable, TInput, TOutput>
    implements InfrastructureService, Disposable {
  /// Fetches the snapthot (usually list of rows) from underlaying `source`.
  /// ```
  /// List<JsonMap> result = await db.fetch('source',
  ///    where: [QueryFilter('search', 'needle']);
  ///   orderBy: [QueryOrder('id']);
  /// ```
  Future<TQueryable> fetch(TSource source, {DataQuery? query});

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
  Future<TOutput> insert(TSource source, {required TInput value});

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
  Future<TOutput> update(TSource source,
      {required TInput value, List<QueryFilter>? where});

  /// Deletes rows from `source`.
  ///
  /// `where` is the optional WHERE clause to apply when updating. Passing null
  /// or empty value will delete all rows.
  ///
  /// Returns `true` if row is deleted successfully, otherwise `false`.
  /// ```
  /// bool deleted = await db.delete('source', where: [QueryFilter('id', 1)]);
  /// ```
  Future<bool> delete(TSource source, {List<QueryFilter>? where});
}

/// Represents an SQL database service.
abstract class SqlDataService<TConnection, TSource, TQueryable, TInput, TOutput>
    extends DataService<TSource, TQueryable, TInput, TOutput>
    with DataConnection<TConnection, TSource, TQueryable, TInput, TOutput> {
  /// Executes a raw SQL SELECT query and returns a list
  /// of the rows that were found.
  ///
  /// ```
  /// List<Map> snapshot = await database.query('SELECT * FROM test WHERE id = ?',
  ///    parameters: [1]);
  /// ```
  Future<List<TOutput>> query(String sql, {List<Object?>? parameters});
}

/// Represents an REST API web data service.
abstract class WebDataService<TConnection, TSource, TQueryable, TInput, TOutput>
    extends DataService<TSource, TQueryable, TInput, TOutput>
    with DataConnection<TConnection, TSource, TQueryable, TInput, TOutput> {}

/// Provides a connection for [DataService]s which require it.
mixin DataConnection<TConnection, TSource, TQueryable, TInput, TOutput>
    on DataService<TSource, TQueryable, TInput, TOutput> {
  /// The connection for underlying instance of [DataService].
  TConnection get connection;
}
