import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../_internal/line_terminator.dart';
import '../_internal/uint8list_stream.dart';

part '_internal/blob.dart';

/// A file-like object of immutable, raw data. Blobs represent data that isn't necessarily in a JavaScript-native format. The File interface is based on Blob, inheriting blob functionality and expanding it to support files on the user's system.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob)
class Blob {
  final Stream<Uint8List> _stream;
  Uint8List? _buffer;

  /// Returns a newly created Blob object which contains a concatenation of all
  /// of the data in the array passed into the constructor.
  ///
  /// ## Parameters
  /// - [blobParts] An [Iterable] of [String] | [Uint8List] | [Blob] | [int]
  ///   objects. This is the array of values that will make up the blob content.
  /// - [endings] How to interpret newline characters (\n) within the contents,
  ///   if the data is text. The default value, transparent, copies newline
  ///   characters into the blob without changing them. To convert newlines to
  ///   the host system's native convention, specify the value native.
  /// - [type] The MIME type of the data that makes up the blob. If not
  ///   specified, the value will be an empty string.
  factory Blob(
    Iterable<Object> blobParts, {
    EndingType? endings,
    String? type,
  }) = _Blob;

  /// Creates a new [Blob] object from raw values.
  ///
  /// **Note**: Expose this method to facilitate the use of more subclasses
  /// based on [Blob] implementation.
  Blob.from(
    Stream<Uint8List> stream, {
    required this.size,
    String? type,
  })  : _stream = stream,
        type = type ?? '';

  /// The size, in bytes, of the data contained in the Blob object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/size)
  final int size;

  /// A string indicating the MIME type of the data contained in the Blob.
  /// If the type is unknown, this string is empty.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/type)
  final String type;

  /// Returns a promise that resolves with an ArrayBuffer containing the entire
  /// contents of the Blob as binary data.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/arrayBuffer)
  Future<Uint8List> arrayBuffer() async {
    if (_buffer is Uint8List) return _buffer!;

    final chunks = <Uint8List>[];
    await _stream.forEach(chunks.add);

    _buffer =
        Uint8List.fromList(chunks.expand((e) => e).toList(growable: false));

    final completer = Completer<Uint8List>();
    completer.complete(_buffer);

    return completer.future;
  }

  /// Returns a new Blob object containing the data in the specified range of bytes of the blob on which it's called.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/slice)
  Blob slice([int? start, int? end, String? contentType]) {
    final target = stream().slice(size, start, end);

    return Blob.from(target.stream,
        size: target.size, type: contentType ?? type);
  }

  /// Returns a [Stream] that can be used to read the contents of the Blob.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/stream)
  Stream<Uint8List> stream() => Stream.fromFuture(arrayBuffer());

  /// Returns a promise that resolves with a string containing the entire
  /// contents of the Blob interpreted as UTF-8 text.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/text)
  Future<String> text() async =>
      utf8.decode(await arrayBuffer(), allowMalformed: true);
}

enum EndingType {
  native,
  transparent,
}
