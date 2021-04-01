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
    var testObj = Test(Date.today(), TestEnum.two, 'Name');
    var serialized = json.encode(testObj);
    //! Before start this test you should to change the value of datetime to current date.
    expect(serialized,
        '{"datetime":"2021-04-01T00:00:00.000","enumeration":1,"name":"Name"}');
  });

  test('date', () {
    var today = Date.today();
    var now = DateTime.now();
    expect(today.year, now.year);
    expect(today.month, now.month);
    expect(today.day, now.day);
    expect(today.hour, 0);
    expect(today.minute, 0);
    expect(today.second, 0);
    expect(today.millisecond, 0);
    expect(today.microsecond, 0);
  });

  test('date.today', () {
    var today = Date.today();
    var now = DateTime.now();
    expect(today, DateTime(now.year, now.month, now.day));
  });

  test('date.isToday', () {
    var today1 = Date.today();
    var today2 = Date.today();
    expect(today1 == today2, true);
  });
}
