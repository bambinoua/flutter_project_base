/// A marker interface implemented by app exceptions.
///
/// The CommonException class is the superclass of all exceptions which will be
/// created using the pacakge. Only objects that are instances of this class
/// (or one of its subclasses) can be thrown by the Dart `throw` statement.
class CommonException implements Exception {
  /// Creates a new exception with an optional error `message`.
  CommonException({this.message, this.code = ''})
      : stackTrace = StackTrace.current;

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace stackTrace;

  @override
  String toString() => message == null ? 'CommonException' : message!;
}