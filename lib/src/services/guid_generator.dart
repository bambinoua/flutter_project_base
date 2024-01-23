import 'package:uuid/data.dart';
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
  factory GuidV1Generator({GlobalOptions? options}) {
    _instance ??= GuidV1Generator._(options: options);
    return _instance!;
  }

  GuidV1Generator._({GlobalOptions? options})
      : super._(Uuid(goptions: options));

  static GuidV1Generator? _instance;
}

/// Generates a GUID of version 4.
class GuidV4Generator extends BaseGuidGenerator {
  factory GuidV4Generator({GlobalOptions? options}) {
    _instance ??= GuidV4Generator._(options: options);
    return _instance!;
  }

  GuidV4Generator._({GlobalOptions? options})
      : super._(Uuid(goptions: options));

  static GuidV4Generator? _instance;
}
