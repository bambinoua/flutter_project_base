import 'package:flutter/foundation.dart';

/// A Logger object is used to log messages for
/// a specific system or application component.
abstract class Logger {
  const Logger(this.name);

  /// The name for this logger.
  final String name;

  /// Add a log handler to receive logging messages.
  ///
  ///By default, Loggers also send their output to their parent logger.
  ///Typically the root Logger is configured with a set of handlers that
  ///essentially act as default handlers for all loggers.
  void addHandler(VoidCallback handler);

  /// Log a CONFIG message.
  void config(String msg);

  /// Log an FINE message.
  void fine(String msg);

  /// Log an FINER message.
  void finer(String msg);

  /// Log an FINEST message.
  void finest(String msg);

  /// Log an INFO message.
  void info(String msg);

  /// Check if a message of the given level would actually be logged by
  /// this logger.
  bool isLoggable(Level level);

  /// Get the handlers associated with this logger.
  List<VoidCallback> get handlers;

  /// Get the log Level that has been specified for this Logger.
  /// The result may be null.
  Level get level;

  /// Log a message, with optional argument.
  void log(Level level, String msg, [Object argument]);

  /// Remove a log handler.
  void removeHandler(VoidCallback handler);

  /// Set the log level specifying which message levels will be logged by this
  /// logger. Message levels lower than this value will be discarded. The level
  /// value Level.off can be used to turn off logging.
  ///
  ///If the new level is null, it means that this node should inherit its level
  ///from its nearest ancestor with a specific (non-null) level value.
  void setLevel(Level newLevel);

  /// Log an SEVERE message.
  void severe(String msg);

  /// Log an WARNING message.
  void warning(String msg);
}

/// The Level class defines a set of standard logging levels that can be used
/// to control logging output. The logging Level objects are ordered and are
/// specified by ordered integers.
/// Enabling logging at a given level also enables logging at all higher levels.
enum Level {
  off,
  finest,
  finer,
  fine,
  config,
  info,
  warning,
  severe,
  all,
}
