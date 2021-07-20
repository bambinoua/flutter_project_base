import 'package:flutter_project_base/src/storage/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('memory_storage_test', () {
    final memory = MemoryStorage();
    const key = 'test.key';

    var value = memory.getItem(key) ?? '1';
    expect(value.runtimeType, String);
    expect(value, '1');

    value = '2';
    memory.putItem(key, value);

    value = memory.getItem(key)!;
    expect(value.runtimeType, String);
    expect(value, '2');
  });
}
