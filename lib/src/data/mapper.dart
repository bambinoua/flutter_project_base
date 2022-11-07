import '../core/basic_types.dart';
import '../core/domain_driven_design.dart';

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends Entity, S extends DTO>
    implements DomainService {
  /// Maps the `entity` to [DTO].
  S toDTO(T entity);

  /// Maps the `dto` to [Entity].
  T toEntity(S dto);

  /// Maps the `map` to [DTO].
  S toDTOFromMap(JsonMap map);

  /// Converts list of entities to list of DTOs.
  List<S> toListOfDTOs(Iterable<T> entities) =>
      entities.map((e) => toDTO(e)).toList();

  /// Converts list of DTOs to list of entities.
  List<T> toListOfEntities(Iterable<S> dtos) =>
      dtos.map((o) => toEntity(o)).toList();
}
