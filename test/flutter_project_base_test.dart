import 'dart:convert';

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';

enum TestEnum { one, two }

class Test extends DefaultSerializable {
  Test(this.datetime, this.enumeration, this.name);
  final DateTime datetime;
  final TestEnum enumeration;
  final String name;

  @override
  Map<String, dynamic> asMap() {
    return {
      'datetime': datetime,
      'enumeration': enumeration,
      'name': name,
    };
  }
}

void main() {
  test('default_serializable', () {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var testObj = Test(today, TestEnum.one, 'Name');
    var serialized = json.encode(testObj);
    expect(serialized,
        '{"datetime":"2021-03-31T00:00:00.000","enumeration":0,"name":"Name"}');
  });
}
