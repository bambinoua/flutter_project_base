// Domain object.

import 'package:flutter/foundation.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

/// Provides a connection for [DataProvider]s which require it.
mixin DataProviderConnectible<T> on DataProvider {
  /// Declares a connection if [DataProvider] requires it.
  @protected
  T get connection;
}

/// Enables creation of DDEX provider objects.
abstract class DataProvider implements InfrastructureService, Disposable {
  /// Fetches the list of rows from underlaying `dataSource`.
  Future<List<JsonMap>> fetch(
    String dataSource, {
    bool distinct = false,
    List<String> columns = const <String>[],
    List<QueryFilter> where = const <QueryFilter>[],
    List<QueryOrder> orderBy = const <QueryOrder>[],
    int? offset,
    int? limit,
  });

  /// This method helps insert a map of `values`
  /// into the specified `dataSource` and returns the
  /// `id` of the last inserted row.
  ///
  /// ```
  /// final value = {
  ///   'age': 18,
  ///   'name': 'value'
  /// };
  /// int id = await db.insert('tableTodo', value);
  /// ```
  Future<JsonMap> insert(
    String dataSource, {
    Map<String, dynamic> values = const <String, dynamic>{},
  });

  /// Updates `dataSource` with `values`, a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// `where` is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// ```
  /// int count = await db.update(tableTodo, todo.toMap(),
  ///    where: [QueryFilter('id', 1]);
  /// ```
  Future<JsonMap> update(
    String dataSource, {
    Map<String, dynamic> values = const <String, dynamic>{},
    List<QueryFilter> where = const <QueryFilter>[],
  });

  /// Deletes rows from `dataSource`.
  ///
  /// `where` is the optional WHERE clause to apply when updating. Passing null
  /// or empty value will delete all rows.
  ///
  /// Returns the number of rows affected.
  /// ```
  /// int count = await db.delete(tableTodo,
  ///    where: [QueryFilter('id', 1)]);
  /// ```
  Future<int> delete(
    String dataSource, {
    List<QueryFilter> where = const <QueryFilter>[],
  });
}
