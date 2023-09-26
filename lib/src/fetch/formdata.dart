import 'package:stdweb/src/_internal/case_insensitive_map.dart';

import '../dom/dom_iterable.dart';
import '../file/blob.dart';
import '../file/file.dart';

sealed class FormDataEntryValue {}

class FormDataEntryValueString implements FormDataEntryValue {
  const FormDataEntryValueString(this.value);
  final String value;

  @override
  String toString() => value;
}

class FormDataEntryValueFile extends File implements FormDataEntryValue {
  FormDataEntryValueFile.from(
    super.stream, {
    required super.size,
    required super.type,
    required super.lastModified,
    required super.name,
  }) : super.from();

  factory FormDataEntryValueFile.fromFile(File file, [String? filename]) =>
      FormDataEntryValueFile.from(
        file.stream(),
        size: file.size,
        type: file.type,
        lastModified: file.lastModified,
        name: filename ?? file.name,
      );

  factory FormDataEntryValueFile(
    Iterable<Object> blobParts,
    String fileName, {
    EndingType? endings,
    String? type,
    int? lastModified,
  }) {
    final file = File(blobParts, fileName,
        endings: endings, type: type, lastModified: lastModified);

    return FormDataEntryValueFile.fromFile(file);
  }

  @override
  String toString() => name;
}

/// Provides a way to easily construct a set of key/value pairs representing
/// form fields and their values, which can then be easily sent using the
/// XMLHttpRequest.send() method. It uses the same format a form would use if
/// the encoding type were set to "multipart/form-data".
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
class FormData extends DOMIterable<FormData, String, FormDataEntryValue> {
  final _map = CaseInsensitiveMap<List<FormDataEntryValue>>();

  /// Creates a new FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/FormData)
  FormData();

  /// Appends a new value onto an existing key inside a FormData object, or
  /// adds the key if it does not already exist.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/append)
  void append(String name, Object value, [String? filename]) {
    final FormDataEntryValue entry = switch (value) {
      final String value => FormDataEntryValueString(value),
      final File file =>
        FormDataEntryValueFile.fromFile(file, filename ?? file.name),
      final Blob blob => FormDataEntryValueFile([blob], filename ?? 'Blob'),
      final FormDataEntryValue entry => entry,
      _ => throw ArgumentError.value(value, 'value', 'Unsupported type'),
    };

    _map[name] = [...?_map[name], entry];
  }

  /// Deletes a key/value pair from a FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/delete)
  void delete(String name) => _map.remove(name);

  /// Returns an iterator that iterates through all key/value pairs contained
  /// in the FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/entries)
  @override
  Iterable<(String, FormDataEntryValue)> entries() sync* {
    for (final MapEntry(key: key, value: values) in _map.entries) {
      for (final value in values) {
        yield (key, value);
      }
    }
  }

  /// Returns the first value associated with a given key from within a
  /// FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/get)
  FormDataEntryValue? get(String name) => _map[name]?.firstOrNull;

  /// Returns an array of all the values associated with a given key from
  /// within a FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/getAll)
  List<FormDataEntryValue> getAll(String name) => _map[name] ?? const [];

  /// Returns whether a FormData object contains a certain key.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/has)
  bool has(String name) => _map.containsKey(name);

  /// Sets a new value for an existing key inside a FormData object, or adds the key/value if it does not already exist.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/set)
  void set(String name, Object value, [String? filename]) {
    delete(name);
    append(name, value, filename);
  }

  /// Returns an iterator iterates through all keys of the key/value pairs
  /// contained in the FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/keys)
  @override
  Iterable<String> keys() => super.keys();

  /// Returns an iterator that iterates through all values contained in the FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/values)
  @override
  Iterable<FormDataEntryValue> values() => super.values();
}
