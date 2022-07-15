import '../data/contracts.dart';

/// Base class for internal Firebase errors.
class FirebaseInternalError {
  FirebaseInternalError.fromJson(Json json)
      : error = FirebaseError.fromJson(json['error']);

  final FirebaseError error;
}

class FirebaseError {
  FirebaseError.fromJson(Json map)
      : code = map['code'],
        message = map['message'],
        errors = List.of(map['errors'])
            .map((json) => FirebaseErrorItem.fromJson(json))
            .toList();

  final int code;
  final String message;
  final List<FirebaseErrorItem> errors;
}

class FirebaseErrorItem {
  FirebaseErrorItem.fromJson(Json json)
      : domain = json['domain'],
        reason = json['reason'],
        message = json['message'];

  final String domain;
  final String reason;
  final String message;
}
