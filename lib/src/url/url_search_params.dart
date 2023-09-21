import 'package:stdweb/src/js_compatibility/encode_uri.dart';

/// The `URLSearchParams` interface defines utility methods to work
/// with the query string of a URL.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
abstract interface class URLSearchParams {
  /// Returns a URLSearchParams object instance.
  ///
  /// The URLSearchParams() constructor creates and returns a new
  /// URLSearchParams object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/URLSearchParams)
  ///
  /// ## The `init` Parameter
  ///
  /// | Type | Example |
  /// | --- | --- |
  /// | `String` | `URLSearchParams('foo=1&bar=2')` |
  /// | `Iterable<String>` | `URLSearchParams(['foo=1', 'bar=2'])` |
  /// | `Map<String, String>` | `URLSearchParams({'foo': '1', 'bar': '2'})` |
  /// | `Iterable<(String, String)>` | `URLSearchParams([('foo', '1'), ('bar', '2')])` |
  /// | `URLSearchParams` | `URLSearchParams(URLSearchParams('foo=1&bar=2'))` |
  /// | `null` | `URLSearchParams(null)` OR `URLSearchParams()` |
  factory URLSearchParams([dynamic init]) = _URLSearchParams;

  /// Indicates the total number of search parameter entries.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/size)
  int get size;

  /// Appends a specified key/value pair as a new search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/append)
  void append(String name, String value);

  /// Deletes search parameters that match a name, and optional value,
  /// from the list of all search parameters.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/delete)
  void delete(String name, [String? value]);

  /// Returns an iterator allowing iteration through all key/value pairs
  /// contained in this object in the same order as they appear in the
  /// query string.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/entries)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  Iterable<(String, String)> entries();

  /// Allows iteration through all values contained in this object via a
  /// callback function.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/forEach)
  void forEach(void Function(String value, String name) fn);

  /// Returns the first value associated with the given search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/get)
  String? get(String name);

  /// Returns all the values associated with a given search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/getAll)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  Iterable<String> getAll(String name);

  /// Returns a boolean value indicating if a given parameter, or parameter
  ///  and value pair, exists.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/has)
  bool has(String name, [String? value]);

  /// Returns an `Iterator` allowing iteration through all keys of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/keys)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  Iterable<String> keys();

  /// Sets the value associated with a given search parameter to the given
  /// value. If there are several values, the others are deleted.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/set)
  void set(String name, String value);

  /// Sorts all key/value pairs, if any, by their keys.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/sort)
  void sort();

  /// Returns a string containing a query string suitable for use in a URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/toString)
  @override
  String toString();

  /// Returns an iterator allowing iteration through all values of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/values)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  Iterable<String> values();
}

/// The `URLSearchParams` implementation.
class _URLSearchParams implements URLSearchParams {
  final Map<String, List<String>> raw = {};

  _URLSearchParams.empty();

  _URLSearchParams.fromInstance(URLSearchParams init) {
    for (final (value, key) in init.entries()) {
      append(key, value);
    }
  }

  _URLSearchParams.fromUri(Uri init) {
    raw.addAll(init.queryParametersAll);
  }

  _URLSearchParams.fromString(String init) {
    final search = init.startsWith('?') ? init : '?$init';
    final params = Uri.parse(search).queryParametersAll;

    raw.addAll(params);
  }

  _URLSearchParams.fromIterable(Iterable<String> init)
      : this.fromString(init.join('&'));

  _URLSearchParams.fromMap(Map<String, String> init)
      : this.fromIterable(init.entries.map((e) => '${e.key}=${e.value}'));

  _URLSearchParams.fromTuple(Iterable<(String, String)> init)
      : this.fromIterable(init.map((e) => '${e.$1}=${e.$2}'));

  factory _URLSearchParams([dynamic init]) {
    return switch (init) {
      final URLSearchParams init => _URLSearchParams.fromInstance(init),
      final Uri init => _URLSearchParams.fromUri(init),
      final String init => _URLSearchParams.fromString(init),
      final Iterable<String> init => _URLSearchParams.fromIterable(init),
      final Map<String, String> init => _URLSearchParams.fromMap(init),
      final Iterable<(String, String)> init => _URLSearchParams.fromTuple(init),
      _ => _URLSearchParams.empty(),
    };
  }

  @override
  void append(String name, String value) =>
      raw.putIfAbsent(name, () => []).add(value);

  @override
  void delete(String name, [String? value]) =>
      value == null ? raw.remove(name) : raw[name]?.remove(value);

  @override
  String? get(String name) => getAll(name).firstOrNull;

  @override
  Iterable<String> getAll(String name) => raw[name] ?? const [];

  @override
  bool has(String name, [String? value]) =>
      value == null ? raw.containsKey(name) : getAll(name).contains(value);

  @override
  void set(String name, String value) => raw[name] = [value];

  @override
  Iterable<(String, String)> entries() sync* {
    for (final name in raw.keys) {
      yield* getAll(name).map((value) => (name, value));
    }
  }

  @override
  Iterable<String> keys() => entries().map((e) => e.$1);

  @override
  Iterable<String> values() => entries().map((e) => e.$2);

  @override
  void forEach(void Function(String value, String name) fn) {
    for (final (name, value) in entries()) {
      fn(value, name);
    }
  }

  @override
  void sort() {
    final sortedKeys = raw.keys.toList()..sort();
    final entries = sortedKeys.map((key) => MapEntry(key, raw[key]!));

    raw.clear();
    raw.addEntries(entries);
  }

  @override
  int get size => raw.values.length;

  @override
  String toString() {
    final params = <String>[];
    for (final (name, value) in entries()) {
      params.add('${encodeURIComponent(name)}=${encodeURIComponent(value)}');
    }

    return params.join('&');
  }
}
