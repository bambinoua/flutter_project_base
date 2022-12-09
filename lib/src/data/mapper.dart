// ignore_for_file: strict_raw_type

import '../core/basic_types.dart';
import '../core/domain_driven_design.dart';

/// Declares an interface for bidirectional mapping of [Entity] to [DTO]
/// and vise versa.
abstract class EntityMapper<T extends Identity, S extends DTO>
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

extension IdentityMapper<T> on Identity<T> {
  TTarget map<TTarget>(ConvertibleBuilder<TTarget, Identity<T>> mapper) =>
      mapper(this);
}

extension DTOMapper on DTO {
  TTarget map<TTarget>(ConvertibleBuilder<TTarget, DTO> mapper) => mapper(this);
}

extension JsonMapper on JsonMap {
  TTarget map<TTarget>(ConvertibleBuilder<TTarget, JsonMap> mapper) =>
      mapper(this);
}

extension IdentityIterableMapper<T> on Iterable<Identity<T>> {
  List<TTarget> map<TTarget>(Iterable<Identity<T>> source,
          ConvertibleBuilder<TTarget, Identity<T>> mapper) =>
      source.map((item) => item.map(mapper)).toList();
}

extension DTOIterableMapper<T> on Iterable<DTO> {
  List<TTarget> map<TTarget>(
          Iterable<DTO> source, ConvertibleBuilder<TTarget, DTO> mapper) =>
      source.map((item) => item.map(mapper)).toList();
}

extension JsonMapIterableMapper<T> on Iterable<JsonMap> {
  List<TTarget> map<TTarget>(Iterable<JsonMap> source,
          ConvertibleBuilder<TTarget, JsonMap> mapper) =>
      source.map((item) => mapper(item)).toList();
}
