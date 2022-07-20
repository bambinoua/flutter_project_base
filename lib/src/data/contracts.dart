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
///
/// The Presentation Layer calls an Application Service method with a
/// Data Transfer Object (DTO). The application service then uses these
/// domain objects to perform some specific business logic, and then
/// finally returns a DTO back to the presentation layer. Thus, the
/// Presentation layer is completely isolated from the Domain layer.
/// In an ideally layered application, the presentation layer never
/// works with domain objects, (Repositories, or Entities...).
abstract class DTO<T> extends Serializable<T> {}

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
abstract class ValueObject<T> extends Serializable<T>
    with EquatableMixin
    implements Cloneable<T> {}

/// Entities are one of the core concepts of DDD (Domain Driven Design).
/// An object that is not fundamentally defined by its attributes, but
/// rather by a thread of continuity and identity. Essentially, entities
/// have Id's and are stored in a database. An entity is generally mapped
/// to a table in a relational database.
abstract class EntityObject<T> extends DomainObject<T> {
  /// Cretes an instance of reference entity.
  EntityObject({this.id = 0}) : assert(id >= 0);

  /// Cretes an instance of entity object from `map`.
  EntityObject.fromJson(Json map) : id = map['id'];

  /// Cretes an instance of entity object from `other`.
  EntityObject.from(EntityObject<T> other) : id = other.id;

  /// Entity unique identifier.
  final int id;

  /// Constructs the instance of type T.
  ConvertibleBuilder<T, Json> get builder;

  /// Returns `true` if entity is transient, i.e. new.
  bool get isTransient => id == 0;
}
