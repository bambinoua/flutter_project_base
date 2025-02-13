import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../services/storage/web/providers.dart';

/// {@template web_hydrated_storage}
/// Implementation of [Storage] which uses session storage of web browser
/// to persist and retrieve state changes.
/// {@endtemplate}

class WebHydratedStorage implements Storage {
  const WebHydratedStorage()
      : assert(kIsWeb, 'WebHydratedStorage is only available on web platform');

  /// Returns instance of [WebStorage].
  WebStorage get storage => WebStorage.session;

  @override
  Future<void> clear() async {
    storage.clear();
  }

  @override
  Future<void> close() async {
    // Nothing to do.
  }

  @override
  Future<void> delete(String key) async {
    storage.remove(key);
  }

  @override
  dynamic read(String key) {
    final encodedValue = storage.get(key) ?? '';
    final value = encodedValue.isNotEmpty
        ? <String, dynamic>{...json.decode(encodedValue)}
        : null;
    return value;
  }

  @override
  Future<void> write(String key, value) async {
    final encodedValue = json.encode(value);
    storage.put(key, encodedValue);
  }
}
