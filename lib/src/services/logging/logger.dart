import 'package:flutter/foundation.dart';

/// A Logger object is used to log messages for
/// a specific system or application component.
abstract class BaseLogger extends Listenable {
  BaseLogger({this.name = '', this.level = LogLevel.all});

  /// The name for this logger.
  final String name;

  /// Log an TRACE message.
  ///
  /// The most fine-grained information only used in rare cases where you need
  /// the full visibility of what is happening in your application and inside
  /// the third-party libraries that you use. You can expect the TRACE logging
  /// level to be very verbose. You can use it for example to annotate each step
  ///  in the algorithm or each individual query with parameters in your code.
  void trace(String message);

  /// Log an DEBUG message.
  ///
  /// Less granular compared to the TRACE level, but it is more than you will
  /// need in everyday use. The DEBUG log level should be used for information
  /// that may be needed for diagnosing issues and troubleshooting or when
  /// running application in the test environment for the purpose of making
  /// sure everything is running correctly
  void debug(String message);

  /// Log an INFO message.
  ///
  /// The standard log level indicating that something happened, the application
  /// entered a certain state, etc. For example, a controller of your
  /// authorization API may include an INFO log level with information on which
  /// user requested authorization if the authorization was successful or not.
  /// The information logged using the INFO log level should be purely
  /// informative and not looking into them on a regular basis shouldn’t result
  /// in missing any important information.
  void info(String message);

  /// Log an WARNING message.
  ///
  /// The log level that indicates that something unexpected happened in the
  /// application, a problem, or a situation that might disturb one of the
  /// processes. But that doesn’t mean that the application failed. The WARN
  /// level should be used in situations that are unexpected, but the code can
  /// continue the work. For example, a parsing error occurred that resulted in
  /// a certain document not being processed.
  void warning(String message);

  /// Log an ERROR message.
  ///
  /// The log level that should be used when the application hits an issue
  /// preventing one or more functionalities from properly functioning. The
  /// ERROR log level can be used when one of the payment systems is not
  /// available, but there is still the option to check out the basket in the
  /// e-commerce application or when your social media logging option is not
  /// working for some reason.
  void error(String message);

  /// Log an FATAL message.
  ///
  /// The log level that tells that the application encountered an event or
  /// entered a state in which one of the crucial business functionality is no
  /// longer working. A FATAL log level may be used when the application is not
  /// able to connect to a crucial data store like a database or all the payment
  ///  systems are not available and users can’t checkout their baskets in your
  /// e-commerce.
  void fatal(String message);

  /// Check if a message of the given level would actually be logged by
  /// this logger.
  bool isLoggable(LogLevel level);

  /// Log a message, with optional argument.
  @protected
  void log(LogLevel level, String message, [Object? argument]);

  /// Gets or set the log level specifying which message levels will be logged
  /// by this logger. Message levels lower than this value will be discarded.
  /// The level value Level.off can be used to turn off logging.
  ///
  ///If the new level is null, it means that this node should inherit its level
  ///from its nearest ancestor with a specific (non-null) level value.
  LogLevel? level;
}

/// This enum defines a set of standard logging levels that can be used
/// to control logging output. The `LogLevel` objects are ordered and are
/// specified by ordered integers.
/// Enabling logging at a given level also enables logging at all higher levels.
enum LogLevel {
  off,
  fatal,
  error,
  warning,
  info,
  debug,
  trace,
  all,
}
