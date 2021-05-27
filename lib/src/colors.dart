import 'package:flutter/painting.dart';

/// Utility class for generation list of gradient colors.
class ColorGradient {
  ColorGradient._();

  /// Generates the list from `length` colors which starts from
  /// `startColor` and ends with `endColor`.
  ///
  /// The length must be greater than 0.
  static List<Color> generate(Color startColor, Color endColor, int length) {
    assert(length > 0, 'The length of gradient pallette cannot be zero.');
    return List.generate(length, (index) {
      final grade = index / length;
      return Color.fromARGB(
          255,
          (startColor.red * (1 - grade) + grade * endColor.red).round(),
          (startColor.green * (1 - grade) + grade * endColor.green).round(),
          (startColor.blue * (1 - grade) + grade * endColor.blue).round());
    });
  }
}
