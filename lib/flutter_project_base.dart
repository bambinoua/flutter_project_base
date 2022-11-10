library flutter_project_base;

export 'package:collection/collection.dart';
export 'package:equatable/equatable.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:logging/logging.dart';

export 'src/core/authentication.dart';
export 'src/core/basic_types.dart';
export 'src/core/blocs/types.dart' show BlocEvent, BlocState;
export 'src/core/cache.dart';
export 'src/core/constants.dart';
export 'src/core/contracts.dart';
export 'src/core/date.dart';
export 'src/core/domain_driven_design.dart';
export 'src/core/errors.dart';
export 'src/core/exceptions.dart';
export 'src/core/extensions.dart';
export 'src/core/math.dart';

export 'src/data/contracts.dart';
export 'src/data/query.dart';
export 'src/data/mapper.dart';
export 'src/data/paging.dart';

export 'src/material/functions.dart';
export 'src/material/scaffold_messenger.dart' show ScaffoldMessengerOfContext;
export 'src/material/textfield.dart';
export 'src/material/widgets/internet_connectivity_bar.dart';
export 'src/material/widgets/widgets.dart';
export 'src/material/web/html_view_factory.dart' show DivHtmlElement;

export 'src/services/internet_connectivity.dart';
export 'src/services/guid_generator.dart';
export 'src/services/http.dart';
export 'src/services/logging.dart';
export 'src/services/storage/contracts.dart';
export 'src/services/storage/providers.dart';
export 'src/services/storage/web/providers.dart';
