import 'package:flutter/foundation.dart';

/// Specifies a priority setting that is used to decide whether
/// to evict a cache entry.
enum CacheItemPriority {
  /// Indicates that there is no priority for removing the cache entry.
  standard,

  ///Indicates that a cache entry should never be removed from the cache.
  notRemovable
}

/// Represents a set of eviction and expiration details for a specific
/// cache entry.
@immutable
class CacheItemPolicy {
  /// Initializes a new instance of the CacheItemPolicy class.
  const CacheItemPolicy({
    this.priority = CacheItemPriority.standard,
    this.expiredAt,
    this.expiredAfter,
    this.onRemove,
  }) : assert(expiredAt == null || expiredAfter == null,
            'Either `expiredAt` or `expiredAfter` can be initialized.');

  /// Priority setting that is used to determine whether to evict a
  /// cache entry.
  final CacheItemPriority priority;

  /// Value that indicates whether a cache entry should be evicted at
  /// a specified point in time.
  final DateTime? expiredAt;

  /// Gets or sets a value that indicates whether a cache entry should be
  /// evicted if it has not been accessed in a given span of time.
  final Duration? expiredAfter;

  /// Gets or sets a reference to a VoidCallback that is called after
  /// an entry is removed from the cache.
  final VoidCallback? onRemove;

  /// Indicates whether this policy is *expired at*.
  bool get isExpiredAt => expiredAt != null;

  /// Indicates whether this policy is *expired after*.
  bool get isExpiredAfter => expiredAfter != null;

  @override
  int get hashCode => Object.hash(priority, expiredAt, expiredAfter, onRemove);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheItemPolicy &&
          priority == other.priority &&
          expiredAt == other.expiredAt &&
          expiredAfter == other.expiredAfter &&
          onRemove == other.onRemove;

  @override
  String toString() {
    final props = {
      'priority': priority.name,
      if (isExpiredAt) 'expiredAt': expiredAt,
      if (isExpiredAfter) 'expiredAfter': expiredAfter,
    };
    return 'CacheItemPolicy $props';
  }
}

/// Represents an individual cache entry in the cache.
@immutable
class CacheItem<T> {
  /// Initializes a new CacheItem instance using the specified
  /// `key` and a `value` of the cache entry.
  const CacheItem({
    required this.key,
    required this.value,
    required this.policy,
  });

  /// Initializes a `standard` CacheItem instance using the specified
  /// `key` and a `value` of the cache entry with no expiration.
  const CacheItem.standard({
    required String key,
    required T value,
  }) : this(
          key: key,
          value: value,
          policy: const CacheItemPolicy(),
        );

  /// Gets or sets a unique identifier for a CacheItem instance.
  final String key;

  ///Gets or sets the data for a CacheItem instance.
  final T value;

  /// Gets or sets a cache item policy.
  final CacheItemPolicy policy;

  @override
  int get hashCode => Object.hash(key, value, policy);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheItem &&
          key == other.key &&
          value == other.value &&
          policy == other.policy;

  @override
  String toString() {
    final props = {
      'key': key,
      'value': value,
      'policy': policy,
    };
    return 'CacheItem $props';
  }
}

/// The primary purpose of Cache interface is to accept a key from the calling
/// library and return the associated [CacheItem] object. It is also the primary
/// point of interaction with the entire cache collection. All configuration
/// and initialization of the pool is left up to an implementing library.
abstract class Cache {
  /// Deletes all items in the cache pool.
  ///
  /// Returns `true` if the pool was successfully cleared. `false` if there was
  /// an error.
  bool clear();

  /// Removes the item with `key` from the cache pool.
  ///
  /// Returns `true` if the item was successfully removed. `false` if there was
  /// an error.
  ///
  /// Throws [ArgumentError] if the `key` string is not a legal value.
  bool deleteItem(String key);

  /// Retrieves the value of the item from the cache associated with this
  /// object's key.
  ///
  /// The value returned must be identical to the value originally stored
  /// by `putItem()`.
  CacheItem<T> getItem<T>(String key);

  /// Confirms if the cache contains specified item with the `key`.
  ///
  /// Returns `true` if item exists in the cache, `false` otherwise.
  ///
  /// Throws [ArgumentError] if the `key` string is not a legal value.
  bool hasItem(String key);

  /// Invalidate the cache pool through removing all cache items, expecting
  /// all entries to be immediately invisible for subsequent lookups.
  bool invalidate();

  /// Persists a cache item immediately.
  ///
  /// Return `true` if the item was successfully persisted. `false` if there was
  /// an error.
  bool putItem<T>(CacheItem<T> item);
}
