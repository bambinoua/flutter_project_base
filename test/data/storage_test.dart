import 'package:flutter_project_base/src/services/storage/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Memory storage read and write', () {
    final memory = MemoryStorage();
    const key = 'test.key';

    var value = memory.get(key) ?? '1';
    expect(value.runtimeType, String);
    expect(value, '1');

    value = '2';
    memory.put(key, value);

    value = memory.get(key)!;
    expect(value.runtimeType, String);
    expect(value, '2');
  });
}
