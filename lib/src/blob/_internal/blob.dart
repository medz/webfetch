part of '../blob.dart';

class _Blob extends Blob {
  _Blob._(super.stream, {required super.size, super.type}) : super.from();

  factory _Blob(
    Iterable<Object> blobParts, {
    EndingType? endings,
    String? type,
  }) {
    // If the blobParts is Uint8List
    if (blobParts is Uint8List) {
      return _Blob._(Stream.value(blobParts),
          size: blobParts.lengthInBytes, type: type);

      // If the blobParts is Iterable<int>
    } else if (blobParts is Iterable<int>) {
      final stream = Stream.value(Uint8List.fromList(blobParts.toList()));
      return _Blob._(stream, size: blobParts.length, type: type);
    }

    int size = 0;
    final chunks = <FutureOr<Uint8List>>[];
    for (final part in blobParts) {
      switch (part) {
        case String value:
          final chunk =
              _str2uint8list(value, endings ?? EndingType.transparent);
          chunks.add(chunk);
          size += chunk.lengthInBytes;
          break;
        case Uint8List bytes:
          chunks.add(bytes);
          size += bytes.lengthInBytes;
          break;
        case Blob blob:
          chunks.add(blob.arrayBuffer());
          size += blob.size;
          break;
        case int byte:
          chunks.add(Uint8List.fromList([byte]));
          size += 1;
          break;
        default:
          throw ArgumentError.value(
              part, 'blobParts', 'Invalid type for blobParts');
      }
    }

    final futureChunks = chunks.map((e) => Future.value(e));

    return _Blob._(Stream.fromFutures(futureChunks), size: size, type: type);
  }

  /// Returns a Uint8List from a String.
  static Uint8List _str2uint8list(String value, EndingType endings) {
    final converted = switch (endings) {
      EndingType.transparent => value,
      EndingType.native => LineSplitter.split(value).join(lineTerminator)
    };

    return utf8.encoder.convert(converted);
  }
}
