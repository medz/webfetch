import 'package:collection/collection.dart';

import '../_internal/case_insensitive_map.dart';
import '../js_compatibility/encode_uri.dart';

part '_internal/url_search_params.dart';

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
  Iterable<Iterable<String>> entries();

  /// Allows iteration through all values contained in this object via a
  /// callback function.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/forEach)
  void forEach(
      void Function(String value, String name, URLSearchParams searchParams)
          fn);

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
