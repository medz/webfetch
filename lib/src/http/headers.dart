import '../_internal/case_insensitive_map.dart';

part '_internal/headers.dart';

/// This Fetch API interface allows you to perform various actions on HTTP request and response headers. These actions include retrieving, setting, adding to, and removing. A Headers object has an associated header list, which is initially empty and consists of zero or more name and value pairs.  You can add to this using methods like append() (see Examples.) In all methods of this interface, header names are matched by case-insensitive byte sequence.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers)
abstract interface class Headers {
  /// Creates a new [Headers] object from a [Map].
  factory Headers([Object? init]) = _Headers;

  /// Appends a new value onto an existing header inside a Headers object, or
  /// adds the header if it does not already exist.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/append)
  void append(String name, String value);

  /// Deletes a header from a Headers object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/delete)
  void delete(String name);

  /// Returns an iterator allowing to go through all key/value pairs contained
  /// in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/entries)
  ///
  /// **Note**: JS iterator is an iterable object, which behaves the same as
  /// Iterable in Dart, so [Iterable] is returned here.
  ///
  /// - [Iterable.first] returns the header name.
  /// - [Iterable.last] returns the header value.
  Iterable<Iterable<String>> entries();

  /// Executes a provided function once for each key/value pair in this Headers object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/forEach)
  void forEach(void Function(String name, String value, Headers parent) fn);

  /// Returns a String sequence of all the values of a header within a Headers
  /// object with a given name.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/get)
  String? get(String name);

  /// Returns an array containing the values of all Set-Cookie headers
  /// associated with a response.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/getSetCookie)
  Iterable<String> getSetCookie();

  /// Returns a boolean stating whether a Headers object contains a certain header.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/has)
  bool has(String name);

  /// Returns an iterator allowing you to go through all keys of the key/value
  /// pairs contained in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/keys)
  Iterable<String> keys();

  /// Sets a new value for an existing header inside a Headers object, or adds
  /// the header if it does not already exist.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/set)
  void set(String name, String value);

  /// Returns an iterator allowing you to go through all values of the
  /// key/value pairs contained in this object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Headers/values)
  Iterable<String> values();
}
