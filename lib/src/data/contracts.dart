// Domain object.

import '../core/basic_types.dart';
import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import 'query.dart';

mixin EntityToDtoMapper<T extends DTO> on Entity {
  /// Maps this [entity] to [DTO].
  T toDTO();
}

mixin DtoToEntityMapper<T extends Entity> on DTO {
  /// Maps this [dto] to [Entity].
  T toEntity();
}

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends Entity, S extends DTO>
    implements DomainService {
  /// Maps the `entity` to [DTO].
  S toDTO(T entity);

  /// Maps the `dto` to [Entity].
  T toEntity(S dto);
}

/// Enables creation of DDEX provider objects.
abstract class DataProvider implements InfrastructureService, Disposable {
  DataProvider._();

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
