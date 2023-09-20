part of '../url.dart';

/// The `URLSearchParams` constructor.
class _URLSearchParamsConstructor extends _URLSearchParamsImpl {
  /// Default, empty constructor.
  _URLSearchParamsConstructor.empty();

  /// From `URLSearchParams` instance.
  factory _URLSearchParamsConstructor.formURLSearchParams(
      URLSearchParams init) {
    final instance = _URLSearchParamsConstructor.empty();
    for (final (value, key) in init.entries()) {
      instance.append(key, value);
    }

    return instance;
  }

  /// From `Iterable<String>`.
  factory _URLSearchParamsConstructor.fromIterable(Iterable<String> init) {
    final search = init.join('&');

    return _URLSearchParamsConstructor.fromString(search);
  }

  /// From `Map<String, String>`.
  factory _URLSearchParamsConstructor.fromMap(Map<String, String> init) {
    final instance = _URLSearchParamsConstructor.empty();
    for (final MapEntry(key: key, value: value) in init.entries) {
      instance.append(key, value);
    }

    return instance;
  }

  // From Record
  factory _URLSearchParamsConstructor.fromRecord(
      Iterable<(String, String)> init) {
    final instance = _URLSearchParamsConstructor.empty();
    for (final (key, value) in init) {
      instance.append(key, value);
    }

    return instance;
  }

  // From String
  factory _URLSearchParamsConstructor.fromString(String init) {
    final search = init.startsWith('?') ? init : '?$init';
    final params = Uri.parse(search).queryParametersAll;

    return _URLSearchParamsConstructor.empty()..params.addAll(params);
  }

  factory _URLSearchParamsConstructor([dynamic init]) {
    return switch (init) {
      // If init is a `URLSearchParams` instance.
      final URLSearchParams init =>
        _URLSearchParamsConstructor.formURLSearchParams(init),

      // If init is a `Iterable<String>`
      final Iterable<String> init =>
        _URLSearchParamsConstructor.fromIterable(init),

      // If init is a `Map<String, String>`
      final Map<String, String> init =>
        _URLSearchParamsConstructor.fromMap(init),

      // If init is a (String, String) `Iterable`
      final Iterable<(String, String)> init =>
        _URLSearchParamsConstructor.fromRecord(init),

      // If init is a `String`
      final String init => _URLSearchParamsConstructor.fromString(init),

      // Default constructor.
      _ => _URLSearchParamsConstructor.empty()
    };
  }
}
