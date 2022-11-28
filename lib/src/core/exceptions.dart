import 'extensions.dart';

/// A marker interface implemented by app exceptions.
///
/// The [ApplicationException] class is the superclass of all exceptions which will be
/// created using the package. Only objects that are instances of this class
/// (or one of its subclasses) can be thrown by the Dart `throw` statement.
class ApplicationException implements Exception {
  /// Creates a new exception with an optional error `message`.
  const ApplicationException({
    this.message = '',
    this.code = '',
  });

  /// The long form message of the exception.
  final String message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  StackTrace get stackTrace => StackTrace.current;

  @override
  String toString() {
    return <String>[
      if (code.isNotEmpty) '($code)',
      if (message.isNotEmpty) message,
    ].join(' ').trimInner();
  }
}
