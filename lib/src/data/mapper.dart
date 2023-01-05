// ignore_for_file: strict_raw_type

import '../core/basic_types.dart';
import '../core/domain_driven_design.dart';

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class BaseMapper<T extends Entity, S extends DTO>
    implements DomainService {
  /// Maps the `entity` to [DTO].
  S mapEntityToDTO(T entity);

  /// Maps the `dto` to [Entity].
  T mapDtoToEntity(S dto);

  /// Maps the `map` to [DTO].
  S mapJsonToDTO(JsonMap map);

  /// Converts list of entities to list of DTOs.
  List<S> mapEntitiesToDTOs(Iterable<T> entities) =>
      entities.map((e) => mapEntityToDTO(e)).toList();

  /// Converts list of DTOs to list of entities.
  List<T> mapDTOsToEntities(Iterable<S> dtos) =>
      dtos.map((o) => mapDtoToEntity(o)).toList();
}

extension EntityToEntityMapper<TGuid> on Entity<TGuid> {
  TTarget map<TTarget extends Entity<TGuid>>(
          ConvertibleBuilder<TTarget, Entity<TGuid>> mapper) =>
      mapper(this);
}

extension EntityToDtoMapper<TGuid> on Entity<TGuid> {
  TTarget map<TTarget extends DTO>(
          ConvertibleBuilder<TTarget, Entity<TGuid>> mapper) =>
      mapper(this);
}

extension DtoToEntityMapper<TGuid> on DTO {
  TTarget map<TTarget extends Entity<TGuid>>(
          ConvertibleBuilder<TTarget, DTO> mapper) =>
      mapper(this);
}

extension JsonToDtoMapper on JsonMap {
  TTarget map<TTarget extends DTO>(
          ConvertibleBuilder<TTarget, JsonMap> mapper) =>
      mapper(this);
}
