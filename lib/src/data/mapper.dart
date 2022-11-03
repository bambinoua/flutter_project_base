import '../core/domain_driven_design.dart';

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends Entity, S extends DTO>
    implements DomainService {
  /// Maps the `entity` to [DTO].
  S toDTO(T entity);

  /// Maps the `dto` to [Entity].
  T toEntity(S dto);
}
