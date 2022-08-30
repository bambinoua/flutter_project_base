// Domain object.
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';

/// Identity interface which just defines an `id` property with the given
/// primary key type.
///
/// Primary key types can be `int` or `String` (GUID indeed),
abstract class Identity<T> {
  const Identity() : assert(T == int || T == String);

  /// Default name of identity property.
  static const String propertyName = 'id';

  /// Unique domain entity identifier.
  ///
  /// Cannot be negative.
  T get id;
}

/// Entities are one of the core concepts of DDD (Domain Driven Design).
/// An object that is not fundamentally defined by its attributes, but
/// rather by a thread of continuity and identity. Essentially, entities
/// have Id's and are stored in a database. An entity is generally mapped
/// to a table in a relational database.
abstract class EntityObject with EquatableMixin implements Identity<int> {
  /// Cretes an instance of reference entity.
  const EntityObject({int? id}) : _id = id;

  /// Cretes an instance of entity object from `map`.
  EntityObject.fromJson(Json map) : _id = map[Identity.propertyName];

  /// Entity unique identifier.
  final int? _id;

  @override
  int get id => _id ?? 0;

  /// Optional entity name.
  String get name => '';

  /// Returns `true` if entity is transient, i.e. new.
  bool get isTransient => _id == 0;

  @override
  List<Object?> get props => [_id];
}

/// An object that represents a descriptive aspect of the domain with no
/// conceptual identity is called a VALUE OBJECT
///
/// [EntityObject]s have identities (Id), Value Objects do not. If the
/// identities of two Entities are different, they are considered as
/// different objects/entities even if all the properties of those
/// entities are the same.
///
/// Imagine two different people that have the same Name, Surname and
/// Age but are different people (their identity numbers are different).
/// For an Address class (which is a classic Value Object), if the two
/// addresses have the same Country, City, and Street number, etc, they
/// are considered to be the same address.
@immutable
abstract class ValueObject<T> extends Equatable
    implements Serializable, Cloneable<T> {
  const ValueObject();
}

/// Data Transfer Objects are used to transfer data between
/// the Application Layer and the Presentation Layer.
///
/// The Presentation Layer calls an Application Service method with a
/// Data Transfer Object (DTO). The application service then uses these
/// domain objects to perform some specific business logic, and then
/// finally returns a DTO back to the presentation layer. Thus, the
/// Presentation layer is completely isolated from the Domain layer.
/// In an ideally layered application, the presentation layer never
/// works with domain objects, (Repositories, or Entities...).
abstract class DTO implements Identity<int>, Serializable {
  /// Cretes an instance of entity object from `map`.
  DTO.fromJson(Json map) : _id = map[Identity.propertyName];

  /// Entity unique identifier.
  final int? _id;

  @override
  int get id => _id ?? 0;
}

abstract class EntityToDtoConverter<T extends EntityObject, S extends DTO> {
  /// Maps `entity` to [DTO].
  S toDTO(T entity);
}

abstract class DtoToEntityConverter<T extends EntityObject, S extends DTO> {
  /// Maps `dto` to [EntityObject].
  T toEntity(S dto);
}

/// Declares an interface for bidirectional mapping of [EntityObject] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends EntityObject, S extends DTO>
    implements EntityToDtoConverter<T, S>, DtoToEntityConverter<T, S> {}

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
