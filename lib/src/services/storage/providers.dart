import 'package:shared_preferences/shared_preferences.dart';

import '../../core/basic_types.dart';
import 'contracts.dart';

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage implements BaseStorage {
  const SharedPreferencesStorage._(this._sharedPreferences);

  static SharedPreferencesStorage? _instance;

  static SharedPreferencesStorage get instance {
    assert(
        _instance != null,
        'You forgot to call `SharedPreferencesStorage.init()` '
        'on app initialization');
    return _instance!;
  }

  /// Initializes the storage.
  static Future<SharedPreferencesStorage> init() async {
    _instance ??=
        SharedPreferencesStorage._(await SharedPreferences.getInstance());
    return _instance!;
  }

  final SharedPreferences _sharedPreferences;

  @override
  String? getItem(String key) {
    assert(key.isNotEmpty);
    return _sharedPreferences.getString(key);
  }

  @override
  void putItem(String key, String value) {
    assert(key.isNotEmpty);
    _sharedPreferences.setString(key, value);
  }

  @override
  void removeItem(String key) {
    assert(key.isNotEmpty);
    _sharedPreferences.remove(key);
  }

  @override
  void clear() {
    _sharedPreferences.clear();
  }

  @override
  List<String> get keys {
    return _sharedPreferences.getKeys().toList();
  }

  @override
  int get length => keys.length;
}

/// Creates a persistent key which stores its value in Shared Preferences
/// on Android or NSUserDefaults on iOS.
class SharedPreferencesStorageKey<T, V> extends BaseStorageKey<T, V> {
  SharedPreferencesStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? builder})
      : super(name, initialValue, SharedPreferencesStorage.instance,
            builder: builder);
}

/// Storage controller mixin allows to manipulate by priority of cache items.
mixin SharedPreferencesStorageMixin<T> on SharedPreferencesStorage {
  /// Contains all storage items.
  final Map<String, StorageItem<T>> _items = {};

  /// Returns list of storage items which will not be evicted after
  /// session close.
  List<StorageItem<T>> get persistentKeys => _items.values
      .where((item) => item.priority == StorageItemPriority.persistent)
      .toList();

  /// Returns list of storage items which will be evicted after
  /// session close.
  List<StorageItem<T>> get sessionKeys => _items.values
      .where((item) => item.priority == StorageItemPriority.session)
      .toList();

  /// Puts item into inner controller storage.
  void saveKey(StorageItem<T> item) {
    _items[item.key] = item;
  }

  /// Removes item from inner controller storage.
  void removeKey(StorageItem<T> item) {
    _items.remove(item);
  }

  /// Removes keys which are not marked as `not removable`.
  void removeSessionKeys();
}

/// Provides implementation of in-memory storage.
class MemoryStorage implements BaseStorage {
  factory MemoryStorage() => _instance;

  static final MemoryStorage _instance = MemoryStorage();

  /// Memory map.
  final Map<String, String> _storage = <String, String>{};

  @override
  String? getItem(String key) {
    assert(key.isNotEmpty);
    return _storage[key];
  }

  @override
  void putItem(String key, String value) {
    assert(key.isNotEmpty);
    _storage[key] = value;
  }

  @override
  void removeItem(String key) {
    assert(key.isNotEmpty);
    _storage.remove(key);
  }

  @override
  void clear() => _storage.clear();

  @override
  List<String> get keys => _storage.keys.toList();

  @override
  int get length => _storage.length;
}

/// Creates a memory storage key.
class MemoryStorageKey<T, V> extends BaseStorageKey<T, V> {
  MemoryStorageKey(String name, T initialValue,
      {ConvertibleBuilder<T, V>? builder})
      : super(name, initialValue, MemoryStorage(), builder: builder);
}
