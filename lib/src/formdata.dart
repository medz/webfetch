import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mime/mime.dart';

import 'blob.dart';
import 'file.dart';
import 'headers.dart';

typedef _StorageValue = (String? string, File? blob);

/// Provides a way to easily construct a set of key/value pairs representing
/// form fields and their values, which can then be easily sent using the
/// XMLHttpRequest.send() method. It uses the same format a form would use if
/// the encoding type were set to "multipart/form-data".
///
/// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
class FormData {
  /// Internal storage for the FormData.
  final List<(String, _StorageValue)> _storage = [];

  /// Creates a new FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/FormData)
  FormData();

  /// Appends a new value onto an existing key inside a FormData object, or
  /// adds the key if it does not already exist.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/append)
  void append(String name, Object value, [String? filename]) {
    final typedValue = switch (value) {
      File file => (null, file.copyWithName(filename)),
      Blob blob => (null, File([blob], filename ?? 'blob', type: blob.type)),
      String string => (string, null),
      _ => (value.toString(), null),
    };

    _storage.add((name, typedValue));
  }

  /// Deletes a key/value pair from a FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/delete)
  void delete(String name) =>
      _storage.removeWhere((element) => element.$1 == name);

  /// Returns an iterator that iterates through all key/value pairs contained
  /// in the FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/entries)
  Iterable<(String, Object)> entries() sync* {
    for (final (name, typed) in _storage) {
      final value = typed.toObject();
      if (value == null) continue;
      yield (name, value);
    }
  }

  /// Returns the first value associated with a given key from within a
  /// FormData object.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/get)
  Object? get(String name) =>
      entries().firstWhereOrNull((element) => element.$1 == name)?.$2;

  /// Returns an array of all the values associated with a given key from
  /// within a FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/getAll)
  Iterable<Object> getAll(String name) => entries()
      .where((element) => element.$1 == name)
      .map((element) => element.$2);

  /// Returns whether a FormData object contains a certain key.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/has)
  bool has(String name) => _storage.any((element) => element.$1 == name);

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
  Iterable<String> keys() => _storage.map((element) => element.$1).toSet();

  /// Returns an iterator that iterates through all values contained in the FormData.
  ///
  /// [MDN reference](https://developer.mozilla.org/en-US/docs/Web/API/FormData/values)
  Iterable<Object> values() => entries().map((element) => element.$2);

  /// Global helper, encode a [FormData] object to a [Stream] of [Uint8List]
  /// chunks.
  static Stream<Uint8List> encode(FormData fromData, String boundary) =>
      _FromDataStream(fromData, boundary);

  /// Global helper, decode a [Stream] of [Uint8List] chunks to a [FormData]
  /// object.
  static Future<FormData> decode(Stream<Uint8List> stream, String boundary) =>
      _FormDataDecoder(boundary).decode(stream);
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension on File {
  /// Copy with a new [name].
  File copyWithName([String? name]) {
    if (name == null) return this;

    return File([this], name,
        endings: EndingType.transparent,
        type: type,
        lastModified: lastModified);
  }
}

extension on _StorageValue {
  Object? toObject() {
    return switch (this) {
      (String value, _) => value,
      (_, Blob blob) => blob,
      _ => null,
    };
  }
}

class _FormDataDecoder extends MimeMultipartTransformer {
  _FormDataDecoder(super.boundary);

  /// Creates a new [FormData] object from a [Stream] of [Uint8List] chunks.
  Future<FormData> decode(Stream<Uint8List> stream) async {
    final formData = FormData();

    await for (final part in bind(stream)) {
      final headers = Headers(part.headers);
      final contentType = headers.get('content-type') ?? '';

      final contentDisposition = headers.get('content-disposition');
      if (contentDisposition == null || contentDisposition.isEmpty) continue;

      final (name, filename) = parseContentDisposition(contentDisposition);
      if (name == null) continue;

      final buffer = <int>[];
      await part.forEach(buffer.addAll);

      final Uint8List bytes = Uint8List.fromList(buffer);
      final Blob blob = Blob([bytes], type: contentType);

      formData.append(name, blob, filename);
    }

    return formData;
  }

  /// Parses the multipart content-disposition header.
  ///
  /// Returns a tuple with the name and filename.
  (String? name, String? filename) parseContentDisposition(
      String contentDisposition) {
    final parts = contentDisposition.split(';').map((e) {
      return switch (e.trim().split('=')) {
        Iterable<String> part when part.length == 2 => (part.first, part.last),
        Iterable<String> part when part.length > 2 => (
            part.first,
            part.skip(1).join('=')
          ),
        _ => (e, ''),
      };
    });

    final name = parts.firstWhereOrNull((e) => e.$1.eq('name'))?.$2;
    final filename = parts.firstWhereOrNull((e) => e.$1.eq('filename'))?.$2;

    return (name?.escaped, filename?.escaped);
  }
}

extension on String {
  bool eq(String other) => toLowerCase() == other.toLowerCase();

  /// Returns the string ' and " escaped for start and end.
  String get escaped {
    String escaped = startsWith('"') ? substring(1) : this;
    escaped = endsWith('"') ? substring(0, length - 1) : escaped;

    escaped = startsWith("'") ? substring(1) : escaped;
    escaped = endsWith("'") ? substring(0, length - 1) : escaped;

    return escaped;
  }
}

class _FromDataStream with Stream<Uint8List> {
  final Stream<Uint8List> stream;

  _FromDataStream(FormData formData, String boundary)
      : assert(boundary.length <= 70,
            'The boundary length must be less than or equal to 70.'),
        stream = createFromDataStream(formData, boundary);

  @override
  StreamSubscription<Uint8List> listen(void Function(Uint8List event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static const lineTerminator = '\r\n';
  static final lineTerminatorBytes = utf8.encode(lineTerminator);

  static Stream<Uint8List> createFromDataStream(
      FormData formData, String boundary) async* {
    final separator = utf8.encode('--$boundary$lineTerminator');

    for (final (name, value) in formData.entries()) {
      yield separator;
      yield* switch (value) {
        String value => createStringMultipart(name, value),
        Blob blob => createBlobMultipart(name, blob),
        _ => Stream<Uint8List>.empty(),
      };
    }

    yield utf8.encode('--$boundary--$lineTerminator');
  }

  static Stream<Uint8List> createBlobMultipart(String name, Blob blob) async* {
    yield createMultipartHeader(name);
    yield utf8.encode('; filename="${blob.name}"');
    yield lineTerminatorBytes;
    yield utf8.encode('Content-Type: ${blob.contentType}');
    yield lineTerminatorBytes;
    yield lineTerminatorBytes;
    yield* blob.stream();
    yield lineTerminatorBytes;
  }

  static Stream<Uint8List> createStringMultipart(
      String name, String value) async* {
    yield createMultipartHeader(name);
    yield lineTerminatorBytes;
    yield lineTerminatorBytes;
    yield utf8.encode(value);
    yield lineTerminatorBytes;
  }

  static Uint8List createMultipartHeader(String name) {
    return utf8.encode('Content-Disposition: form-data; name="$name"');
  }
}

extension on Blob {
  /// Returns the blob name, If the Blob was created from a File object, the
  /// name property returns the name of the file.
  ///
  /// Otherwise it returns an 'blob' string.
  String get name {
    return switch (this) {
      File(name: final name) => name,
      _ => 'blob',
    };
  }

  /// Returns the blob content type, If value is empty, the type property
  /// returns an "application/octet-stream" string.
  String get contentType {
    return switch (type) {
      String type when type.isNotEmpty => type,
      _ => 'application/octet-stream',
    };
  }
}
