import 'dart:developer' as developer;

import 'package:logging/logging.dart';

/// Colos ANSI codes.
enum AnsiColor {
  foregroundBlack('\x1B[30m'),
  foregroundRed('\x1B[31m'),
  foregroundGreen('\x1B[32m'),
  foregroundYellow('\x1B[33m'),
  foregroundBlue('\x1B[34m'),
  foregroundMagenta('\x1B[35m'),
  foregroundCyan('\x1B[36m'),
  foregroundWhite('\x1B[37m'),
  foregroundBrightBlack('\x1B[90m'),
  foregroundBrightRed('\x1B[91m'),
  foregroundBrightGreen('\x1B[92m'),
  foregroundBrightYellow('\x1B[93m'),
  foregroundBrightBlue('\x1B[94m'),
  foregroundBrightMagenta('\x1B[95m'),
  foregroundBrightCyan('\x1B[96m'),
  foregroundBrightWhite('\x1B[97m'),

  backgroundBlack('\x1B[40m'),
  backgroundRed('\x1B[41m'),
  backgroundGreen('\x1B[42m'),
  backgroundYellow('\x1B[43m'),
  backgroundBlue('\x1B[44m'),
  backgroundMagenta('\x1B[45m'),
  backgroundCyan('\x1B[46m'),
  backgroundWhite('\x1B[47m'),
  backgroundBrightBlack('\x1B[100m'),
  backgroundBrightRed('\x1B[101m'),
  backgroundBrightGreen('\x1B[102m'),
  backgroundBrightYellow('\x1B[103m'),
  backgroundBrightBlue('\x1B[104m'),
  backgroundBrightMagenta('\x1B[105m'),
  backgroundBrightCyan('\x1B[106m'),
  backgroundBrightWhite('\x1B[107m');

  const AnsiColor(this.code);

  /// Hex code of color.
  final String code;
}

/// Emit a log event in color.
///
/// This function was designed to map closely to the logging information
/// collected by `package:logging`.
///
/// - [message] is the log message
/// - [time] (optional) is the timestamp
/// - [sequenceNumber] (optional) is a monotonically increasing sequence number
/// - [level] (optional) is the severity level (a value between 0 and 2000); see
///   the `package:logging`'s `Level` class for an overview of the possible values
/// - [name] (optional) is the name of the source of the log message
/// - [error] (optional) an error object associated with this log event
/// - [stackTrace] (optional) a stack trace associated with this log event
void log(
  String message, {
  String name = '',
  AnsiColor color = AnsiColor.foregroundBrightBlack,
  Level level = Level.ALL,
  int? sequenceNumber,
  Object? error,
  StackTrace? stackTrace,
}) =>
    developer.log(
      message,
      name: name,
      level: level.value,
      sequenceNumber: sequenceNumber,
      error: error,
      stackTrace: stackTrace,
    );
