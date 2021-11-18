import 'package:flutter/widgets.dart';

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
class StreamBuilderWithCallback<T> extends StreamBuilder<T> {
  StreamBuilderWithCallback({
    Key? key,
    this.initialData,
    Stream<T>? stream,
    required this.builder,
    required this.onData,
  }) : super(
            key: key,
            initialData: initialData,
            stream: stream,
            builder: builder);

  /// The build strategy currently used by this builder.
  ///
  /// This builder must only return a widget and should not have any side
  /// effects as it may be called multiple times.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  ///
  /// Providing this value (presumably obtained synchronously somehow when the
  /// [Stream] was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final T? initialData;

  /// Called back when StreamBuilder has a data.
  final ValueChanged<T> onData;

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    onData(data);
    return super.afterData(current, data);
  }
}
