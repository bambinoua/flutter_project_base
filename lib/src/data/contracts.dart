import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

/// The [DataService] interface defines the contract by which app retrieve data.
@injectable
abstract class DataService<TSnapshot, TSingle>
    implements InfrastructureService, Disposable {
  /// Fetches the snapthot (usually list of rows) from underlaying `collection`.
  /// ```
  /// int count = await db.fetch('collection',
  ///    where: [QueryFilter('search', 'needle']);
  ///   orderBy: [QueryOrder('id']);
  /// ```
  Future<TSnapshot> fetch(
    String collection, {
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
    String collection, {
    required JsonMap values,
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
    String collection, {
    required JsonMap values,
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
    String collection, {
    required List<QueryFilter> where,
  });
}

/// Represents an SQL database service.
abstract class SqlDataService<TConnection, TSnapshot, TSingle>
    extends DataService<TSnapshot, TSingle>
    with DataServiceConnection<TConnection, TSnapshot, TSingle> {
  /// Executes a raw SQL SELECT query and returns a list
  /// of the rows that were found.
  ///
  /// ```
  /// List<Map> snapshot = await database.query('SELECT * FROM test WHERE id = ?',
  ///    parameters: [1]);
  /// ```
  Future<List<JsonMap>> query(String sql, {List<Object?>? parameters});
}

/// Represents a REST API database service.
abstract class RestDataService<TConnection, TSnapshot, TSingle>
    extends DataService<TSnapshot, TSingle>
    with DataServiceConnection<TConnection, TSnapshot, TSingle> {}

/// Provides a connection for [DataService]s which require it.
mixin DataServiceConnection<TConnection, TSnapshot, TSingle>
    on DataService<TSnapshot, TSingle> {
  /// Declares a connection if [DataService] requires it.
  @protected
  TConnection get connection;
}
