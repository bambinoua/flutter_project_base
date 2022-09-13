import 'package:uuid/uuid.dart';

import '../core/domain_driven_design.dart';

abstract class BaseGuidGenerator implements IdentityGenerator<UuidValue> {
  const BaseGuidGenerator._(this._uuid);

  final Uuid _uuid;

  @override
  UuidValue generate() {
    return _uuid.v1obj();
  }

  @override
  String toString() {
    return generate().uuid;
  }
}

/// Generates a time-based GUID of version 1.
class GuidV1Generator extends BaseGuidGenerator {
  factory GuidV1Generator({Map<String, dynamic>? options}) {
    _instance ??= GuidV1Generator._(options: options);
    return _instance!;
  }

  GuidV1Generator._({Map<String, dynamic>? options})
      : super._(Uuid(options: options));

  static GuidV1Generator? _instance;
}

/// Generates a GUID of version 4.
class GuidV4Generator extends BaseGuidGenerator {
  factory GuidV4Generator({Map<String, dynamic>? options}) {
    _instance ??= GuidV4Generator._(options: options);
    return _instance!;
  }

  GuidV4Generator._({Map<String, dynamic>? options})
      : super._(Uuid(options: options));

  static GuidV4Generator? _instance;
}
