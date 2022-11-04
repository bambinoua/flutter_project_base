import 'package:meta/meta.dart';

@sealed
class LoadState {
  const LoadState({this.endOfPaginationReached = false});

  final bool endOfPaginationReached;
}
