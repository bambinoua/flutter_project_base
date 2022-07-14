import 'package:shared_preferences/shared_preferences.dart';

import 'contracts.dart';

/// Provides implementation of [SharedPreferences] storage.
class SharedPreferencesStorage implements Storage {
  const SharedPreferencesStorage._();

  static late SharedPreferences _sharedPreferences;
  static SharedPreferencesStorage? _instance;

  /// Creates an instance of storage.
  static Future<SharedPreferencesStorage> create() async {
    if (_instance == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _instance = const SharedPreferencesStorage._();
    }
    return _instance!;
  }

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

/// Provides implementation of in-memory storage.
class MemoryStorage implements Storage {
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

/// Storage controller mixin allows to manipulate by priority of cache items.
mixin SharedPreferencesStorageMixin<T> on SharedPreferencesStorage {
  /// Contains all storage items.
  final Map<String, StorageItem<T>> _items = {};

  /// Returns list of storage items which will not be evicted after
  /// session close.
  List<StorageItem<T>> get persistentKeys => _items.values
      .where((item) => item.priority == StoragePriority.persistent)
      .toList();

  /// Returns list of storage items which will be evicted after
  /// session close.
  List<StorageItem> get sessionKeys => _items.values
      .where((item) => item.priority == StoragePriority.session)
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
