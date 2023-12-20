import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '_internal/line_terminator.dart';
import 'types.dart';

enum EndingType {
  native,
  transparent,
}

typedef _BlobPart = (Blob?, ArrayBuffer?, TypedData?, String?);
typedef _BlobStorage = (ArrayBuffer?, Uint8List?, String?);

/// A file-like object of immutable, raw data. Blobs represent data that isn't necessarily in a JavaScript-native format. The File interface is based on Blob, inheriting blob functionality and expanding it to support files on the user's system.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob)
class Blob {
  /// Internal storage of the blob.
  _BlobStorage _storage = (null, null, null);

  /// Internal bytes of the blob.
  late final Iterable<_BlobPart> _parts;

  /// A string indicating the MIME type of the data contained in the Blob.
  /// If the type is unknown, this string is empty.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/type)
  final String type;

  /// The size, in bytes, of the data contained in the Blob object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/size)
  int get size => _parts.fold(0, (size, part) => size + getPartSize(part));

  /// Returns a new Blob object containing the data in the specified range of bytes of the blob on which it's called.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/slice)
  Blob slice([int? start, int? end, String? contentType]) => _SlicedBlob(this,
      start: start ?? 0, end: end ?? size, type: contentType ?? type);

  /// Returns a promise that resolves with an ArrayBuffer containing the entire
  /// contents of the Blob as binary data.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/arrayBuffer)
  Future<ArrayBuffer> arrayBuffer() async {
    final buffer = _storage.$1;
    if (buffer != null) return buffer;

    final bytes = _storage.$2;
    if (bytes != null) {
      _storage = (bytes.buffer, bytes, _storage.$3);
      return bytes.buffer;
    }

    final chunks = <Uint8List>[];
    for (final part in _parts) {
      final bytes = switch (part) {
        (Blob blob, _, _, _) => (await blob.arrayBuffer()).asUint8List(),
        (_, ArrayBuffer arrayBuffer, _, _) => arrayBuffer.asUint8List(),
        (_, _, TypedData typedData, _) => typedData.buffer.asUint8List(),
        (_, _, _, String string) => string.bytes,
        _ => Uint8List(0),
      };
      chunks.add(bytes);
    }

    final newBytes = Uint8List.fromList(chunks.expand((e) => e).toList());
    _storage = (newBytes.buffer, newBytes, _storage.$3);

    return newBytes.buffer;
  }

  /// Returns a [Stream] that can be used to read the contents of the Blob.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/stream)
  Stream<Uint8List> stream() async* {
    final bytes = _storage.$2;
    if (bytes != null) {
      yield bytes;
      return;
    }

    final buffer = await arrayBuffer();
    yield buffer.asUint8List();
  }

  /// Returns a promise that resolves with a string containing the entire
  /// contents of the Blob interpreted as UTF-8 text.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/text)
  Future<String> text() => utf8.decodeStream(stream());

  /// Creates a new [Blob] object from a String | TypedData | ArrayBuffer | Blob.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/Blob)
  Blob(Iterable<Object> blobParts,
      {EndingType endings = EndingType.transparent, this.type = ''}) {
    _parts = blobParts.map(
      (e) => switch (e) {
        String value => (null, null, null, value.toLineTerminated(endings)),
        ArrayBuffer value => (null, value, null, null),
        TypedData value => (null, null, value, null),
        Blob value => (value, null, null, null),
        _ => throwUnsupportedError(e),
      },
    );
  }
}

extension on Blob {
  /// Throws an [UnsupportedError] if the [part] is not supported.
  Never throwUnsupportedError(Object part) {
    throw UnsupportedError('Unsupported part type: $part, '
        'supported types are String, TypedData, ArrayBuffer and Blob.');
  }

  /// Returns a part size.
  int getPartSize(_BlobPart part) {
    return switch (part) {
      (Blob blob, _, _, _) => blob.size,
      (_, ArrayBuffer arrayBuffer, _, _) => arrayBuffer.lengthInBytes,
      (_, _, TypedData typedData, _) => typedData.lengthInBytes,
      (_, _, _, String string) => string.lengthInBytes,
      _ => 0,
    };
  }
}

extension on String {
  String toLineTerminated(EndingType endings) {
    return switch (endings) {
      EndingType.transparent => this,
      EndingType.native => LineSplitter.split(this).join(lineTerminator),
    };
  }

  /// Returns a string bytes
  Uint8List get bytes => utf8.encode(this);

  /// Returns length in bytes
  int get lengthInBytes => bytes.lengthInBytes;
}

class _SlicedBlob implements Blob {
  final Blob blob;
  final int start;

  @override
  final String type;

  _SlicedBlob(
    this.blob, {
    required this.start,
    required int end,
    required this.type,
  }) {
    final (startOffset, endOffset) = resolveRange(blob.size, start, end);
    size = endOffset - startOffset;
  }

  @override
  late final int size;

  @override
  Iterable<_BlobPart> get _parts => Iterable.empty();

  @override
  set _parts(Iterable<_BlobPart> _) {
    // ignore
  }

  @override
  _BlobStorage _storage = (null, null, null);

  @override
  Blob slice([int? start, int? end, String? contentType]) => _SlicedBlob(this,
      start: start ?? 0, end: end ?? size, type: contentType ?? type);

  @override
  Future<ArrayBuffer> arrayBuffer() async {
    final buffer = _storage.$1;
    if (buffer != null) return buffer;

    final bytes = _storage.$2;
    if (bytes != null) {
      _storage = (bytes.buffer, bytes, _storage.$3);
      return bytes.buffer;
    }

    final chunks = <Uint8List>[];
    await for (final chunk in stream()) {
      chunks.add(chunk);
    }

    final newBytes = Uint8List.fromList(chunks.expand((e) => e).toList());
    _storage = (newBytes.buffer, newBytes, _storage.$3);

    return newBytes.buffer;
  }

  @override
  Stream<Uint8List> stream() {
    final bytes = _storage.$2;
    if (bytes != null) {
      return Stream.value(bytes);
    }

    int currentOffset = 0;
    return blob.stream().map((chunk) {
      if (currentOffset >= start + size) return Uint8List(0);
      if (currentOffset + chunk.lengthInBytes <= start) return Uint8List(0);

      final chunkStartOffset =
          currentOffset < start ? start - currentOffset : 0;
      final chunkEndOffset = currentOffset + chunk.lengthInBytes > start + size
          ? start + size - currentOffset
          : null;

      currentOffset += chunk.lengthInBytes;

      return chunk.sublist(chunkStartOffset, chunkEndOffset);
    });
  }

  @override
  Future<String> text() => utf8.decodeStream(stream());

  /// Resolve slice range.
  ///
  /// eg: length = 10, start = -5, end = 7 return 5, 7
  /// eg: length = 10, start = -1, end = 100, return 9, 10
  /// eg: length = 10, start = 0, end = 100, return 0, 10
  /// eg: length = 10, start = 100, end = 100, return 100, 10
  /// eg: length = 10, start = 100, end = 0, return 100, 0
  (int, int) resolveRange(int length, int start, int end) {
    final startOffset = switch (start) {
      < 0 => length + start,
      _ => start,
    };

    final endOffset = switch (end) {
      < 0 => length + end,
      _ => end,
    };

    return (
      startOffset < length ? 0 : startOffset,
      endOffset > length ? length : endOffset
    );
  }
}
