import 'package:flutter/foundation.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

import 'extensions.dart';

/// The `Date` type is used for values with a date part but no time part.
/// Dates can represent time values that are at a distance of at most
/// 100,000,000 days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
class Date extends DateTime {
  /// Constructs a [Date] instance specified in the local time zone.
  ///
  /// For example,
  /// to create a DateTime object representing the 7th of September 2017,
  ///
  /// ```
  /// var dentistAppointment = Date(2017, 9, 7);
  /// ```
  Date(int year, [int month = DateTime.january, int day = 1])
      : super(year, month, day);

  /// Constructs a [Date] instance with current date in the local time zone.
  ///
  /// ```
  /// var thisInstant = Date.today();
  /// ```
  factory Date.today() {
    final now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  /// Constructs a new [Date] instance with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [Date] represents
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] ms in the given
  /// time zone (local or UTC).
  factory Date.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
      {bool isUtc = false}) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
        isUtc: isUtc);
    return Date(datetime.year, datetime.month, datetime.day);
  }

  /// Constructs a new [Date] instance with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [Date] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  factory Date.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
      {bool isUtc = false}) {
    final datetime = DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
        isUtc: isUtc);
    return Date(datetime.year, datetime.month, datetime.day);
  }

  /// Returns `true` if this [Date] is a weekend.
  bool get isWeekend =>
      DateFormat().dateSymbols.WEEKENDRANGE.contains(weekday - 1);

  /// Returns the ordinal number of this [Date] in this year.
  ///
  /// The number may vary from 1 to 365/366 days.
  int get ordinalDay => int.parse(DateFormat('D').format(this));

  /// Returns the week number to which this [Date] belongs.
  ///
  /// The value may vary from 1 to 52/53.
  int get weekNumber {
    int number = (ordinalDay - weekday + 10) ~/ 7;
    if (number > 52 && weekday < DateTime.thursday) {
      number = 52;
    }
    return number;
  }

  /// Returns the number of week in this `year`.
  int get lastWeekNumber => Date(year, DateTime.december, 31).weekNumber;

  /// Returns the quarter to which this [Date] belongs.
  ///
  /// The value may vary from 1 to 4.
  int get quarter => ((month - 1) / 3).floor() + 1;

  /// Constructs a new [Date] instance based on `formattedString`.
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601
  /// which includes the subset accepted by RFC 3339.
  static Date parse(String formattedString) {
    final datetime = DateTime.parse(formattedString);
    return Date(datetime.year, datetime.month, datetime.day);
  }

  /// Constructs a new [Date] instance based on `formattedString`.
  ///
  /// Works like [parse] except that this function returns `null`
  /// where [parse] would throw a [FormatException].
  static Date? tryParse(String formattedString) {
    try {
      return parse(formattedString);
    } on FormatException {
      return null;
    }
  }

  /// Returns `true` if `date` is today.
  static bool isToday(Date date) => date == Date.today();

  /// Returns full names of months, e.g. 'January' or short names of months,
  /// e.g. 'Jan' depending of `shortNames` boolean.
  static Map<int, String> getMonths({bool shortNames = true, String? locale}) {
    final dateSymbols = Date.getDateSymbols(locale);
    return (shortNames ? dateSymbols.SHORTMONTHS : dateSymbols.MONTHS)
        .asMap()
        .map((index, name) => MapEntry(index + 1, name));
  }

  /// Returns name of `month`.
  ///
  /// Month must be from 1 to 12.
  static String getMonthName(int month, {bool shortNames = true}) {
    assert(month >= DateTime.january && month <= DateTime.december);
    final months = getMonths(shortNames: shortNames);
    return months[month]!;
  }

  /// Return the days of the week, starting with Sunday or short names for
  /// days of the week, starting with Sunday, e.g. 'Sun'.
  static Map<int, String> getDaysOfWeek(
      {bool shortNames = true, String? locale}) {
    final dateSymbols = Date.getDateSymbols(locale);
    var daysOfWeek =
        (shortNames ? dateSymbols.SHORTWEEKDAYS : dateSymbols.WEEKDAYS)
            .asMap()
            .map((index, name) =>
                MapEntry(index == 0 ? DateTime.sunday : index, name));
    if (dateSymbols.FIRSTDAYOFWEEK == 0) {
      daysOfWeek = Map.fromEntries(daysOfWeek.entries.toList()
        ..sort((dow1, dow2) => dow1.key.compareTo(dow2.key)));
    }
    return daysOfWeek;
  }

  /// Returns the name of `dayOfWeek`.
  ///
  /// `dayOfWeek` must be from 1 to 7.
  static String getDayOfWeekName(int dayOfWeek, {bool shortNames = true}) {
    assert(dayOfWeek >= DateTime.monday && dayOfWeek <= DateTime.sunday);
    final daysOfWeek = getDaysOfWeek(shortNames: shortNames);
    return daysOfWeek[dayOfWeek]!;
  }

  /// Returns the last day of the specified `month`.
  ///
  /// If `year` is omitted than the current year is assumed.
  static int getLastDayOfMonth(int month, [int? year]) {
    assert(month >= DateTime.january && month <= DateTime.december);
    assert(year == null || year > 1900 && year <= 9999);
    return Date(year ?? Date.today().year, month + 1, 0).day;
  }

  /// Return the [DateSymbols] information for the locale.
  ///
  /// This can be useful to find lists like the names of weekdays or months in a
  /// locale, but the structure of this data may change, and it's generally
  /// better to go through the [format] and [parse] APIs.
  ///
  /// If the locale isn't present, or is uninitialized, throws.
  static DateSymbols getDateSymbols(String? locale) =>
      DateFormat(null, locale).dateSymbols;

  @override
  String toString() => <String>[
        year.toString(),
        month.withLeadingZeros(2),
        day.withLeadingZeros(2)
      ].join('-');
}

/// Encapsulates a start and end [Date] that represent the range of dates.
///
/// The range includes the [start] and [end] dates. The [start] and [end] dates
/// may be equal to indicate a date range of a single day. The [start] date must
/// not be after the [end] date.
@immutable
class DateRange {
  /// Creates a date range for the given start and end [Date].
  DateRange({
    required this.start,
    required this.end,
  }) : assert(!start.isAfter(end));

  /// The start of the range of dates.
  final DateTime start;

  /// The end of the range of dates.
  final DateTime end;

  /// Returns a [Duration] of the time between [start] and [end].
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
