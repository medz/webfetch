part of '../headers.dart';

final class _Headers extends Headers {
  _Headers._() : super.from(CaseInsensitiveMap<List<String>>());

  /// Creates a new [Headers] object from a [Map].
  _Headers.fromMap(Map<String, String> init)
      : super.from(CaseInsensitiveMap<List<String>>()) {
    init.forEach((name, value) => append(name, value));
  }

  /// Creates a new [Headers] object from a [Iterable] of key/value pairs.
  _Headers.fromIterable(Iterable<Iterable<String>> init)
      : super.from(CaseInsensitiveMap<List<String>>()) {
    for (final pair in init) {
      // If the pair is empty, skip it.
      if (pair.isEmpty) continue;
      _map[pair.first] = pair.skip(1).toList();
    }
  }

  /// Creates a new [Headers] object from a [Headers] object.
  _Headers.fromHeaders(Headers init)
      : super.from(CaseInsensitiveMap<List<String>>()) {
    _map.addAll(init._map.copy());
  }

  /// Creates a new [Headers] object from a [Map] with all parameters.
  _Headers.fromMapWithAll(Map<String, Iterable<String>> init)
      : super.from(CaseInsensitiveMap<List<String>>()) {
    _map.addAll(init.map((key, value) => MapEntry(key, value.toList())));
  }

  /// Creates a new [Headers] object from nullable init object.
  factory _Headers([Object? init]) => switch (init) {
        final Map<String, String> init => _Headers.fromMap(init),
        final Map<String, Iterable<String>> init =>
          _Headers.fromMapWithAll(init),
        final Iterable<Iterable<String>> init => _Headers.fromIterable(init),
        _Headers(_copy: final copy) => copy(),
        final Headers init => _Headers.fromHeaders(init),
        null => _Headers._(),
        _ => throw ArgumentError.value(init, 'init', 'Invalid type'),
      };

  _Headers _copy() => _Headers.fromMapWithAll(_map.copy());
}
