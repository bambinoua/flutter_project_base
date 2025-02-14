import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/basic_types.dart';
import 'contracts.dart';

/// Provides implementation of [SharedPreferences] storage.
///
/// All data is stored as a [String].
final class SharedPreferencesStorage extends PreferenceStorage {
  const SharedPreferencesStorage._(this._sharedPreferences);

  static SharedPreferencesStorage? _instance;

  /// Returns this singleton.
  static SharedPreferencesStorage get instance {
    assert(
        _instance != null,
        'You forgot to call `SharedPreferencesStorage.init()` '
        'on app initialization');
    return _instance!;
  }

  /// Initializes this storage.
  static Future<SharedPreferencesStorage> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return _instance ??= SharedPreferencesStorage._(sharedPreferences);
  }

  final SharedPreferences _sharedPreferences;

  @override
  String? get(String key) {
    assert(key.isNotEmpty);
    return _sharedPreferences.getString(key);
  }

  @override
  void put(String key, String value) {
    assert(key.isNotEmpty);
    _sharedPreferences.setString(key, value);
  }

  @override
  void remove(String key) {
    assert(key.isNotEmpty);
    _sharedPreferences.remove(key);
  }

  @override
  void clear() => _sharedPreferences.clear();

  @override
  List<String> get keys => _sharedPreferences.getKeys().toList();

  @override
  int get length => keys.length;
}

/// Provides implementation of [Hive] storage.
///
/// All data is stored as a [String].
final class HivePreferencesStorage extends PreferenceStorage {
  const HivePreferencesStorage._(this._box);

  static late final HivePreferencesStorage? _instance;

  /// Returns this singleton.
  static HivePreferencesStorage get instance {
    assert(_instance != null,
        'You forgot to call `HiveStorage.init()` on app initialization');
    return _instance!;
  }

  /// Initializes this storage.
  static Future<HivePreferencesStorage> init(String path, String name,
      {HiveCipher? encryptionCipher}) async {
    assert(name.isNotEmpty);
    Hive.init(path);
    final box = await Hive.openBox<String>(name,
        collection: 'storage', encryptionCipher: encryptionCipher);
    return _instance ??= HivePreferencesStorage._(box);
  }

  /// The interval hive box.
  final Box<String> _box;

  @override
  String? get(String key) {
    assert(key.isNotEmpty);
    return _box.get(key);
  }

  @override
  void put(String key, String value) {
    assert(key.isNotEmpty);
    _box.put(key, value);
  }

  @override
  void remove(String key) {
    assert(key.isNotEmpty);
    _box.delete(key);
  }

  @override
  void clear() => _box.clear();

  @override
  List<String> get keys => _box.keys.toList().cast<String>();

  @override
  int get length => _box.length;
}

/// Creates a value which is stored in Shared Preferences on Android or NSUserDefaults on iOS.
final class SharedPreferencesValue<T, S> extends BasePreferenceValue<T, S> {
  SharedPreferencesValue(String key, T initialValue,
      {ConvertibleBuilder<T, S>? valueBuilder})
      : super(key, initialValue, SharedPreferencesStorage.instance,
            valueBuilder: valueBuilder);
}

/// Creates a value which is stored in [Hive] database.
final class HiveStorableValue<T, S> extends BasePreferenceValue<T, S> {
  HiveStorableValue(String key, T initialValue,
      {ConvertibleBuilder<T, S>? valueBuilder})
      : super(key, initialValue, HivePreferencesStorage.instance,
            valueBuilder: valueBuilder);
}

/// Storage controller mixin allows to manipulate by priority of cache items.
base mixin SharedPreferencesStorageMixin<T> on SharedPreferencesStorage {
  /// Contains all storage items.
  final Map<String, StorageItem<T>> _items = {};

  /// Returns list of storage items which will not be evicted after
  /// session close.
  List<StorageItem<T>> get persistentKeys => _items.values
      .where((item) => item.priority == StoragePriority.persistent)
      .toList();

  /// Returns list of storage items which will be evicted after
  /// session close.
  List<StorageItem<T>> get sessionKeys => _items.values
      .where((item) => item.priority == StoragePriority.sessional)
      .toList();

  /// Puts item into inner controller storage.
  void saveKey(StorageItem<T> item) {
    _items[item.key] = item;
  }

  /// Removes item from inner controller storage.
  void removeKey(StorageItem<T> item) {
    _items.remove(item.key);
  }

  /// Removes keys which are not marked as `not removable`.
  void removeSessionKeys();
}
