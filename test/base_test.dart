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
  test('default_serializable', () {
    var testObj = Test(Date.today(), TestEnum.two, 'Name');
    var serialized = json.encode(testObj);
    //! Before start this test you should to change the value of datetime to current date.
    expect(serialized,
        '{"datetime":"2021-04-07T00:00:00.000","enumeration":1,"name":"Name"}');
  });
}
