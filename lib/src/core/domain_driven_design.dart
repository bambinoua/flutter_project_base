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
abstract class InfrastructureService implements Disposable {}

/// Defines an entity with a single primary key with `id` property.
///
/// Primary key types can be `int` or `String` (GUID indeed),
abstract class Identity<T> {
  /// Default name of identity property.
  static const String propertyName = 'id';

  /// Unique domain entity identifier.
  ///
  /// T is usually `int` or `GuidString`. Can be null. If T is `int` then it
  /// cannot be negative.
  T? get id;
}

/// Interface for generate identity.
abstract class IdentityGenerator<T> implements DomainService {
  /// Generates a new identity.
  T generate();
}

/// Entities are one of the core concepts of DDD (Domain Driven Design).
/// An object that is not fundamentally defined by its attributes, but
/// rather by a thread of continuity and identity. Essentially, entities
/// have Id's and are stored in a database. An entity is generally mapped
/// to a table in a relational database.
///
//! Use [EquatableMixin] instead extending of [Equatable] avoids annotating
//! inheritated objects as @immutable
abstract class Entity<T> with EquatableMixin, Identity<T> {
  /// Creates an instance of reference entity.
  Entity({this.id});

  /// Entity unique identifier.
  @override
  T? id;

  /// Returns `true` if entity is transient, i.e. new.
  bool get isTransient => id == null;

  @override
  List<Object?> get props => [id];
}

/// Meta Entity allows to add metadata about an entity, stored in a
/// dedicated entity (meta_entity). This is useful when you want to avoid
/// storing this information as a content entity field and clutter the content
/// entity with data that is not part of the content but is metadata (data
/// about other data).
class MetaEntity {
  const MetaEntity(
    this.name,
    this.namePlural,
  );

  final String name;
  final String namePlural;
}

/// Defines an aggregate root with a single primary key with `id` property.
///
/// Aggregate is a pattern in Domain-Driven Design. A DDD aggregate is a
/// cluster of domain objects that can be treated as a single unit. An
/// example may be an order and its line-items, these will be separate
/// objects, but it's useful to treat the order (together with its line
/// items) as a single aggregate
abstract class AggregateRoot<T> extends Entity<T> {
  AggregateRoot({super.id});
}

/// An object that represents a descriptive aspect of the domain with no
/// conceptual identity is called a VALUE OBJECT
///
/// [Entity]s have identities (Id), Value Objects do not. If the
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
@immutable
abstract class DTO implements Serializable {
  /// Creates an instance of [DTO].
  const DTO();

  /// Creates an instance of input [DTO] from the `map`.
  const DTO.fromJson(JsonMap map);

  @override
  JsonMap toJson() => const {};
}

/// An prototype of callback for specification predicate.
typedef SpecificationPredicate<T> = bool Function(T value);

/// Provides an interface for inmplementation of Specification design pattern.
@immutable
abstract class Specification<T> {
  const Specification._();

  /// Whether `value` is satisfied to this criteria.
  bool isSatisfied(T value);

  /// Whether `value` is not satisfied to this criteria.
  bool isNotSatisfied(T value) => !isSatisfied(value);

  factory Specification(SpecificationPredicate<T> predicate) =>
      _Specification(predicate);

  factory Specification.and(SpecificationPredicate<T> leftPredicate,
          SpecificationPredicate<T> rightPredicate) =>
      AndSpecification.predicatable(leftPredicate, rightPredicate);

  factory Specification.or(SpecificationPredicate<T> leftPredicate,
          SpecificationPredicate<T> rightPredicate) =>
      OrSpecification.predictable(leftPredicate, rightPredicate);
}

/// Base implementation of [Specification] interface.
class _Specification<T> extends Specification<T> {
  const _Specification(this._predicate) : super._();

  final SpecificationPredicate<T> _predicate;

  @override
  bool isSatisfied(T value) => _predicate(value);
}

/// Provides AND boolean operation on [Specification] interfaces.
class AndSpecification<T> extends Specification<T> {
  const AndSpecification(this.left, this.right) : super._();

  AndSpecification.predicatable(
    SpecificationPredicate<T> leftPredicate,
    SpecificationPredicate<T> rightPredicate,
  )   : left = _Specification<T>(leftPredicate),
        right = _Specification<T>(rightPredicate),
        super._();

  /// The left [Specification] operand to be ANDed.
  final Specification<T> left;

  /// The right [Specification] operand to be ANDed.
  final Specification<T> right;

  @override
  bool isSatisfied(T value) =>
      left.isSatisfied(value) && right.isSatisfied(value);
}

/// Provides OR boolean operation on [Specification] interfaces.
class OrSpecification<T> extends Specification<T> {
  const OrSpecification(this.left, this.right) : super._();

  OrSpecification.predictable(
    SpecificationPredicate<T> leftPredicate,
    SpecificationPredicate<T> rightPredicate,
  )   : left = _Specification<T>(leftPredicate),
        right = _Specification<T>(rightPredicate),
        super._();

  /// The left [Specification] operand to be ORed.
  final Specification<T> left;

  /// The right [Specification] operand to be ORed.
  final Specification<T> right;

  @override
  bool isSatisfied(T value) =>
      left.isSatisfied(value) || right.isSatisfied(value);
}

extension SpecificationExtensions<T> on Specification<T> {
  /// Executes boolean AND operation with other [Specification].
  Specification<T> and(Specification<T> specification) =>
      AndSpecification(this, specification);

  /// Executes boolean OR operation with other [Specification].
  Specification<T> or(Specification<T> specification) =>
      OrSpecification(this, specification);

  /// Executes boolean AND operation with other [Specification].
  Specification<T> predictableAnd(SpecificationPredicate<T> predicate) =>
      AndSpecification(this, Specification(predicate));

  /// Executes boolean OR operation with other [Specification].
  Specification<T> predictableOr(SpecificationPredicate<T> predicate) =>
      OrSpecification(this, Specification(predicate));
}
