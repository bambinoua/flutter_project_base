// ignore_for_file: strict_raw_type

import '../core/basic_types.dart';
import '../core/domain_driven_design.dart';

/// Provides a callback for object mapping.
typedef MapCallback<TSource, TTarget> = TTarget Function(TSource value);

/// Provides a genera mapping interface which maps instane of [TSource] to [TTarget].
abstract class Mapper<TSource, TTarget> {
  TTarget map(TSource value);
}

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class EntityDtoMapper<TEntity extends Entity, TDto extends DTO> {
  /// Maps the `entity` to [DTO].
  TDto mapEntityToDTO(TEntity entity);

  /// Maps the `dto` to [Entity].
  TEntity mapDTOToEntity(TDto dto);

  /// Converts list of entities to list of DTOs.
  List<TDto> mapEntitiesToDTOs(Iterable<TEntity> entities) =>
      entities.map((e) => mapEntityToDTO(e)).toList();

  /// Converts list of DTOs to list of entities.
  List<TEntity> mapDTOsToEntities(Iterable<TDto> dtos) =>
      dtos.map((o) => mapDTOToEntity(o)).toList();
}

extension EntityToEntityMapper<TId> on Entity<TId> {
  TTarget map<TTarget extends Entity<TId>>(
          ConvertibleBuilder<TTarget, Entity<TId>> mapper) =>
      mapper(this);
}

extension EntityToDtoMapper<TId> on Entity<TId> {
  TTarget map<TTarget extends DTO>(
          ConvertibleBuilder<TTarget, Entity<TId>> mapper) =>
      mapper(this);
}

extension DtoToEntityMapper<TId> on DTO {
  TTarget map<TTarget extends Entity<TId>>(
          ConvertibleBuilder<TTarget, DTO> mapper) =>
      mapper(this);
}

extension JsonToDtoMapper on JsonMap {
  TTarget map<TTarget extends DTO>(
          ConvertibleBuilder<TTarget, JsonMap> mapper) =>
      mapper(this);
}
