import 'package:flutter/foundation.dart';

/// The primary purpose of Cache interface is to accept a key from the calling
/// library and return the associated object. It is also the primary
/// point of interaction with the entire cache collection. All configuration
/// and initialization of the pool is left up to an implementing library.
abstract class Cache<T extends Object> {
  /// Deletes all items in the cache pool.
  ///
  /// Returns `true` if the pool was successfully cleared. `false` if there was
  /// an error.
  bool clear();

  /// Confirms if the cache contains specified item with the [key].
  ///
  /// Returns `true` if item exists in the cache, `false` otherwise.
  bool containsKey(String key);

  /// Retrieves the value of the item from the cache associated with this
  /// object's [key].
  ///
  /// The value returned must be identical to the value originally stored
  /// by [put].
  T? get(String key);

  /// Invalidate the cache pool through removing all cache items, expecting
  /// all entries to be immediately invisible for subsequent lookups.
  bool invalidate([CacheInvalidateMethod method = CacheInvalidateMethod.purge]);

  /// Persists a cache item immediately.
  ///
  /// Return `true` if the item was successfully persisted. `false` if there was
  /// an error.
  bool put(
    String key,
    T value, {
    CacheItemPriority priority = CacheItemPriority.normal,
    Duration? absoluteExpiration,
    Duration? slidingExpiration,
  });
  //bool put(CacheItem<T> item);

  /// Removes the item with `key` from the cache pool.
  ///
  /// Returns `true` if the item was successfully removed. `false` if there was
  /// an error.
  ///
  /// Throws [ArgumentError] if the `key` string is not a legal value.
  bool remove(String key);
}

/// The famous cache invalidation methods.
enum CacheInvalidateMethod {
  /// The purge method removes cached content for a specific object, URL, or a
  /// set of URLs. It’s typically used when there is an update or change to the
  /// content and the cached version is no longer valid.
  purge,

  /// The refresh method retrieves requested content from the origin server,
  /// even if a cached version is available. When a refresh request is received,
  /// the cache updates the content with the latest version from the origin server,
  /// ensuring up-to-date information. Unlike a purge, a refresh request does not
  /// remove the existing cached content but updates it with the most recent version.
  refresh,

  /// The ban method invalidates cached content based on specific criteria, such as
  /// a URL pattern or header. Upon receiving a ban request, any cached content
  /// matching the specified criteria is immediately removed. Subsequent requests
  /// for the content will be served directly from the origin server, ensuring that
  /// users receive the most recent and relevant information.
  ban,

  /// This method involves setting a time-to-live value for cached content, after
  /// which the content is considered stale and must be refreshed. When a request
  /// is received for the content, the cache checks the time-to-live value and
  /// serves the cached content only if the value hasn’t expired. If the value
  /// has expired, the cache fetches the latest version of the content from the
  /// origin server and caches it.
  ttlExpiration,

  /// This method is used in web browsers and CDNs to serve stale content from
  /// the cache while the content is being updated in the background. When a request
  /// is received for a piece of content, the cached version is immediately served
  /// to the user, and an asynchronous request is made to the origin server to fetch
  /// the latest version of the content. Once the latest version is available, the
  /// cached version is updated.
  staleWhileRevalidate,
}

/// Specifies the relative priority of items stored in the Cache object.
enum CacheItemPriority {
  /// Cache items with this priority level are the most likely to be deleted from
  /// the cache as the server frees system memory.
  low,

  /// Cache items with this priority level are more likely to be deleted from the
  /// cache as the server frees system memory than items assigned a Normal priority.
  belowNormal,

  /// Cache items with this priority level are likely to be deleted from the cache
  /// as the server frees system memory only after those items with [low] or [belowNormal]
  /// priority. This is the default.
  normal,

  /// Cache items with this priority level are less likely to be deleted as the server
  /// frees system memory than those assigned a [normal] priority.
  aboveNormal,

  /// Cache items with this priority level are the least likely to be deleted from the
  /// cache as the server frees system memory.
  high,

  /// The cache items with this priority level will not be automatically deleted from
  /// the cache as the server frees system memory. However, items with this priority
  /// level are removed along with other items according to the item's absolute or
  /// sliding expiration time.
  notRemovable,
}

/// Represents a set of eviction and expiration details for a specific
/// cache entry.
@immutable
class CacheItemPolicy {
  /// Initializes a new instance of the CacheItemPolicy class.
  const CacheItemPolicy({
    this.priority = CacheItemPriority.normal,
    this.absoluteExpiration,
    this.slidingExpiration,
    this.onRemove,
  }) : assert((absoluteExpiration == null) || (slidingExpiration == null),
            'Either [absoluteExpiration] or [slidingExpiration] can be initialized.');

  /// Priority setting that is used to determine whether to evict a
  /// cache entry.
  final CacheItemPriority priority;

  /// The period of time that must pass before a cache entry is delete.
  ///
  /// The default value is `null`, meaning that the entry does not expire.
  ///
  /// If you are using absolute expiration, the [slidingExpiration]
  /// parameter must be `null'`
  final Duration? absoluteExpiration;

  /// Indicates whether the cache entry should be deleted if it has not
  /// been accessed in a given span of time.
  ///
  /// The default is `null`, meaning that the item should not be expired
  /// based on a time span.
  ///
  /// If you are using sliding expiration, the [absoluteExpiration] parameter
  /// must be `null`.
  final Duration? slidingExpiration;

  /// Gets or sets a reference to a VoidCallback that is called after
  /// an entry is removed from the cache.
  final VoidCallback? onRemove;

  /// Indicates whether this policy is expired due to [absoluteExpiration].
  bool get isExpiredAbsolutely => absoluteExpiration != null;

  /// Indicates whether this policy is expired due to [slidingExpiration]..
  bool get isExpiredSlidingly => slidingExpiration != null;

  @override
  int get hashCode =>
      Object.hash(priority, absoluteExpiration, slidingExpiration, onRemove);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheItemPolicy &&
          priority == other.priority &&
          absoluteExpiration == other.absoluteExpiration &&
          slidingExpiration == other.slidingExpiration &&
          onRemove == other.onRemove;

  @override
  String toString() {
    final props = {
      'priority': priority.name,
      if (isExpiredAbsolutely) 'absolute': absoluteExpiration,
      if (isExpiredSlidingly) 'sliding': slidingExpiration,
    };
    return 'CacheItemPolicy $props';
  }
}

/// Represents an individual cache entry in the cache.
@immutable
class CacheItem<T extends Object> {
  /// Initializes a new [CacheItem] instance using the specified
  /// [key] and a [value] of the cache entry.
  const CacheItem(
    this.key,
    this.value, {
    this.policy = const CacheItemPolicy(),
  });

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
