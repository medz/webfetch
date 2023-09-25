part of '../url_search_params.dart';

class _URLSearchParams implements URLSearchParams {
  final _store = CaseInsensitiveMap<List<String>>();

  _URLSearchParams._();

  _URLSearchParams.fromInstance(URLSearchParams init) {
    init.entries().forEach((element) => append(element.first, element.last));
  }

  _URLSearchParams.fromUri(Uri init) {
    _store.addAll(init.queryParametersAll);
  }

  _URLSearchParams.fromString(String init) {
    final search = init.startsWith('?') ? init : '?$init';

    _store.addAll(Uri.parse(search).queryParametersAll);
  }

  _URLSearchParams.fromIterable(Iterable<String> init)
      : this.fromString(init.join('&'));

  _URLSearchParams.fromMap(Map<String, String> init)
      : this.fromIterable(init.entries.map((e) => '${e.key}=${e.value}'));

  factory _URLSearchParams([Object? init]) {
    return switch (init) {
      final URLSearchParams init => _URLSearchParams.fromInstance(init),
      final Uri init => _URLSearchParams.fromUri(init),
      final String init => _URLSearchParams.fromString(init),
      final Iterable<String> init => _URLSearchParams.fromIterable(init),
      final Map<String, String> init => _URLSearchParams.fromMap(init),
      _ => _URLSearchParams._(),
    };
  }

  @override
  void append(String name, String value) {
    _store[name] = [..._store[name] ?? [], value];
  }

  @override
  void delete(String name, [String? value]) {
    if (value != null) {
      _store[name]?.remove(value);
    } else {
      _store.remove(name);
    }
  }

  @override
  Iterable<Iterable<String>> entries() sync* {
    for (final MapEntry(key: name, value: values) in _store.entries) {
      yield* values.map((value) => [name, value]);
    }
  }

  @override
  void forEach(
          void Function(String value, String name, URLSearchParams searchParams)
              fn) =>
      entries().forEach((element) => fn(element.first, element.last, this));

  @override
  String? get(String name) => _store[name]?.firstOrNull;

  @override
  Iterable<String> getAll(String name) => _store[name] ?? const [];

  @override
  bool has(String name, [String? value]) {
    if (value == null) {
      return _store.containsKey(name);
    }

    return getAll(name).contains(value);
  }

  @override
  Iterable<String> keys() => entries().map((e) => e.first);

  @override
  void set(String name, String value) => _store[name] = [value];

  @override
  int get size => values().length;

  @override
  void sort() {
    final entries = _store.entries.sortedBy((element) => element.key);

    _store.clear();
    _store.addEntries(entries);
  }

  @override
  Iterable<String> values() => entries().map((e) => e.last);

  @override
  String toString() => entries()
      .map(
          (e) => '${encodeURIComponent(e.first)}=${encodeURIComponent(e.last)}')
      .join('&');
}
