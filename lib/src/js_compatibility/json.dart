library stdweb.json;

import 'dart:convert' show JsonEncoder, json;

abstract interface class JSON {
  /// Converts a JavaScript Object Notation (JSON) string into an object.
  ///
  /// - [text] A valid JSON string.
  /// - [reviver] A function that transforms the results. This function is called
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse)
  static parse(String text,
          [Object? Function(Object? key, Object? value)? reviver]) =>
      json.decode(text, reviver: reviver);

  /// Converts a JavaScript value to a JavaScript Object Notation (JSON) string.
  ///
  /// - [value] The value to convert to a JSON string.
  /// - [replacer] A function that transforms the results.
  /// - [space] Adds indentation, white space, and line break characters to the return-value JSON text to make it easier to read.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify)
  static String stringify(Object? value,
      [Object? Function(dynamic value)? replacer, Object? space]) {
    if (space != null) {
      final indent = switch (space) {
        final String indent => indent,
        final num space => ' ' * space.toInt(),
        _ => throw ArgumentError.value(
            space, 'space', 'Invalid value, must be a String, int or double')
      };
      final encoder = JsonEncoder.withIndent(indent, replacer);
      return encoder.convert(value);
    }

    return json.encode(value, toEncodable: replacer);
  }
}
