import '../../packages.dart';

/// Converts the boolean value into integer JSON representation and vise versa.
class JsonBoolIntConverter extends JsonConverter<bool, int> {
  const JsonBoolIntConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool object) => object ? 1 : 0;
}

/// Converts the date-time value into integer JSON representation and vise versa.
class JsonDateTimeIntConverter extends JsonConverter<DateTime, int> {
  const JsonDateTimeIntConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

/// Converts the date-time value into string JSON representation and vise versa.
class JsonDateTimeStringConverter extends JsonConverter<DateTime, String> {
  const JsonDateTimeStringConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String();
}
