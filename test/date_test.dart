import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
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
    expect(months.keys.length, 12);
    expect(months.values.length, 12);
  });
  test('date.getDaysOfWeek', () async {
    await initializeDateFormatting();
    var daysOfWeek = Date.getDaysOfWeek();
    expect(daysOfWeek.keys.length, 7);
    expect(daysOfWeek.values.length, 7);
  });
}
