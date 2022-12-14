import 'basic_types.dart';

/// Base class for internal Firebase errors.
class FirebaseError {
  FirebaseError.fromJson(JsonMap json)
      : error = FirebaseMajorError.fromJson(json['error'] as JsonMap);

  final FirebaseMajorError error;
}

class FirebaseMajorError {
  FirebaseMajorError.fromJson(JsonMap map)
      : code = map['code'] as int,
        message = map['message'] as String,
        errors = List.of(map['errors'] as List<JsonMap>)
            .map((json) => FirebaseMinorError.fromJson(json))
            .toList();

  final int code;
  final String message;
  final List<FirebaseMinorError> errors;
}

class FirebaseMinorError {
  FirebaseMinorError.fromJson(JsonMap json)
      : domain = json['domain'] as String,
        reason = json['reason'] as String,
        message = json['message'] as String;

  final String domain;
  final String reason;
  final String message;
}
