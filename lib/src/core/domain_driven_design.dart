import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'basic_types.dart';
import 'contracts.dart';

/// Domain Services (or just Services in DDD) is used to perform domain
/// operations and business rules. In his DDD book, Eric Evans describes a good
/// Service in three characteristics:
///   * The operation relates to a domain concept that is not a natural part of
///     an Entity or Value Object.
///   * The interface is defined in terms of other elements of the domain model.
///   * The operation is stateless.
///
/// Unlike Application Services which get/return Data Transfer Objects, a Domain
/// Service gets/returns domain objects (like entities or value types).
///
/// A Domain Service can be used by Application Services and other Domain Services,
/// but not directly by the presentation layer (application services are for that).
abstract class DomainService {}

/// Application Services are used to expose domain logic to the presentation
/// layer. An Application Service is called from the presentation layer using
/// a DTO (Data Transfer Object) as a parameter. It also uses domain objects
/// to perform some specific business logic and returns a DTO back to the
/// presentation layer. Thus, the presentation layer is completely isolated
/// from Domain layer.
///
/// In an ideally layered application, the presentation layer never directly
/// works with domain objects.
abstract class ApplicationService {}

/// These are services that typically talk to external resources and are not
/// part of the primary problem domain. The common examples that I see for
/// this are emailing and logging.
abstract class InfrastructureService {}

/// Defines an entity with a single primary key with `id` property.
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

  /// Cretes an instance of entity object from `dto`.
  EntityObject.fromDTO(DTO dto) : _id = dto.id;

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

/// Defines an aggregate root with a single primary key with `id` property.
///
/// Aggregate is a pattern in Domain-Driven Design. A DDD aggregate is a
/// cluster of domain objects that can be treated as a single unit. An
/// example may be an order and its line-items, these will be separate
/// objects, but it's useful to treat the order (together with its line
/// items) as a single aggregate
abstract class AggregateRoot extends EntityObject {}

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
