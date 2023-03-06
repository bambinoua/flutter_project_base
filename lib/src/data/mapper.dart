// ignore_for_file: strict_raw_type

import '../core/domain_driven_design.dart';

/// Provides a mapping interface for transformation [TSource] to [TTarget].
abstract class Mapper<TSource, TTarget> {
  /// Map `value` to instance of [TTarget].
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
