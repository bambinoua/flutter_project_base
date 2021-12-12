import 'basic_types.dart';

/// Base class for internal Firebase errors.
class FirebaseInternalError {
  FirebaseInternalError.fromJson(Json json)
      : error = _FirebaseError.fromJson(json['error']);

  final _FirebaseError error;
}

class _FirebaseError {
  _FirebaseError.fromJson(Json map)
      : code = map['code'],
        message = map['message'],
        errors = List.of(map['errors'])
            .map((json) => _FirebaseErrorItem.fromJson(json))
            .toList();

  final int code;
  final String message;
  final List<_FirebaseErrorItem> errors;
}

class _FirebaseErrorItem {
  _FirebaseErrorItem.fromJson(Json json)
      : domain = json['domain'],
        reason = json['reason'],
        message = json['message'];

  final String domain;
  final String reason;
  final String message;
}
