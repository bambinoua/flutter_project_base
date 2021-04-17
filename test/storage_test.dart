import 'package:flutter_project_base/src/storage/contracts.dart';
import 'package:flutter_project_base/src/storage/providers.dart';
import 'package:flutter_test/flutter_test.dart';

Type typeOf<T>() => T;

void main() {
  test('memory_storage_test', () {
    final memory = MemoryStorage();
    const key = 'test.key';

    final item1 =
        memory.getItem<int>(key) ?? StorageItem<int>(key: key, value: 1);
    expect(item1.runtimeType, typeOf<StorageItem<int>>());
    expect(item1.key, key);
    expect(item1.value, 1);

    memory.putItem(item1.copyWith(value: 2));

    final item2 = memory.getItem<int>(key);
    expect(item2.runtimeType, typeOf<StorageItem<int>>());
    expect(item2!.key, key);
    expect(item2.value, 2);
  });
}
