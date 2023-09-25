import 'package:collection/collection.dart';

import '../_internal/case_insensitive_map.dart';
import '../dom/dom_iterable.dart';
import '../js_compatibility/encode_uri.dart';

part '_internal/url_search_params.dart';

/// The `URLSearchParams` interface defines utility methods to work
/// with the query string of a URL.
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
abstract class URLSearchParams
    extends DOMIterable<URLSearchParams, String, String> {
  final CaseInsensitiveMap<List<String>> _map;

  /// Internal constructor, to create a new instance of `URLSearchParams`.
  const URLSearchParams.from(CaseInsensitiveMap<List<String>> init)
      : _map = init;

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
  int get size => values().length;

  /// Appends a specified key/value pair as a new search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/append)
  void append(String name, String value) =>
      _map[name] = [..._map[name] ?? [], value];

  /// Deletes search parameters that match a name, and optional value,
  /// from the list of all search parameters.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/delete)
  void delete(String name, [String? value]) {
    if (value != null) {
      _map[name]?.remove(value);
    } else {
      _map.remove(name);
    }
  }

  /// Returns an iterator allowing iteration through all key/value pairs
  /// contained in this object in the same order as they appear in the
  /// query string.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/entries)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  @override
  Iterable<(String, String)> entries() sync* {
    for (final MapEntry(key: key, value: values) in _map.entries) {
      for (final value in values) {
        yield (key, value);
      }
    }
  }

  /// Allows iteration through all values contained in this object via a
  /// callback function.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/forEach)
  @override
  void forEach(
          void Function(String value, String name, URLSearchParams searchParams)
              fn) =>
      super.forEach(fn);

  /// Returns the first value associated with the given search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/get)
  String? get(String name) => _map[name]?.firstOrNull;

  /// Returns all the values associated with a given search parameter.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/getAll)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  Iterable<String> getAll(String name) => _map[name] ?? const [];

  /// Returns a boolean value indicating if a given parameter, or parameter
  ///  and value pair, exists.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/has)
  bool has(String name, [String? value]) {
    if (value == null) {
      return _map.containsKey(name);
    }

    return getAll(name).contains(value);
  }

  /// Returns an `Iterator` allowing iteration through all keys of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/keys)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  @override
  Iterable<String> keys() => super.keys();

  /// Sets the value associated with a given search parameter to the given
  /// value. If there are several values, the others are deleted.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/set)
  void set(String name, String value) => _map[name] = [value];

  /// Sorts all key/value pairs, if any, by their keys.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/sort)
  void sort() {
    final entries = _map.entries.sortedBy((element) => element.key);
    _map
      ..clear()
      ..addEntries(entries);
  }

  /// Returns a string containing a query string suitable for use in a URL.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/toString)
  @override
  String toString() => entries()
      .map((e) => '${encodeURIComponent(e.$1)}=${encodeURIComponent(e.$2)}')
      .join('&');

  /// Returns an iterator allowing iteration through all values of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/values)
  ///
  /// **Note**: In Dart language, Iterable's behavior is roughly similar
  /// to JS Iteration protocols, for ease of use! Therefore, use Iterable.
  @override
  Iterable<String> values() => super.values();
}
