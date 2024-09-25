typedef _Part = (String, String);

extension on _Part {
  String get asSerialized {
    final buffer = StringBuffer();
    buffer.write(Uri.encodeQueryComponent($1));
    if ($2.isNotEmpty) {
      buffer.write('=');
      buffer.write(Uri.encodeQueryComponent($2));
    }

    return buffer.toString();
  }
}

extension on String {
  _Part get asPart {
    final [name, ...values] = split('=');
    if (values.isEmpty) {
      return (Uri.decodeQueryComponent(name), '');
    }

    final value = values.join('=');
    return (Uri.decodeQueryComponent(name), Uri.decodeQueryComponent(value));
  }
}

class _Inner extends Iterable<_Part> {
  const _Inner(this.store);

  final List<_Part> store;

  @override
  Iterator<_Part> get iterator => store.iterator;

  @override
  String toString() {
    return map((e) => e.asSerialized).join('&');
  }
}

List<_Part> _createPartsFromMap(Map<String, String> map) {
  return map.entries.map((e) => (e.key, e.value)).toList();
}

List<_Part> _parseUrlEncoded(String value) {
  if (value.startsWith('??')) {
    throw FormatException('Invalid URLSearchParams, '
        'It should not start with double question mark');
  }

  return (value.startsWith('?') ? value.substring(1) : value)
      .split('&')
      .map((e) => e.asPart)
      .toList();
}

/// MDN: https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams
/// Represents a collection of URL search parameters.
///
/// This extension type provides functionality to manipulate and iterate over
/// URL search parameters, implementing the [Iterable] interface for key-value pairs.
///
/// This class provides functionality to manipulate and iterate over URL search parameters,
/// allowing easy access and modification of query string components.
extension type URLSearchParams._(_Inner _) implements Iterable<_Part> {
  /// Creates a new instance of [URLSearchParams].
  ///
  /// The [init] parameter can be one of the following:
  /// - `Iterable<(String, String)>`: An iterable of key-value pairs.
  /// - `Map<String, String>`: A map of key-value pairs.
  /// - `String`: A URL-encoded string.
  /// - `null`: An empty instance.
  ///
  /// Throws [UnsupportedError] if the [init] value is not one of the supported types.
  factory URLSearchParams([Object? init]) {
    final store = switch (init) {
      Iterable<_Part> value => List<_Part>.from(value),
      Map<String, String> value => _createPartsFromMap(value),
      String value => _parseUrlEncoded(value),
      null => <_Part>[],
      _ => throw UnsupportedError(
          'Invalid init value, Only supports URLSearchParams, String, '
          'Map<String, String> or Iterable<${_Part.runtimeType}>'),
    };
    final inner = _Inner(store);

    return URLSearchParams._(inner);
  }

  /// Returns the number of key-value pairs in the URL search parameters.
  int get size => _.length;

  /// Appends a new key-value pair to the URL search parameters.
  ///
  /// If the key already exists, the new value is appended to the existing values.
  /// This allows multiple values to be associated with the same key.
  void append(String name, String value) {
    _.store.add((name, value));
  }

  /// Deletes key-value pairs with the given key from the URL search parameters.
  ///
  /// If [value] is provided, only pairs with matching key and value are deleted.
  /// If [value] is omitted, all pairs with the matching key are deleted.
  void delete(String name, [String? value]) {
    if (value != null) {
      return _.store.removeWhere((e) => e.$1 == name && e.$2 == value);
    }

    _.store.removeWhere((e) => e.$1 == name);
  }

  /// Returns an iterable of all key-value pairs in the URL search parameters.
  ///
  /// This method allows direct iteration over the parameters without modifying the underlying data.
  Iterable<(String, String)> entries() => this;

  /// Executes a provided function once for each key/value pair in the URLSearchParams.
  ///
  /// The callback function is called with the following arguments:
  /// - value: The value of the current key/value pair.
  /// - key: The key of the current key/value pair.
  ///
  /// Note: This method does not return a value.
  ///
  /// Example:
  /// ```dart
  /// final params = URLSearchParams('foo=1&bar=2');
  /// params.forEach((value, key) {
  ///   print('$key: $value');
  /// });
  /// ```
  void forEach(void Function(String value, String key) callback) {
    for (final (name, value) in this) {
      callback(value, name);
    }
  }

  /// Returns the first value associated with the given search parameter.
  ///
  /// If there are multiple values for the given parameter, only the first one is returned.
  /// If the parameter is not found, null is returned.
  ///
  /// Example:
  /// ```dart
  /// final params = URLSearchParams('foo=1&bar=2&foo=3');
  /// print(params.get('foo')); // Prints: 1
  /// print(params.get('baz')); // Prints: null
  /// ```
  String? get(String name) {
    for (final (key, value) in this) {
      if (key == name) return value;
    }

    return null;
  }

  /// Returns all values associated with the given search parameter.
  ///
  /// If there are multiple values for the given parameter, all of them are returned in an iterable.
  /// If the parameter is not found, an empty iterable is returned.
  ///
  /// Example:
  /// ```dart
  /// final params = URLSearchParams('foo=1&bar=2&foo=3');
  /// print(params.getAll('foo').toList()); // Prints: [1, 3]
  /// print(params.getAll('bar').toList()); // Prints: [2]
  /// print(params.getAll('baz').toList()); // Prints: []
  /// ```
  Iterable<String> getAll(String name) {
    return _.store.where((e) => e.$1 == name).map((e) => e.$2);
  }

  /// Checks if the specified parameter exists in the URLSearchParams.
  ///
  /// Returns true if the parameter exists, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final params = URLSearchParams('foo=1&bar=2');
  /// print(params.has('foo')); // Prints: true
  /// print(params.has('baz')); // Prints: false
  /// ```
  bool has(String name) {
    return _.store.any((e) => e.$1 == name);
  }

  /// Sets the value of a given search parameter, replacing any existing values.
  ///
  /// If the search parameter doesn't exist, it is created.
  void set(String name, String value) {
    delete(name);
    append(name, value);
  }

  /// Sorts all key/value pairs in-place, based on their keys.
  ///
  /// Sorting is done using a stable sorting algorithm.
  void sort() {
    _.store.sort((a, b) => a.$1.compareTo(b.$1));
  }

  /// Returns an iterable of all parameter names in the search params.
  Iterable<String> keys() => map((e) => e.$1);

  /// Returns an iterable of all parameter values in the search params.
  Iterable<String> values() => map((e) => e.$2);
}
