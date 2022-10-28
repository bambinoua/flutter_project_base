import 'basic_types.dart';

/// Base class for internal Firebase errors.
class FirebaseError {
  FirebaseError.fromJson(JsonMap json)
      : error = FirebaseMajorError.fromJson(json['error']);

  final FirebaseMajorError error;
}

class FirebaseMajorError {
  FirebaseMajorError.fromJson(JsonMap map)
      : code = map['code'],
        message = map['message'],
        errors = List.of(map['errors'])
            .map((json) => FirebaseMinorError.fromJson(json))
            .toList();

  final int code;
  final String message;
  final List<FirebaseMinorError> errors;
}

class FirebaseMinorError {
  FirebaseMinorError.fromJson(JsonMap json)
      : domain = json['domain'],
        reason = json['reason'],
        message = json['message'];

  final String domain;
  final String reason;
  final String message;
}
