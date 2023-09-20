part of '../url.dart';

class _URLSearchParamsImpl implements URLSearchParams {
  final Map<String, List<String>> params = {};

  @override
  void append(String name, String value) => params
      .putIfAbsent(Uri.encodeComponent(name), () => [])
      .add(Uri.encodeComponent(value));

  @override
  void delete(String name, [String? value]) {
    if (value == null) {
      params.remove(Uri.encodeComponent(name));
      return;
    }

    params[Uri.encodeComponent(name)]?.remove(Uri.encodeComponent(value));
  }

  @override
  Iterable<String> getAll(String name) =>
      params[Uri.encodeComponent(name)]?.map(Uri.decodeComponent) ?? const [];

  @override
  Iterable<String> keys() sync* {
    for (final name in params.keys.map(Uri.decodeComponent)) {
      yield* getAll(name).map((_) => name);
    }
  }

  @override
  void sort() {
    final sortedKeys = params.keys.map(Uri.decodeComponent).toList()..sort();
    final sortedParamsMap = <String, List<String>>{};

    for (final key in sortedKeys.map(Uri.encodeComponent)) {
      sortedParamsMap[key] =
          params[key]?.map(Uri.decodeComponent).toList() ?? [];
    }

    params.clear();
    params.addAll(sortedParamsMap);
  }

  @override
  Iterable<(String, String)> entries() sync* {
    for (final key in params.keys.map(Uri.decodeComponent)) {
      yield* getAll(key).map((value) => (key, value));
    }
  }

  @override
  void forEach(void Function(String value, String name) fn) {
    for (final (name, value) in entries()) {
      fn(value, name);
    }
  }

  @override
  String? get(String name) => getAll(name).firstOrNull;

  @override
  bool has(String name, [String? value]) {
    if (value == null) {
      return keys().contains(Uri.decodeComponent(name));
    }

    return getAll(name).contains(Uri.decodeComponent(value));
  }

  @override
  void set(String name, String value) {
    delete(name);
    append(name, value);
  }

  @override
  Iterable<String> values() sync* {
    for (final key in params.keys.map(Uri.decodeComponent)) {
      yield* getAll(key);
    }
  }

  @override
  int get size => keys().length;

  @override
  String toString() {
    final pairs = <String>[];
    for (final (name, value) in entries()) {
      pairs.add('${Uri.encodeComponent(name)}=${Uri.encodeComponent(value)}');
    }

    return pairs.join('&');
  }
}
