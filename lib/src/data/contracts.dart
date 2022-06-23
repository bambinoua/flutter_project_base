// Domain object.
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../core/basic_types.dart';
import '../core/contracts.dart';

/// Entities are one of the core concepts of DDD (Domain Driven Design).
/// It is an object that is not fundamentally defined by its attributes,
/// but rather by a thread of continuity and identity.
abstract class DomainObject<T> extends Serializable<T> {}

/// Data Transfer Objects are used to transfer data between
/// the Application Layer and the Presentation Layer.
abstract class DTO<T> extends Serializable<T> {}

/// An object that represents a descriptive aspect of the domain with no
/// conceptual identity is called a VALUE OBJECT
@immutable
abstract class ValueObject<T> extends Serializable
    with EquatableMixin
    implements Cloneable<T> {}

/// Base class for app entity.
abstract class EntityObject<T> extends DomainObject<T> {
  /// Cretes an instance of reference entity.
  EntityObject({this.id = 0}) : assert(id >= 0);

  /// Cretes an instance of entity object from `map`.
  EntityObject.fromJson(Json map) : id = map['id'];

  /// Cretes an instance of entity object from `other`.
  EntityObject.from(EntityObject other) : id = other.id;

  /// Entity unique identifier.
  final int id;

  /// Constructs the instance of type T.
  ConvertibleBuilder<T, Json> get builder;

  /// Returns `true` if entity is new.
  bool get isNew => id == 0;
}
