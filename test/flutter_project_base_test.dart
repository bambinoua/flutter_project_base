import 'dart:convert';

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

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
        '{"datetime":"2021-04-07T00:00:00.000","enumeration":1,"name":"Name"}');
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
  test('date.getMonths', () async {
    await initializeDateFormatting();
    var months = Date.getMonths();
    expect(months is Map, true);
    expect(months.keys.length, 12);
    expect(months.values.length, 12);
  });
  test('date.getDaysOfWeek', () async {
    await initializeDateFormatting();
    var daysOfWeek = Date.getDaysOfWeek();
    expect(daysOfWeek is Map, true);
    expect(daysOfWeek.keys.length, 7);
    expect(daysOfWeek.values.length, 7);
  });
}
