part of '../headers.dart';

class _Headers implements Headers {
  final _store = CaseInsensitiveMap<Iterable<String>>();

  _Headers._();

  /// Creates a new [Headers] object from a [Map].
  _Headers.fromMap(Map<String, String> init) {
    init.forEach((name, value) => append(name, value));
  }

  /// Creates a new [Headers] object from a [Iterable] of key/value pairs.
  _Headers.fromIterable(Iterable<Iterable<String>> init) {
    for (final pair in init) {
      // If the pair is empty, skip it.
      if (pair.isEmpty) continue;
      _store[pair.first] = pair.skip(1);
    }
  }

  /// Creates a new [Headers] object from a [Headers] object.
  _Headers.fromHeaders(Headers init) {
    init.entries().forEach((element) => append(element.first, element.last));
  }

  /// Creates a new [Headers] object from a [Map] with all parameters.
  _Headers.fromMapWithAll(Map<String, Iterable<String>> init) {
    _store.addAll(init);
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

  _Headers _copy() => _Headers.fromMapWithAll(_store.copy());

  @override
  void append(String name, String value) {
    _store[name] = [..._store[name] ?? [], value];
  }

  @override
  void delete(String name) => _store.remove(name);

  @override
  Iterable<Iterable<String>> entries() sync* {
    for (final MapEntry(key: name, value: values) in _store.entries) {
      yield [name, values.join(', ')];
    }
  }

  @override
  void forEach(void Function(String name, String value, Headers parent) fn) =>
      entries().forEach((element) => fn(element.first, element.last, this));

  @override
  String? get(String name) => _store[name]?.join(', ');

  @override
  Iterable<String> getSetCookie() => _store['Set-Cookie'] ?? const <String>[];

  @override
  bool has(String name) => _store.containsKey(name);

  @override
  Iterable<String> keys() => _store.keys;

  @override
  void set(String name, String value) => _store[name] = [value];

  @override
  Iterable<String> values() => _store.values.map((e) => e.join(', '));
}
