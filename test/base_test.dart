import 'dart:convert';

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';

enum TestEnum { one, two }

class TestObject extends JsonSerializable {
  TestObject(
    this.datetime,
    this.enumeration,
    this.name,
  );

  final DateTime datetime;
  final TestEnum enumeration;
  final String name;

  @override
  Map<String, dynamic> asMap() => {
        'datetime': datetime,
        'enumeration': enumeration,
        'name': name,
      };

  @override
  List<Object?> get props => [];
}

void main() {
  test('json_serializable', () {
    final testObj = TestObject(Date.today(), TestEnum.two, 'Name');
    final serializedTestObj = json.encode(testObj);
    print(serializedTestObj);
    final now = DateTime.now();
    var todayString = [
      now.year.toString(),
      now.month.toString().padLeft(2, '0'),
      now.day.toString().padLeft(2, '0')
    ].join('-');

    expect(serializedTestObj,
        '{"datetime":"${todayString}T00:00:00.000","enumeration":1,"name":"Name"}');
  });
}
