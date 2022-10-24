import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../core/extensions.dart';

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

/// Provides base interface for data query filter.
class DataQuery {
  DataQuery({
    List<String>? columns,
    List<QueryFilter>? where,
    List<QueryOrder>? orderBy,
  })  : _columns = Helper.safeList(columns),
        _where = Helper.safeList(where),
        _orderBy = Map.fromEntries(Helper.safeList(orderBy)
            .map((item) => MapEntry(item.column, item)));

  DataQuery.single(int id) : this(where: [QueryFilter('id', id)]);

  /// Returns empty data query.
  static DataQuery get empty => DataQuery();

  /// List of columns to SELECT.
  final List<String> _columns;

  /// List of WHERE conditions.
  final List<QueryFilter> _where;

  /// List of ORDER BY columns.
  final Map<String, QueryOrder> _orderBy;

  /// Returns list of queired colums.
  List<String> get columns => UnmodifiableListView(_columns);

  /// Returns list of condition parameters.
  List<QueryFilter> get where => UnmodifiableListView(_where);

  /// Returns list of sorting columns.
  List<QueryOrder> get orderBy => UnmodifiableListView(_orderBy.values);

  /// Add condition with `column` and `value`.
  void addCondition<T extends Object>(String column, T value,
      {ComparisonOperation operation = ComparisonOperation.equal}) {
    assert(column.isNotEmpty);
    _where.add(QueryFilter(column, value, operation: operation));
  }

  /// Add sorting order with `key` and `value`.
  void addSorting(String column,
      {SortDirection direction = SortDirection.ascending}) {
    assert(column.isNotEmpty);
    _orderBy.putIfAbsent(
        column, () => QueryOrder(column, direction: direction));
  }

  @override
  String toString() {
    final columnsClause = _columns.join(',');
    final whereClause = _where
        .map((condition) => '${condition.column}=${condition.value}')
        .join(',');
    final orderByClause = _orderBy.entries
        .map((order) => '${order.key}=${order.value.direction.name}')
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
