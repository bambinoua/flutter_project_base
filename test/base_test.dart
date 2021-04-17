import 'dart:convert';

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';

enum TestEnum { one, two }

class Test extends JsonSerializable {
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
  test('jsonserializable', () {
    var testObj = Test(Date.today(), TestEnum.two, 'Name');
    var serialized = json.encode(testObj);
    var now = DateTime.now();
    var todayString = [
      now.year.toString(),
      now.month.toString().padLeft(2, '0'),
      now.day.toString().padLeft(2, '0')
    ].join('-');
    //! Before start this test you should to change the value of datetime to current date.
    expect(serialized,
        '{"datetime":"${todayString}T00:00:00.000","enumeration":1,"name":"Name"}');
  });
}
