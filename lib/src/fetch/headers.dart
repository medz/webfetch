import '../_internal/case_insensitive_map.dart';
import '../dom/dom_iterable.dart';

part '_internal/headers.dart';

/// This Fetch API interface allows you to perform various actions on HTTP request and response headers. These actions include retrieving, setting, adding to, and removing. A Headers object has an associated header list, which is initially empty and consists of zero or more name and value pairs.  You can add to this using methods like append() (see Examples.) In all methods of this interface, header names are matched by case-insensitive byte sequence.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers)
abstract class Headers extends DOMIterable<Headers, String, String> {
  final CaseInsensitiveMap<List<String>> _map;

  /// Internal constructor, to create a new instance of `Headers`.
  const Headers.from(CaseInsensitiveMap<List<String>> init) : _map = init;

  /// Creates a new [Headers] object from a [Map].
  factory Headers([Object? init]) = _Headers;

  /// Appends a new value onto an existing header inside a Headers object, or
  /// adds the header if it does not already exist.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/append)
  void append(String name, String value) =>
      _map[name] = [..._map[name] ?? [], value];

  /// Deletes a header from a Headers object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/delete)
  void delete(String name) => _map.remove(name);

  /// Returns an iterator allowing to go through all key/value pairs contained
  /// in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/entries)
  @override
  Iterable<(String, String)> entries() sync* {
    for (final MapEntry(key: key, value: value) in _map.entries) {
      yield (key, value.join(', '));
    }
  }

  /// Executes a provided function once for each key/value pair in this Headers object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/forEach)
  @override
  void forEach(void Function(String value, String name, Headers parent) fn) =>
      super.forEach(fn);

  /// Returns a String sequence of all the values of a header within a Headers
  /// object with a given name.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/get)
  String? get(String name) => _map[name]?.join(', ');

  /// Returns an array containing the values of all Set-Cookie headers
  /// associated with a response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/getSetCookie)
  Iterable<String> getSetCookie() => _map['Set-Cookie'] ?? const <String>[];

  /// Returns a boolean stating whether a Headers object contains a certain header.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/has)
  bool has(String name) => _map.containsKey(name);

  /// Returns an iterator allowing you to go through all keys of the key/value
  /// pairs contained in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/keys)
  @override
  Iterable<String> keys() => _map.keys;

  /// Sets a new value for an existing header inside a Headers object, or adds
  /// the header if it does not already exist.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/set)
  void set(String name, String value) => _map[name] = [value];

  /// Returns an iterator allowing you to go through all values of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/values)
  @override
  Iterable<String> values() => _map.values.map((e) => e.join(', '));
}
