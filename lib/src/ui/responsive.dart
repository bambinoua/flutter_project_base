import 'package:flutter/material.dart';

/// Common devices breakpoints.
///
///
/// [Typical Device Breakpoints] (https://www.w3schools.com/howto/howto_css_media_query_breakpoints.asp)
enum DeviceClass {
  /// Extra small devices (phones).
  smartphones(RangeValues(0, 600)),

  /// Small devices (portrait tablets and large phones).
  portraitTablets(RangeValues(600, 768)),

  /// Medium devices (landscape tablets).
  landscapeTablets(RangeValues(768, 992)),

  /// Large devices (laptops/desktops).
  laptops(RangeValues(992, 1200)),

  /// Extra large devices (large laptops/desktops).
  desktops(RangeValues(1200, double.infinity));

  const DeviceClass(this.breakpoints);

  /// The breakpoints width values.
  final RangeValues breakpoints;

  /// Whether this device is a smartphone.
  bool get isSmartphone => this == smartphones;

  /// Whether this device is a portrait tablet.
  bool get isPortraitTablet => this == portraitTablets;

  /// Whether this device is a landscape tablet.
  bool get isLandscapeTablet => this == landscapeTablets;

  /// Whether this device is a laptop.
  bool get isLaptop => this == laptops;

  /// Whether this device is a desktop.
  bool get isDesktop => this == desktops;

  /// Returns the device class for the given screen [width].
  static DeviceClass compute(double width) {
    assert(width > 0, 'The width is expected to be more than zero');
    return DeviceClass.values
        .singleWhere((deviceClass) => deviceClass.breakpoints.contains(width));
  }

  @override
  String toString() => '$runtimeType: $name';
}

extension on RangeValues {
  bool contains(double value) => start <= value && value <= end;
}
