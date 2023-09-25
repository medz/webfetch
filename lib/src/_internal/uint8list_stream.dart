import 'dart:async';
import 'dart:typed_data';

class SizedUint8ListStreamWrapper {
  final Stream<Uint8List> stream;
  final int size;

  const SizedUint8ListStreamWrapper(this.stream, this.size);
}

extension SliceUint8ListStream on Stream<Uint8List> {
  /// Returns a new [Stream] containing the data in the specified range of bytes of the stream on which it's called.
  ///
  /// - [start] An index into the Stream indicating the first byte to include in the new Stream. If you specify a negative value, it's treated as an offset from the end of the Stream toward the beginning. For example, -10 would be the 10th from last byte in the Stream. The default value is 0. If you specify a value for start that is larger than the size of the source Stream, the returned Stream has size 0 and contains no data.
  /// - [end] An index into the Stream indicating the first byte that will *not* be included in the new Stream (i.e. the byte exactly at this index is not included). If you specify a negative value, it's treated as an offset from the end of the Stream toward the beginning. For example, -10 would be the 10th from last byte in the Stream. The default value is size.
  SizedUint8ListStreamWrapper slice(int size, [int? start, int? end]) {
    final startOffset = resolveSliceRange(start ?? 0, min: -size, max: size);
    final endOffset = resolveSliceRange(end ?? size, min: -size, max: size);

    if (startOffset >= endOffset || startOffset >= size || endOffset == 0) {
      return const SizedUint8ListStreamWrapper(Stream.empty(), 0);
    }

    Stream<Uint8List> sliceStream() async* {
      int currentOffset = 0;
      await for (final chunk in this) {
        if (currentOffset >= endOffset) break;
        if (currentOffset + chunk.lengthInBytes <= startOffset) continue;

        final chunkStartOffset =
            currentOffset < startOffset ? startOffset - currentOffset : 0;
        final chunkEndOffset = currentOffset + chunk.lengthInBytes > endOffset
            ? endOffset - currentOffset
            : null;

        yield chunk.sublist(chunkStartOffset, chunkEndOffset);
        currentOffset += chunk.length;
      }
    }

    final sliceSize = endOffset - startOffset;

    return SizedUint8ListStreamWrapper(sliceStream(), sliceSize);
  }

  static int resolveSliceRange(
    int value, {
    required int min,
    required int max,
  }) {
    assert(value >= min && value <= max,
        'The value of start must be between $min-$max');

    return switch (value) {
      < 0 => max + value,
      _ => value,
    };
  }
}
