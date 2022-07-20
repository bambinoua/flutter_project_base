import 'dart:convert';

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';

enum TestEnum { one, two }

class TestObject implements Serializable<TestObject> {
  TestObject(
    this.datetime,
    this.enumeration,
    this.name,
  );

  final DateTime datetime;
  final TestEnum enumeration;
  final String name;

  @override
  Map<String, dynamic> toJson() => {
        'datetime': datetime,
        'enumeration': enumeration,
        'name': name,
      };

  @override
  TestObject fromJson(Json json) {
    throw UnimplementedError();
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  test('Object serialized', () {
    final today = Date.today();
    final testObj = TestObject(today, TestEnum.two, 'Name');
    final serializedTestObj = json.encode(testObj);
    expect(serializedTestObj,
        '{"datetime":"${today}T00:00:00.000","enumeration":1,"name":"Name"}');
  });

  test('Date created', () {
    final today = Date.today();
    final now = DateTime.now();
    expect(today.year, now.year);
    expect(today.month, now.month);
    expect(today.day, now.day);
    expect(today.hour, 0);
    expect(today.minute, 0);
    expect(today.second, 0);
    expect(today.millisecond, 0);
    expect(today.microsecond, 0);
  });

  test('Today date created', () {
    final today = Date.today();
    final now = DateTime.now();
    expect(today, DateTime(now.year, now.month, now.day));
  });

  test('Check if date is today', () {
    final today1 = Date.today();
    final today2 = Date.today();
    expect(today1 == today2, true);
  });
  test('Get list of months', () {
    final months = Date.getMonths();
    expect(months.keys.length, 12);
    expect(months.values.length, 12);
  });
  test('Get days of week', () {
    final daysOfWeek = Date.getDaysOfWeek();
    expect(daysOfWeek.keys.length, 7);
    expect(daysOfWeek.values.length, 7);
  });
}
