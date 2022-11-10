import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';
import '../core/domain_driven_design.dart';
import '../core/extensions.dart';

/// Data query order used in ORDER BY clause.
@immutable
class QueryOrder extends Equatable implements Serializable {
  const QueryOrder._(
    this.column, {
    this.direction = SortDirection.ascending,
  }) : assert(column.length > 0);

  const QueryOrder.asc(String column) : this._(column);

  const QueryOrder.desc(String column)
      : this._(column, direction: SortDirection.descending);

  /// The name of the data source column.
  final String column;

  /// Sorting order direction.
  final SortDirection direction;

  @override
  List<Object?> get props => [column, direction];

  @override
  JsonMap toJson() {
    return {
      'column': column,
      'direction': direction.index,
    };
  }

  @override
  String toString() => 'QueryOrder {$column: ${direction.name}}';
}

/// Data query filter used in WHERE clause.
@immutable
class QueryFilter<T extends Object> extends Equatable implements Serializable {
  const QueryFilter._(
    this.column,
    this.value, {
    required this.operation,
  }) : assert(column.length > 0);

  const QueryFilter.equal(String column, T value)
      : this._(column, value, operation: ComparisonOperation.equal);

  const QueryFilter.greater(String column, T value)
      : this._(column, value, operation: ComparisonOperation.greater);

  const QueryFilter.less(String column, T value)
      : this._(column, value, operation: ComparisonOperation.less);

  /// The name of the data source column.
  final String column;

  /// The comparison operation.
  final ComparisonOperation operation;

  /// The value which will be checked.
  final T value;

  @override
  List<Object?> get props => [column, operation, value];

  @override
  JsonMap toJson() {
    return {
      'column': column,
      'value': value,
      'operation': operation.index,
    };
  }

  @override
  String toString() => 'QueryFilter {$column ${operation.name} $value}';
}

/// Provides base interface for data query filter.
@immutable
class DataQuery extends ValueObject<DataQuery> {
  DataQuery({
    List<String>? columns,
    List<QueryFilter>? where,
    List<QueryOrder>? orderBy,
    this.offset = 0,
    this.limit = -1,
    this.distinct = false,
  })  : assert(offset >= 0),
        assert(limit.isNegative || limit >= 0),
        _columns = Helper.safeList(columns),
        _where = Helper.safeList(where),
        _orderBy = Helper.safeList(orderBy);

  DataQuery.single(int id) : this(where: [QueryFilter.equal('id', id)]);

  /// Returns empty data query.
  static DataQuery get empty => DataQuery();

  /// List of columns to SELECT.
  final List<String> _columns;

  /// List of WHERE conditions.
  final List<QueryFilter> _where;

  /// List of ORDER BY columns.
  final List<QueryOrder> _orderBy;

  /// The offset of the first row to return.
  ///
  /// The offset of the initial row is 0 (not 1).
  final int offset;

  /// Constrains the number of rows returned by the query.
  final int limit;

  /// Specifies removal of duplicate rows from the result set.
  final bool distinct;

  /// Returns list of queired colums.
  List<String> get columns => UnmodifiableListView(_columns);

  /// Returns list of condition parameters.
  List<QueryFilter> get where => UnmodifiableListView(_where);

  /// Returns list of sorting columns.
  List<QueryOrder> get orderBy => UnmodifiableListView(_orderBy);

  /// Add condition with `column` and `value`.
  void addCondition<T extends Object>(String column, T value,
      {ComparisonOperation operation = ComparisonOperation.equal}) {
    assert(column.isNotEmpty);
    _where.add(QueryFilter<T>._(column, value, operation: operation));
  }

  /// Add sorting order with `key` and `value`.
  void addSorting(String column,
      {SortDirection direction = SortDirection.ascending}) {
    assert(column.isNotEmpty);
    _orderBy.add(QueryOrder._(column, direction: direction));
  }

  @override
  List<Object?> get props => [columns, where, orderBy, offset, limit, distinct];

  @override
  DataQuery copyWith({
    List<String>? columns,
    List<QueryFilter>? where,
    List<QueryOrder>? orderBy,
    int? offset,
    int? limit,
    bool? distinct,
  }) {
    return DataQuery(
      columns: columns ?? _columns,
      where: where ?? _where,
      orderBy: orderBy ?? _orderBy,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      distinct: distinct ?? this.distinct,
    );
  }

  @override
  JsonMap toJson() {
    return {
      'columns': _columns,
      'where': _where,
      'orderBy': _orderBy,
      if (offset > 0) 'offset': offset,
      if (limit > 0) 'limit': limit,
      'distinct': distinct,
    };
  }

  @override
  String toString() {
    final columnsClause = _columns.join(',');
    final whereClause = _where
        .map((condition) => '${condition.column}=${condition.value}')
        .join(',');
    final orderByClause = _orderBy
        .map((order) => '${order.column}=${order.direction.name}')
        .join(',');
    final properties = [
      if (columnsClause.isNotEmpty) 'columns: $columnsClause',
      if (whereClause.isNotEmpty) 'where: $whereClause',
      if (orderByClause.isNotEmpty) 'orderby: $orderByClause',
    ].join(',');
    return 'DataQuery {$properties}';
  }
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
