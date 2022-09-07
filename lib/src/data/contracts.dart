// Domain object.
import 'package:equatable/equatable.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';
import '../core/domain_driven_design.dart';

mixin EntityToDtoMapper<T extends DTO> on EntityObject {
  /// Maps this [entity] to [DTO].
  T toDTO();
}

mixin DtoToEntityMapper<T extends EntityObject> on DTO {
  /// Maps this [dto] to [EntityObject].
  T toEntity();
}

/// Declares an interface for bidirectional mapping of [EntityObject] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends EntityObject, S extends DTO> {
  /// Maps the `entity` to [DTO].
  S toDTO(T entity);

  /// Maps the `dto` to [EntityObject].
  T toEntity(S dto);
}

/// Enables creation of DDEX provider objects.
abstract class DataProvider implements Disposable {
  DataProvider._();

  /// Fetches the list of rows from underlaying `dataSource`.
  Future<List<Json>> fetch(
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
  Future<Json> insert(
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
  Future<Json> update(
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

/// Data query order used in ORDER BY clause.
class QueryOrder extends Equatable {
  const QueryOrder(
    this.column, {
    this.direction = SortDirection.ascending,
  });

  /// The name of the data source column.
  final String column;

  /// Sorting order direction.
  final SortDirection direction;

  @override
  List<Object?> get props => [column, direction];

  @override
  String toString() => 'QueryOrder {$column: ${direction.name}}';
}

/// Data query filter used in WHERE clause.
class QueryFilter<T extends Object> extends Equatable {
  const QueryFilter(
    this.column,
    this.value, {
    this.operation = ComparisonOperation.equal,
  });

  /// The name of the data source column.
  final String column;

  /// The comparison operation.
  final ComparisonOperation operation;

  /// The value which will be checked.
  final T value;

  @override
  List<Object?> get props => [column, operation, value];

  @override
  String toString() => 'QueryFilter {$column ${operation.name} $value}';
}

/// Sorting order directions.
enum SortDirection {
  /// Sorting by ascending.
  ascending,

  /// Sorting by descending.
  descending,
}

/// Comparison operations.
enum ComparisonOperation {
  less,
  lessOrEqual,
  equal,
  greaterOrEqual,
  greater,
}
