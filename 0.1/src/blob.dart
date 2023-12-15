import 'dart:typed_data';

/// A file-like object of immutable, raw data. Blobs represent data that isn't necessarily in a JavaScript-native format. The File interface is based on Blob, inheriting blob functionality and expanding it to support files on the user's system.
///
/// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob)
class Blob {
  /// Internal parts of the blob.
  ///
  /// Iterable of [String] | [TypedData] | [ByteBuffer] | [Blob]
  final Iterable<Object> _parts;

  /// A string indicating the MIME type of the data contained in the Blob.
  /// If the type is unknown, this string is empty.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/type)
  final String type;

  /// The size, in bytes, of the data contained in the Blob object.
  ///
  /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Blob/size)
  // int get size;
}
