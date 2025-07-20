import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Object describes the constrain for field validation.
@immutable
class Constraint<T> {
  /// Creates a validable field constraint.
  const Constraint({
    this.isNull = true,
    this.min,
    this.max,
    this.list,
    this.regExp,
  }) : assert(regExp == null || regExp != '');

  /// Indicates whether the field cannot be omitted or its value cannot contains null.
  final bool isNull;

  /// The minimum value.
  ///
  /// For [int] values it is treated as smaller value, for [String] as minimum length.
  final num? min;

  /// For [int] values it is treated as greater value, for [String] as maximum length.
  final num? max;

  /// The list of valid values.
  final Iterable<T>? list;

  /// The regular expression to which the field value must match.
  final String? regExp;

  /// Indicates whether the field can be omitted or its value can contains null.
  bool get isNotNull => !isNull;

  /// Returns the data type of this constraint.
  Type get dataType => T;

  /// Indicates whether the minumum value is set.
  bool get hasMin => min != null;

  /// Indicates whether the maxumum value is set.
  bool get hasMax => max != null;

  /// Indicates whether this constraint has a list.
  bool get hasList => list != null;

  /// Indicates whether this constraint has a regular expression.
  bool get hasRegExp => regExp != null;

  @override
  String toString() {
    final props = {
      if (isNull) 'nullable': false,
      if (hasMin) 'min': min,
      if (hasMax) 'max': max,
      if (hasList) 'list': list,
      if (hasRegExp) 'regexp': regExp,
    };
    return 'Constraint $props';
  }
}

/// The mixin injects the [Constraint] into [Enum] which describes the list of
/// object constraints.
mixin ConstrainedEnumMixin on Enum {
  /// Constraint data for this field.
  Constraint<dynamic> get data;
}

/// Describes a constraint violation. This object exposes the constraint
/// violation context as well as the message describing the violation.
class ConstraintViolation<T> {
  const ConstraintViolation(
    this.name,
    this.value, {
    this.message = '',
  });

  /// The name which value failing to pass the constraint.
  final String name;

  /// The value failing to pass the constraint.
  final T value;

  /// The interpolated error message for this constraint violation.
  final String message;

  @override
  String toString() {
    final props = {
      'name': name,
      'value': value,
    };
    return 'ConstraintViolation $props';
  }
}

/// Exception thrown by some [Validator] interface.
class ValidationException implements Exception {
  /// Creates an exception with message describing the reason.
  const ValidationException(this.message);

  /// The reason that causes this exception.
  final String message;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'ValidationException')}: $message';
}

// /// Mixes the validation possibilities.
// mixin ValidatorMixin<TIterable extends Iterable<TEntity>, TEntity, TResult>
//     on CrudRepository<TIterable, TEntity> {
//   /// Input data validator.
//   Validator get validator;

//   /// Validates the [item].
//   bool validate(TResult item) => validator.validate(item);
// }

/// The interface which must be implemented by object which needs to be validated.
///
/// The T is an [Enum] object which must implements [ConstrainedEnumMixin]
abstract interface class Constrained<T extends Enum> {
  /// The list of enumerated validation values.
  List<T> get constraints;
}

/// Base validator interface.
abstract class Validator<T> {
  /// Validates all constraints on [object].
  bool validate(T object);
}

class MapValidator<T extends ConstrainedEnumMixin>
    implements Validator<Map<String, dynamic>> {
  const MapValidator(this.constraints);

  /// The list of object constraints.
  final List<T> constraints;

  // @override
  @override
  bool validate(Map<String, dynamic> item) {
    final violations = <ConstraintViolation<dynamic>>[];

    try {
      // Validate for nullables
      for (final constraint in constraints) {
        if (constraint.data.isNotNull &&
            (!item.keys.contains(constraint.name) ||
                item[constraint.name] == null)) {
          violations.add(
            ConstraintViolation(constraint.name, item[constraint.name],
                message:
                    'The [${constraint.name}] cannot be ommitted or contain null.'),
          );
        }
      }

      for (final entry in item.entries) {
        final constraint = constraints.byName(entry.key);

        // Validate for data type
        if (constraint.data.isNotNull &&
            constraint.data.dataType != entry.value.runtimeType) {
          violations.add(ConstraintViolation(
            constraint.name,
            item[constraint.name],
            message:
                'The [${constraint.name}] expected [${constraint.data.dataType}] '
                'but [${entry.value.runtimeType}] is given.',
          ));
        }

        // Validate for min/max/length
        if (constraint.data.dataType is num) {
          if (constraint.data.hasMin) {
            // Valida for min value
            if (constraint.data.hasMin && entry.value < constraint.data.min!) {
              violations.add(ConstraintViolation(
                constraint.name,
                item[constraint.name],
                message:
                    'The [${constraint.name}] value cannot be smaller than '
                    '[${constraint.data.min}].',
              ));
            }
            if (constraint.data.hasMax && entry.value > constraint.data.max) {
              violations.add(ConstraintViolation(
                constraint.name,
                item[constraint.name],
                message:
                    'The [${constraint.name}] value cannot be greater than '
                    '[${constraint.data.max}]',
              ));
            }
          }
        } else if (constraint.data.dataType is String) {
          if (constraint.data.hasMin) {
            // Valida for min value
            if (constraint.data.hasMin &&
                (entry.value as String).length < constraint.data.min!) {
              violations.add(ConstraintViolation(
                constraint.name,
                item[constraint.name],
                message:
                    'The [${constraint.name}] length cannot be smaller than '
                    '[${constraint.data.min}].',
              ));
            }
            if (constraint.data.hasMax &&
                (entry.value as String).length > constraint.data.max!) {
              violations.add(ConstraintViolation(
                constraint.name,
                item[constraint.name],
                message:
                    'The [${constraint.name}] length cannot be greater than '
                    '[${constraint.data.max}]',
              ));
            }
          }
        }

        // Validate for list
        if (constraint.data.hasList) {
          if (!constraint.data.list!.contains(entry.value)) {
            violations.add(ConstraintViolation(
              constraint.name,
              item[constraint.name],
              message:
                  'The [${constraint.name}] value must be in list [${constraint.data.list}',
            ));
          }
        }

        // Validate for pattern
        if (constraint.data.hasRegExp) {
          if (!RegExp(constraint.data.regExp!).hasMatch(entry.value)) {
            violations.add(ConstraintViolation(
              constraint.name,
              item[constraint.name],
              message:
                  'The [${constraint.name}] value does not match the regular expression [${constraint.data.regExp}',
            ));
          }
        }
      }

      // Check found violations
      if (violations.isNotEmpty) {
        throw ValidationException(violations.toString());
      }
    } on ValidationException catch (e) {
      log(e.message, name: runtimeType.toString(), error: e);
      return false;
    }

    return true;
  }
}
