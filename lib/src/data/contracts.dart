import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

/// The [DataService] interface defines the contract by which app retrieve data.
///  * TCollection is a type of returned collection of entities.
///  * TSingle is a type of single entity in collection.
///  * TSchema is a type of table schema or name to be handled.
///  * TValue is a type of value to be inserted or updated.
@injectable
abstract class DataService<TCollection, TSingle, TSchema, TValue>
    implements InfrastructureService, Disposable {
  /// Fetches the snapthot (usually list of rows) from underlaying `collection`.
  /// ```
  /// int count = await db.fetch('collection',
  ///    where: [QueryFilter('search', 'needle']);
  ///   orderBy: [QueryOrder('id']);
  /// ```
  Future<TCollection> fetch(
    TSchema schema, {
    required DataQuery query,
  });

  /// This method helps insert a map of `values`
  /// into the specified `collection` and returns the
  /// `id` of the last inserted row.
  ///
  /// ```
  /// final value = {
  ///   'age': 18,
  ///   'name': 'value'
  /// };
  /// int id = await db.insert('collection', value);
  /// ```
  Future<TSingle> insert(
    TSchema schema, {
    required TValue value,
  });

  /// Updates `collection` with `values`, a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// `where` is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// ```
  /// int count = await db.update('collection', item.toMap(),
  ///    where: [QueryFilter('id', 1]);
  /// ```
  Future<TSingle> update(
    TSchema schema, {
    required TValue value,
    required List<QueryFilter>? where,
  });

  /// Deletes rows from `collection`.
  ///
  /// `where` is the optional WHERE clause to apply when updating. Passing null
  /// or empty value will delete all rows.
  ///
  /// Returns the number of rows affected.
  /// ```
  /// int count = await db.delete('collection', where: [QueryFilter('id', 1)]);
  /// ```
  Future<int> delete(
    TSchema schema, {
    required List<QueryFilter> where,
  });
}

/// Represents an SQL database service.
abstract class SqlDataService<TConnection, TCollection, TSingle, TSchema,
        TValue> extends DataService<TCollection, TSingle, TSchema, TValue>
    with
        DataServiceConnection<TConnection, TCollection, TSingle, TSchema,
            TValue> {
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
abstract class RemoteDataService<TConnection, TCollection, TSingle, TSchema,
        TValue> extends DataService<TCollection, TSingle, TSchema, TValue>
    with
        DataServiceConnection<TConnection, TCollection, TSingle, TSchema,
            TValue> {}

/// Provides a connection for [DataService]s which require it.
mixin DataServiceConnection<TConnection, TCollection, TSingle, TSchema, TValue>
    on DataService<TCollection, TSingle, TSchema, TValue> {
  /// Declares a connection if [DataService] requires it.
  @protected
  TConnection get connection;
}
