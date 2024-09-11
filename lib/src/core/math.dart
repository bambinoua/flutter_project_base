import 'dart:math' as math;
import 'dart:ui';

/// Base geometry functions.
abstract final class Geometry {
  const Geometry._();

  /// Calculates the radius of circle circumscribed out of rectangle of [size].
  static double circumscribedCircleRadiusOfRect(Size size) =>
      math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2)) / 2;

  /// Convert [radians] to degrees.
  static double degrees(double radians) => radians * 180.0 / math.pi;

  /// Convert [degrees] to radians.
  static double radians(double degrees) => degrees * math.pi / 180.0;

  /// Detects whether [point] is within the given line [segment].
  static bool isPointWithinSegment(Distance segment, Offset point,
      {double epsilon = 0.0001}) {
    final a = segment.begin;
    final b = segment.end;

    final crossProduct =
        (point.dy - a.dy) * (b.dx - a.dx) - (point.dx - a.dx) * (b.dy - a.dy);
    if (crossProduct > epsilon) {
      return false;
    }

    final dotProduct =
        (point.dx - a.dx) * (b.dx - a.dx) + (point.dy - a.dy) * (b.dy - a.dy);
    if (dotProduct < 0) {
      return false;
    }

    final squaredSegmentLength =
        (b.dx - a.dx) * (b.dx - a.dx) + (b.dy - a.dy) * (b.dy - a.dy);
    if (dotProduct > squaredSegmentLength) {
      return false;
    }

    return true;
  }

  /// Returns the closest point from [point] to line [segment].
  ///
  /// The used formula is taken from
  /// http://paulbourke.net/geometry/pointlineplane
  ///
  static Offset getClosestPoint(Distance segment, Offset point) {
    final p1 = segment.begin;
    final p2 = segment.end;

    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;

    double u = ((point.dx - p1.dx) * dx + (point.dy - p1.dy) * dy) /
        (dx * dx + dy * dy);

    if (u < 0) {
      u = 0;
    } else if (u > 1) {
      u = 1;
    }

    return Offset(p1.dx + u * dx, p1.dy + u * dy);
  }
}

/// Repsesent a 2-D floating distance or line segment
class Distance {
  /// Creates a distance with provided [begin] and [end] offsets.
  const Distance(this.begin, this.end);

  /// An empty distance.
  static const empty = Distance(Offset.zero, Offset.zero);

  /// The begin offset of this distance.
  final Offset begin;

  /// The end offset of this distance.
  final Offset end;

  /// The length of this distance.
  double get length => math
      .sqrt(math.pow(end.dx - begin.dx, 2) + math.pow(end.dy - begin.dy, 2));

  /// The angle of this distance as radians clockwise from the positive x-axis
  /// in the range -[pi] to [pi], assuming positive values of the x-axis go to
  /// the right and positive values of the y-axis go down.
  double get direction => math.atan2(end.dy - begin.dy, end.dx - begin.dx);

  /// Whether ths distance is empty.
  bool get isEmpty => this == empty;

  /// Checks if this distance contains a [point].
  bool containsPoint(Offset point) =>
      Geometry.isPointWithinSegment(this, point);

  /// Returns the closest point from the given [point] to this segment.
  /// The closest point is determined by the length of the perpendicular
  /// lowered down from the given [point] to this segment.
  Offset getClosestPointFrom(Offset point) =>
      Geometry.getClosestPoint(this, point);

  @override
  int get hashCode => Object.hash(begin, end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Distance && begin == other.begin && end == other.end;
}

/// Integer bit wrapper.
final class BitInt {
  BitInt(this.value);

  /// Target [int] value.
  late int value;

  /// Returns the value of the bit with `index`.
  bool getBit(int index) {
    assert(_debugAssert(index));
    return value >> index & 1 != 0;
  }

  /// Sets the bit with `index`.
  int setBit(int index) {
    assert(_debugAssert(index));
    value |= 1 << index;
    return value;
  }

  /// Resets the bit with `index`.
  int resetBit(int index) {
    assert(_debugAssert(index));
    value &= ~(1 << index);
    return value;
  }

  /// Toggles the bit with `index`.
  int toggleBit(int index) {
    assert(_debugAssert(index));
    value ^= 1 << index;
    return value;
  }

  static bool _debugAssert(int index) {
    return index >= 0 && index <= 63;
  }
}
